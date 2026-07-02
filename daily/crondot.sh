#!/usr/bin/env zsh
source ~/.zshrc
cd $HOME/.dotfiles
echo - in dotfiles

# These dotfiles are shared across multiple machines. If every machine advanced
# submodules to upstream master and committed the moved pointers, each would
# write divergent commits to main and later collide on push/pull. Instead,
# exactly ONE machine is the "primary": it bumps submodules and commits+pushes
# the new pointers. Every other machine just pulls and checks out whatever the
# primary recorded, so all machines run identical versions with no divergence.
#
# Designate the primary by creating this marker LOCALLY (it is not in the repo):
#   touch ~/.cron_support/dotfiles_primary
PRIMARY_MARKER=~/.cron_support/dotfiles_primary

# Always pull the parent repo first so we pick up pointers the primary pushed.
# --autostash preserves in-progress working changes (sql edits, theme tweaks)
# across the rebase so a dirty tree doesn't abort the pull.
git pull --rebase --autostash || echo - WARNING: parent pull failed, continuing

if [[ -f $PRIMARY_MARKER ]]; then
  echo - primary machine: advancing submodules to upstream master
  gsm
  echo - updated modules
  gsp
  echo - pulled modules

  # Record any moved submodule pointers. Path-limited commit so unrelated
  # in-progress edits are never swept into the bump; only commit + push when a
  # pointer actually changed. Push fast-forwards because only the primary writes.
  submodule_paths=("${(@f)$(git config --file .gitmodules --get-regexp '\.path$' | awk '{print $2}')}")
  if (( ${#submodule_paths} )) && ! git diff --quiet -- $submodule_paths; then
    git commit -m "chore: nightly submodule bump $(date +%Y-%m-%d)" -- $submodule_paths \
      && git push \
      && echo - committed and pushed submodule pointers
  else
    echo - no submodule changes to commit
  fi
else
  echo - follower machine: syncing submodules to recorded pointers
  git submodule update --init --recursive
fi

nvim_up
# echo - updated vim plugs

touch ~/.cron_support/crondot.txt
echo - touched dot

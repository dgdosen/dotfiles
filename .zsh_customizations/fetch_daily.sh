# Interactive helper: fetch the repos that are NOT covered by a scheduled job.
#
# Everything project_b used to be listed here, one `cd X; git fetch` per repo.
# That moved to ~/.project_b/jobs/project_b_repo_sync.sh
# (com.makerboarding.project_b_repo_sync, nightly at 02:30), which clones what
# is missing, fast-forwards what is safe, and reports what it skipped — none of
# which this could do. Duplicating the list here would only let the two drift.
#
# Note what was quietly removed rather than migrated: sessuru_server,
# sessuru_client, project_b_matching and project_b_generic_matching were all
# still being fetched here long after they stopped existing under ~/dev, so
# every run failed the `cd` and then fetched the *previous* repo a second time.

fetchthegits() {
  local start=$PWD repo
  local -a repos=(
    ~/.dotfiles
    ~/dev/alacritty
  )

  for repo in $repos; do
    if [ -d "$repo/.git" ]; then
      printf '%-40s ' "${repo:t}"
      git -C "$repo" fetch && echo "fetched"
    else
      echo "${repo:t}: not a git repo, skipped"
    fi
  done

  # The project_b fleet, same code path the launch agent uses — but only when a
  # human typed this. daily/cronfetch.sh sources ~/.zshrc and calls fetchthegits
  # from a NON-interactive shell at 01:06, and com.makerboarding.project_b_repo_sync
  # already runs at 02:30; without this guard the fleet would sync twice a night.
  if [[ -o interactive ]] && [ -x ~/.project_b/jobs/project_b_repo_sync.sh ]; then
    ~/.project_b/jobs/project_b_repo_sync.sh
  fi

  cd "$start"
}

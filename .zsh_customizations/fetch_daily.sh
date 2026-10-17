# Interactive helper: fetch the repos that are NOT covered by a scheduled job.
#
# Nothing project_b lives here — not the repo list, and not a call into it.
# Every project_b working tree is owned by ~/.project_b/jobs/project_b_repo_sync.sh
# (com.makerboarding.project_b_repo_sync, nightly at 02:30), which clones what
# is missing, fast-forwards what is safe, and reports what it skipped. To sync
# the fleet by hand, run that script directly.
#
# This used to end by calling that script when invoked interactively. Removed
# 2026-10-17 so ~/.project_b is the single owner of the project_b repos: a
# dotfiles function reaching into another repo's job script was a second entry
# point that could drift from — or outlive — the job it wrapped.
#
# Note what was quietly removed rather than migrated: sessuru_server,
# sessuru_client, project_b_matching and project_b_generic_matching were all
# still being fetched here long after they stopped existing under ~/dev, so
# every run failed the `cd` and then fetched the *previous* repo a second time.

fetchthegits() {
  local repo
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
}

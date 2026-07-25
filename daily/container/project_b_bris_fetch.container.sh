#!/usr/bin/env zsh
#
# Containerized variant of project_b_bris_fetch.sh — BRISnet data fetch.
#
#   bris -> project_b_brisnet_scrape_cli:bun   (headful Chromium under Xvfb)
#
# The odd one out in the fleet: it is the only scraper that writes to and PUSHES
# a git repository (project_b_data_2023, ~750MB). Unlike equibase/drf it does NOT
# download to /share — the BRIS zips are transient (downloaded, extracted into
# the git tree, then discarded), so the ONLY durable mount is the git working
# tree at /data_git.
#
# Sequence inside the container:
#   download zips -> /tmp/bris_downloads   (inside the container, no mount)
#   git pull      -> /data_git             (project_b_data_2023)
#   extract zips into the working tree, git add / commit / PUSH
#   POST an import_file record to the prod API (REACT_APP_API_ROOT, /api)
#
# HAZARD (idempotency): a push that fails mid-sequence leaves the durable
# /data_git mount in one of two bad states — a committed-but-unpushed HEAD, or a
# dirty working tree. A clean run leaves NEITHER, so either one means the prior
# run died partway. reconcile_data_repo() below settles that host-side BEFORE
# launching the container, so a re-run does not extract on top of unpushed work.

source ~/.zshrc
source "${0:A:h}/_lib.sh"   # acquire_lock, ensure_podman, assert_prod_env, env_val, SHARE_HOST

acquire_lock "$HOME/.cron_support/project_b_bris_fetch.container.lock"

# ---------------------------------------------------------------- config ----

BRIS_IMAGE="${BRIS_IMAGE:-localhost/project_b_brisnet_scrape_cli:bun}"
BRIS_CLI_REPO="$HOME/dev/project_b_brisnet_scrape_cli"

# PRODUCTION ONLY, deliberately not overridable. This repo names the API root
# REACT_APP_API_ROOT (not API_ROOT / API_URL).
BRIS_ENV_FILE="$BRIS_CLI_REPO/.env.container.prod"

# The only durable output: the shared data git repo, mounted at /data_git and
# both committed AND pushed. The git identity (GIT_AUTHOR_*/GIT_COMMITTER_*) and
# GIT_SSH_COMMAND live in the env-file; only the SSH key needs mounting.
BRIS_DATA_REPO="$HOME/dev/project_b_data_2023"
SSH_KEY="$HOME/.ssh/id_ed25519"

# Bound the container run (see podman_run_bounded in _lib.sh). Observed 60-73s,
# but a git push of the ~750MB data repo can stall on the network far longer than
# that, so 1 hour rather than a tight multiple of the happy path. Worth having
# despite the short run: a wedged container leaves the durable /data_git mount
# mid-sequence, exactly the state reconcile_data_repo then has to clean up.
CONTAINER_TIMEOUT="${CONTAINER_TIMEOUT:-3600}"

# ------------------------------------------------------------- functions ----

# Reconcile a prior partial run before launching the container. A failed push
# leaves the durable /data_git mount in one of two bad states:
#   1. committed-but-unpushed HEAD -> push it here; re-extracting would duplicate
#   2. dirty working tree          -> hard-fail; the container's `git pull` would
#                                     conflict, and re-extracting compounds it
# A clean run leaves neither, so either state means the previous run died. Runs
# host-side, using the normal user SSH key/agent.
reconcile_data_repo() {
    local repo="$1" ahead

    # (2) dirty tree — surface it, do not paper over it.
    if [ -n "$(git -C "$repo" status --porcelain 2>/dev/null)" ]; then
        echo "[BRIS] ✗ REFUSING TO RUN: $repo has uncommitted changes."
        echo "[BRIS]   A prior run likely failed after extracting but before it"
        echo "[BRIS]   committed. Inspect and resolve by hand, then re-run."
        return 1
    fi

    # (1) committed-but-unpushed — push it before doing any more work.
    ahead=$(git -C "$repo" rev-list --count '@{u}..HEAD' 2>/dev/null || echo 0)
    if [ "${ahead:-0}" -gt 0 ]; then
        echo "[BRIS] $ahead unpushed commit(s) from a prior run — pushing before fetch."
        if ! git -C "$repo" push; then
            echo "[BRIS] ✗ could not push the outstanding commit(s). Fix the remote/auth"
            echo "[BRIS]   and re-run; NOT starting a fetch on top of unpushed work."
            return 1
        fi
        echo "[BRIS] ✓ outstanding commit(s) pushed; tree reconciled."
    fi
    return 0
}

# ------------------------------------------------------------------ main ----

echo "=================================================="
echo "Project B BRISnet Fetch (containerized)"
echo "Started: $(date)"
echo "=================================================="

if ! ensure_podman; then
    echo "✗ podman unavailable — skipping. Nothing was fetched."
    exit 1
fi

if ! assert_prod_env BRIS "$BRIS_ENV_FILE" REACT_APP_API_ROOT; then exit 1; fi

if [ ! -d "$BRIS_DATA_REPO/.git" ]; then
    echo "✗ $BRIS_DATA_REPO is not a git repo — cannot commit/push. Skipping."
    exit 1
fi
if [ ! -f "$SSH_KEY" ]; then
    echo "✗ SSH key $SSH_KEY missing — push would fail. Skipping."
    exit 1
fi

if ! reconcile_data_repo "$BRIS_DATA_REPO"; then exit 1; fi

echo "[BRIS] data repo: $BRIS_DATA_REPO -> /data_git (headful Chromium under Xvfb)"

# download zips -> extract into /data_git -> git add/commit/PUSH -> POST /api.
# Download folder stays inside the container (transient zips), so /data_git and
# the SSH key are the only mounts. The image entrypoint wraps `bun src/index.ts`
# in Xvfb; no subcommand args are needed (native runs plain `bun src/index.ts`).
podman_run_bounded \
    --env-file "$BRIS_ENV_FILE" \
    -v "$BRIS_DATA_REPO:/data_git:rw" \
    -v "$SSH_KEY:/root/.ssh/id_ed25519:ro" \
    "$BRIS_IMAGE"
rc=$?

if [ $rc -ne 0 ]; then
    echo "[BRIS] ✗ container exited $rc"
    exit $rc
fi

echo ""
echo "=================================================="
echo "BRISnet fetch completed: $(date)"
echo "=================================================="

touch ~/.cron_support/cron_project_b_bris_scrape.container.txt

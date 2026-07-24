#!/usr/bin/env zsh
#
# Containerized variant of project_b_equibase_program_scrape.sh — Equibase
# ENTRIES (programs). Built from the repo's readme.container.md.
#
#   program -> project_b_equibase_program_scrape_cli:bun
#
# Like twinspires_data it writes per-track JSON into a mounted git repo, but this
# one COMMITS AND PUSHES to a real remote every run (and `pull --rebase`s first),
# so it also mounts an SSH key and sets GIT_SSH_COMMAND. `fetch-all` then POSTs
# the entries to the prod API. Uses its own podman run (not _lib.sh run_container):
# it mounts /data_repo (not /share) and needs the git identity + key.

source ~/.zshrc
source "${0:A:h}/_lib.sh"   # acquire_lock, ensure_podman, assert_prod_env

acquire_lock "$HOME/.cron_support/project_b_equibase_program_scrape.container.lock"

# ---------------------------------------------------------------- config ----

EQB_IMAGE="${EQB_IMAGE:-localhost/project_b_equibase_program_scrape_cli:bun}"
EQB_CLI_REPO="$HOME/dev/project_b_equibase_program_scrape_cli"

# PRODUCTION ONLY: this CLI also runs against dev (.env.container.dev -> local
# Rails). This repo names the API root API_URL, not API_ROOT.
EQB_ENV_FILE="$EQB_CLI_REPO/.env.container.prod"

# Shared output git repo (entries land under /data_repo/entries/). Committed AND
# pushed to the remote, so the container needs a git identity, an SSH key, and
# network access.
EQB_DATA_REPO="$HOME/dev/project_b_equibase_data"
SSH_KEY="$HOME/.ssh/id_ed25519"

GIT_NAME="$(git -C "$EQB_DATA_REPO" config user.name 2>/dev/null || echo 'Daniel Dosen')"
GIT_EMAIL="$(git -C "$EQB_DATA_REPO" config user.email 2>/dev/null || echo 'dgdosen@gmail.com')"

# ------------------------------------------------------------------ main ----

echo "=================================================="
echo "Project B Equibase Program (entries) Scrape (containerized)"
echo "Started: $(date)"
echo "=================================================="

if ! ensure_podman; then
    echo "✗ podman unavailable — skipping. Nothing was scraped."
    exit 1
fi

if ! assert_prod_env EQB_PROGRAM "$EQB_ENV_FILE" API_URL; then exit 1; fi

if [ ! -d "$EQB_DATA_REPO/.git" ]; then
    echo "✗ $EQB_DATA_REPO is not a git repo — cannot commit/push. Skipping."
    exit 1
fi
if [ ! -f "$SSH_KEY" ]; then
    echo "✗ SSH key $SSH_KEY missing — push would fail. Skipping."
    exit 1
fi

echo "[EQB_PROGRAM] data repo: $EQB_DATA_REPO (commit+push as $GIT_NAME <$GIT_EMAIL>)"

# fetch-all: scrape entries -> /data_repo/entries -> git add/commit/PUSH -> POST.
podman run --rm \
    --env-file "$EQB_ENV_FILE" \
    -v "$EQB_DATA_REPO:/data_repo:rw" \
    -e GIT_AUTHOR_NAME="$GIT_NAME"    -e GIT_AUTHOR_EMAIL="$GIT_EMAIL" \
    -e GIT_COMMITTER_NAME="$GIT_NAME" -e GIT_COMMITTER_EMAIL="$GIT_EMAIL" \
    -v "$SSH_KEY:/root/.ssh/id_ed25519:ro" \
    -e GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=accept-new" \
    "$EQB_IMAGE" fetch-all
rc=$?

if [ $rc -ne 0 ]; then
    echo "[EQB_PROGRAM] ✗ container exited $rc"
    exit $rc
fi

echo ""
echo "=================================================="
echo "Equibase program scrape completed: $(date)"
echo "=================================================="

touch ~/.cron_support/cron_project_b_equibase_program_scrape.container.txt

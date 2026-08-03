#!/usr/bin/env zsh
#
# Containerized variant of project_b_twinspires_data_scrape.sh — the DATA scraper.
# Built from the repo's readme.container.md.
#
#   data -> project_b_twinspires_data_scrape_cli:bun
#
# Different from the odds container in two ways (hence podman_run_bounded with
# its own argument list rather than _lib.sh's run_container):
#   1. It writes per-track JSON into a mounted GIT WORKING TREE and commits it
#      locally (NEVER pushes) — so it mounts that repo at /data_repo, not /share.
#   2. A container inherits no git identity, and the commit fails without one, so
#      GIT_AUTHOR_*/GIT_COMMITTER_* are supplied as env vars.
#
# Config note: this CLI selects its API target at run time (dev/prod/all), so it
# uses a single .env.container carrying both, not a .env.container.prod. `fetch-all`
# (the command the native script runs) scrapes + writes + commits; it is not a
# prod-posting step, so there is no assert_prod_env here.

source ~/.zshrc
source "${0:A:h}/_lib.sh"   # acquire_lock, ensure_podman

acquire_lock "$HOME/.cron_support/project_b_twinspires_data_scrape.container.lock"

# ---------------------------------------------------------------- config ----

DATA_IMAGE="${DATA_IMAGE:-localhost/project_b_twinspires_data_scrape_cli:bun}"
DATA_CLI_REPO="$HOME/dev/project_b_twinspires_data_scrape_cli"
DATA_ENV_FILE="$DATA_CLI_REPO/.env.container"

# Git working tree the per-track JSON is written into and committed (never pushed).
DATA_OUTPUT_REPO="$HOME/dev/project_b_twinspires_data"

# Bound the container run (see podman_run_bounded in _lib.sh). Sized from a LIVE
# card, not from the logs: the nightly's 8-10s runs fire at 07:00 against an empty
# card and are wildly unrepresentative. A mid-day run on 2026-07-25 took ~13
# MINUTES to write and commit 11 races for one track.
#
# Raised 3600 -> 14400 on 2026-08-03. The 1-hour bound was sized for the
# one-track era and silently stopped being enough the moment the track list
# grew: every scheduled run from 2026-07-30 on was SIGKILLed mid-card (exit
# 137) — 23 files on 07-30, 24 on 07-31, 41 on 08-01, 16 on 08-03 — each one
# truncating a real card without saying so. Throughput swings widely with the
# site's pace (41 files in the hour on 08-01 vs 16 on 08-03), so this needs
# real headroom rather than a tight fit: 4 hours covers ~4 tracks at the WORST
# observed rate. Starting at 07:00, even a full run lands well before noon.
#
# If this starts getting killed again, the track list has grown again — raise
# it, don't shrink the work.
CONTAINER_TIMEOUT="${CONTAINER_TIMEOUT:-14400}"

# In-container commits need an identity (a container inherits none). Prefer the
# output repo's own git config so commits match its history; fall back to the
# values documented in readme.container.md.
GIT_NAME="$(git -C "$DATA_OUTPUT_REPO" config user.name 2>/dev/null || echo 'Daniel Dosen')"
GIT_EMAIL="$(git -C "$DATA_OUTPUT_REPO" config user.email 2>/dev/null || echo 'dgdosen@gmail.com')"

# ------------------------------------------------------------------ main ----

echo "=================================================="
echo "Project B TwinSpires Data Scrape (containerized)"
echo "Started: $(date)"
echo "=================================================="

if ! ensure_podman; then
    echo "✗ podman unavailable — skipping. Nothing was scraped."
    exit 1
fi

# The output repo must be a git working tree, or the in-container commit fails.
if [ ! -d "$DATA_OUTPUT_REPO/.git" ]; then
    echo "✗ $DATA_OUTPUT_REPO is not a git repo — cannot commit scraped data. Skipping."
    exit 1
fi

echo "[DATA] output repo: $DATA_OUTPUT_REPO (commit identity: $GIT_NAME <$GIT_EMAIL>)"

# fetch-all: scrape -> write per-track JSON into /data_repo -> git add/commit (local).
podman_run_bounded \
    --env-file "$DATA_ENV_FILE" \
    -v "$DATA_OUTPUT_REPO:/data_repo:rw" \
    -e GIT_AUTHOR_NAME="$GIT_NAME"    -e GIT_AUTHOR_EMAIL="$GIT_EMAIL" \
    -e GIT_COMMITTER_NAME="$GIT_NAME" -e GIT_COMMITTER_EMAIL="$GIT_EMAIL" \
    "$DATA_IMAGE" fetch-all
rc=$?

if [ $rc -ne 0 ]; then
    echo "[DATA] ✗ container exited $rc"
    exit $rc
fi

echo ""
echo "=================================================="
echo "TwinSpires data scrape completed: $(date)"
echo "=================================================="

touch ~/.cron_support/cron_project_b_twinspires_data_scrape.container.txt

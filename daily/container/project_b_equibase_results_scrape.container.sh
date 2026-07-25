#!/usr/bin/env zsh
#
# Containerized variant of project_b_equibase_results_scrape.sh — Equibase
# RESULT CHARTS. Built from the repo's readme.container.md.
#
#   results -> project_b_equibase_results_scrape_cli:bun
#
# The most involved image in the fleet — TWO mounts:
#   /data_repo <- project_b_equibase_data  (JSON output; committed AND PUSHED)
#   /share     <- the project_b share      (ARCHIVE_DIR, where result PDFs land)
# It downloads chart PDFs to ARCHIVE_DIR, runs pdftotext (a system binary baked
# into the image), parses, writes JSON, commits+pushes, and POSTs to the prod API.
# Needs a git identity + SSH key (it pushes) like the program scraper.

source ~/.zshrc
source "${0:A:h}/_lib.sh"   # acquire_lock, ensure_podman, assert_prod_env, env_val, SHARE_HOST

acquire_lock "$HOME/.cron_support/project_b_equibase_results_scrape.container.lock"

# ---------------------------------------------------------------- config ----

EQB_IMAGE="${EQB_IMAGE:-localhost/project_b_equibase_results_scrape_cli:bun}"
EQB_CLI_REPO="$HOME/dev/project_b_equibase_results_scrape_cli"

# PRODUCTION ONLY. This repo names the API root API_URL, not API_ROOT.
EQB_ENV_FILE="$EQB_CLI_REPO/.env.container.prod"

# Shared output git repo (results land under /data_repo/results/). Committed AND
# pushed, so the container needs a git identity, an SSH key, and network access.
EQB_DATA_REPO="$HOME/dev/project_b_equibase_data"
SSH_KEY="$HOME/.ssh/id_ed25519"

# Bound the container run (see podman_run_bounded in _lib.sh). Observed 8-69s,
# but that window is only a few evening runs and the 8s one clearly did no work,
# so treat it as a floor rather than a range: a heavy Saturday of charts to
# download, pdftotext and push could be far longer. 1 hour is deliberately loose
# — this bound is here to catch an infinite hang, not to fit the distribution.
CONTAINER_TIMEOUT="${CONTAINER_TIMEOUT:-3600}"

GIT_NAME="$(git -C "$EQB_DATA_REPO" config user.name 2>/dev/null || echo 'Daniel Dosen')"
GIT_EMAIL="$(git -C "$EQB_DATA_REPO" config user.email 2>/dev/null || echo 'dgdosen@gmail.com')"

# ------------------------------------------------------------------ main ----

echo "=================================================="
echo "Project B Equibase Results (charts) Scrape (containerized)"
echo "Started: $(date)"
echo "=================================================="

if ! ensure_podman; then
    echo "✗ podman unavailable — skipping. Nothing was scraped."
    exit 1
fi

if ! assert_prod_env EQB_RESULTS "$EQB_ENV_FILE" API_URL; then exit 1; fi

if [ ! -d "$EQB_DATA_REPO/.git" ]; then
    echo "✗ $EQB_DATA_REPO is not a git repo — cannot commit/push. Skipping."
    exit 1
fi
if [ ! -f "$SSH_KEY" ]; then
    echo "✗ SSH key $SSH_KEY missing — push would fail. Skipping."
    exit 1
fi

# ARCHIVE_DIR must resolve inside the /share mount, or Chrome writes the PDFs into
# the container and --rm throws them away without any error.
archive=$(env_val ARCHIVE_DIR "$EQB_ENV_FILE")
case "$archive" in
    /share/*) echo "[EQB_RESULTS] PDF archive (container): $archive" ;;
    *)
        echo "[EQB_RESULTS] ✗ REFUSING TO RUN: ARCHIVE_DIR is '$archive'."
        echo "[EQB_RESULTS]   It must be under /share or the downloaded PDFs are silently discarded."
        exit 1
        ;;
esac

echo "[EQB_RESULTS] data repo: $EQB_DATA_REPO (commit+push as $GIT_NAME <$GIT_EMAIL>)"

# fetch-all: download chart PDFs -> /share -> pdftotext -> parse -> /data_repo
#            -> git add/commit/PUSH -> POST.
podman_run_bounded \
    --env-file "$EQB_ENV_FILE" \
    -v "$EQB_DATA_REPO:/data_repo:rw" \
    -v "$SHARE_HOST:/share:rw" \
    -e GIT_AUTHOR_NAME="$GIT_NAME"    -e GIT_AUTHOR_EMAIL="$GIT_EMAIL" \
    -e GIT_COMMITTER_NAME="$GIT_NAME" -e GIT_COMMITTER_EMAIL="$GIT_EMAIL" \
    -v "$SSH_KEY:/root/.ssh/id_ed25519:ro" \
    -e GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=accept-new" \
    "$EQB_IMAGE" fetch-all
rc=$?

if [ $rc -ne 0 ]; then
    echo "[EQB_RESULTS] ✗ container exited $rc"
    exit $rc
fi

echo ""
echo "=================================================="
echo "Equibase results scrape completed: $(date)"
echo "=================================================="

touch ~/.cron_support/cron_project_b_equibase_results_scrape.container.txt

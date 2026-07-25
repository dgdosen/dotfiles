#!/usr/bin/env zsh
#
# Containerized variant of project_b_drf_debut_fetch.sh.
#
#   drf_debut -> project_b_drf_debut_scrape_cli:bun
#
# The image carries its own runtime (bun) and Chromium, so it is immune to host
# toolchain drift — the failure mode that silently killed other nightlies when a
# pinned node version was not installed.
#
# This scraper DOWNLOADS files: Chrome writes the debut PDFs to
# PROJECT_B_DOWNLOAD_FOLDER, which must resolve inside the /share mount. If it
# does not, the PDFs are discarded with the container AND the run still reports
# success — hence the post-run check below.

source ~/.zshrc
source "${0:A:h}/_lib.sh"   # acquire_lock, ensure_podman, assert_prod_env, run_container, env_val

acquire_lock "$HOME/.cron_support/project_b_drf_debut_fetch.lock"

# ---------------------------------------------------------------- config ----

DRF_DEBUT_IMAGE="${DRF_DEBUT_IMAGE:-localhost/project_b_drf_debut_scrape_cli:bun}"
DRF_DEBUT_REPO="$HOME/dev/project_b_drf_debut_scrape_cli"

# Bound the container run (see podman_run_bounded in _lib.sh). A healthy run is ~10
# seconds; 10 minutes is pure headroom. Without this a hung browser inside the
# container stalls the job indefinitely and the next morning's run just piles on.
CONTAINER_TIMEOUT="${CONTAINER_TIMEOUT:-600}"

# PRODUCTION ONLY, deliberately not overridable: this scraper is also run against
# dev (.env.container.dev -> local Rails), and a nightly that quietly wrote to the
# wrong place would still look successful.
DRF_DEBUT_ENV_FILE="$DRF_DEBUT_REPO/.env.container.prod"

# Host-side view of the download target, for the post-run check. Keep in step
# with PROJECT_B_DOWNLOAD_FOLDER in the env-file (container-side /share/...).
DOWNLOAD_DIR_HOST="$SHARE_HOST/documents/dropoff_drf_debut/to_be_processed"

# ------------------------------------------------------------- functions ----

# The download folder must resolve inside the mount, or Chrome writes into the
# container and --rm throws the PDFs away without any error. (Job-specific: only
# this scraper downloads files, so the guard lives here, not in _lib.sh.)
assert_download_path_is_mounted() {
    local p
    p=$(env_val PROJECT_B_DOWNLOAD_FOLDER "$DRF_DEBUT_ENV_FILE")
    case "$p" in
        /share/*)
            echo "[DRF_DEBUT] download folder (container): $p"
            return 0
            ;;
        *)
            echo "[DRF_DEBUT] ✗ REFUSING TO RUN: PROJECT_B_DOWNLOAD_FOLDER is '$p'."
            echo "[DRF_DEBUT]   It must be under /share or the downloads are silently discarded."
            return 1
            ;;
    esac
}

drf_debut_run() {
    run_container "$DRF_DEBUT_IMAGE" "$DRF_DEBUT_ENV_FILE" "$@"
}

# ------------------------------------------------------------------ main ----

echo "=================================================="
echo "Project B DRF Debut Fetch (containerized)"
echo "Started: $(date)"
echo "=================================================="

if ! ensure_podman; then
    echo "✗ podman unavailable — skipping. Nothing was fetched."
    exit 1
fi

if ! assert_prod_env DRF_DEBUT "$DRF_DEBUT_ENV_FILE"; then exit 1; fi
if ! assert_download_path_is_mounted; then exit 1; fi

before=$(ls -1 "$DOWNLOAD_DIR_HOST" 2>/dev/null | wc -l | tr -d ' ')
echo "[DRF_DEBUT] files in dropoff before: $before"

drf_debut_run
rc=$?

after=$(ls -1 "$DOWNLOAD_DIR_HOST" 2>/dev/null | wc -l | tr -d ' ')
echo "[DRF_DEBUT] files in dropoff after:  $after"

if [ $rc -ne 0 ]; then
    echo "[DRF_DEBUT] ✗ container exited $rc"
    exit $rc
fi

# The CLI reports success even when nothing was written, so check the share.
# Today's reports may legitimately already be present, hence "no new files" is a
# warning rather than a hard failure.
if [ "$after" -le "$before" ]; then
    echo "[DRF_DEBUT] ! no new files appeared in $DOWNLOAD_DIR_HOST"
    echo "[DRF_DEBUT]   Either today's reports were already downloaded, or the"
    echo "[DRF_DEBUT]   download path is not landing on the share. Worth checking."
else
    echo "[DRF_DEBUT] ✓ $((after - before)) new file(s) downloaded"
fi

echo ""
echo "=================================================="
echo "DRF Debut fetch completed: $(date)"
echo "=================================================="

touch ~/.cron_support/cron_project_b_drf_debut_scrape.txt

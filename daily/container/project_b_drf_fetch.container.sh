#!/usr/bin/env zsh
#
# Containerized variant of project_b_drf_fetch.sh.
#
#   drf -> project_b_drf_scrape_cli:bun
#
# Runs the CLI's two commander subcommands, in the same order as the native
# script: `scrape_drf_data` (posts to the prod API) then `download_drf_files`
# (downloads DRF zip files to the /share dropoff). The image carries its own
# runtime (bun) and Chromium, so it is immune to host toolchain drift.
#
# Like drf_debut, the download step writes files: Chrome saves zips to
# PROJECT_B_DOWNLOAD_FOLDER, which must resolve inside the /share mount or the
# files are discarded with the container AND the run still reports success —
# hence the download-path guard and the post-run check below.

source ~/.zshrc
source "${0:A:h}/_lib.sh"   # acquire_lock, ensure_podman, assert_prod_env, run_container, env_val

acquire_lock "$HOME/.cron_support/project_b_drf_fetch.container.lock"

# ---------------------------------------------------------------- config ----

DRF_IMAGE="${DRF_IMAGE:-localhost/project_b_drf_scrape_cli:bun}"
DRF_REPO="$HOME/dev/project_b_drf_scrape_cli"

# PRODUCTION ONLY, deliberately not overridable: this CLI is also run against dev
# (.env.container.dev -> local Rails), and a nightly that quietly scraped into the
# wrong database would still look successful.
DRF_ENV_FILE="$DRF_REPO/.env.container.prod"

# Host-side view of the download target, for the post-run check. Keep in step
# with PROJECT_B_DOWNLOAD_FOLDER in the env-file (container-side /share/...).
DOWNLOAD_DIR_HOST="$HOME/project_b_share/documents/dropoff_drf_zips/to_be_processed"

# Bound each container run (see podman_run_bounded in _lib.sh). This applies per
# invocation, not to the pair: scrape_drf_data is the long pole at roughly 30-38
# min of the 32-40 min total, and download_drf_files then takes a minute or two.
# 1 hour would be only ~1.5x the observed scrape, which is too close given how
# much these runtimes swing with the size of the day's card — 2 hours instead.
CONTAINER_TIMEOUT="${CONTAINER_TIMEOUT:-7200}"

# Pilot for the idle watchdog (see _podman_idle_watchdog in _lib.sh). This is the
# first script to opt in: it runs long enough to be worth bounding and logs per
# track, so silence here is a real signal rather than an artifact of a quiet CLI.
#
# 30 min is deliberately loose. Nothing is being caught yet — the goal is the
# "max idle gap this run" line the watchdog prints on EVERY run, which is the
# calibration data the logs cannot supply (they carry no per-line timestamps, so
# there is no way to recover from history how long a healthy run goes quiet).
# Once a week or so of real runs have reported their gaps, tighten this to the
# observed max plus margin, and only then roll the watchdog to other scripts.
IDLE_LIMIT="${IDLE_LIMIT:-1800}"

# ------------------------------------------------------------- functions ----

# The download folder must resolve inside the mount, or Chrome writes into the
# container and --rm throws the zips away without any error. (Job-specific guard,
# same as drf_debut — only the downloading scrapers need it.)
assert_download_path_is_mounted() {
    local p
    p=$(env_val PROJECT_B_DOWNLOAD_FOLDER "$DRF_ENV_FILE")
    case "$p" in
        /share/*)
            echo "[DRF] download folder (container): $p"
            return 0
            ;;
        *)
            echo "[DRF] ✗ REFUSING TO RUN: PROJECT_B_DOWNLOAD_FOLDER is '$p'."
            echo "[DRF]   It must be under /share or the downloads are silently discarded."
            return 1
            ;;
    esac
}

drf_run() {
    run_container "$DRF_IMAGE" "$DRF_ENV_FILE" "$@"
}

# ------------------------------------------------------------------ main ----

echo "=================================================="
echo "Project B DRF Fetch (containerized)"
echo "Started: $(date)"
echo "=================================================="

if ! ensure_podman; then
    echo "✗ podman unavailable — skipping. Nothing was scraped or fetched."
    exit 1
fi

# This repo names the API root REACT_APP_API_ROOT (not API_ROOT).
if ! assert_prod_env DRF "$DRF_ENV_FILE" REACT_APP_API_ROOT; then exit 1; fi
if ! assert_download_path_is_mounted; then exit 1; fi

# The two commands are INDEPENDENT and run unconditionally, matching the native
# script (which lists them on separate lines with no &&). scrape_drf_data is
# navigation-heavy and can abort on a single slow-page puppeteer timeout; that
# must NOT block the download, which works on its own. Attempt both, remember
# each exit code, and fail the whole run at the end if either failed.
overall=0

# 1) scrape: posts DRF data to the prod API. No files produced here.
echo "[DRF] scraping DRF data (scrape_drf_data)..."
drf_run scrape_drf_data
rc=$?
if [ $rc -ne 0 ]; then
    echo "[DRF] ✗ scrape_drf_data exited $rc (continuing to download anyway)"
    overall=$rc
else
    echo "[DRF] ✓ scrape completed"
fi

# 2) download: fetches DRF zip files into the /share dropoff.
before=$(ls -1 "$DOWNLOAD_DIR_HOST" 2>/dev/null | wc -l | tr -d ' ')
echo "[DRF] files in dropoff before: $before"

echo "[DRF] downloading DRF files (download_drf_files)..."
drf_run download_drf_files
rc=$?

after=$(ls -1 "$DOWNLOAD_DIR_HOST" 2>/dev/null | wc -l | tr -d ' ')
echo "[DRF] files in dropoff after:  $after"

# The CLI reports success even when nothing was written, so check the share.
# Today's files may legitimately already be present, hence "no new files" is a
# warning rather than a hard failure.
if [ $rc -ne 0 ]; then
    echo "[DRF] ✗ download_drf_files exited $rc"
    overall=$rc
elif [ "$after" -le "$before" ]; then
    echo "[DRF] ! no new files appeared in $DOWNLOAD_DIR_HOST"
    echo "[DRF]   Either today's files were already downloaded, or the download"
    echo "[DRF]   path is not landing on the share. Worth checking."
else
    echo "[DRF] ✓ $((after - before)) new file(s) downloaded"
fi

echo ""
echo "=================================================="
echo "DRF fetch completed: $(date)"
echo "=================================================="

touch ~/.cron_support/cron_project_b_drf_scrape.container.txt

# Non-zero if either command failed (both were still attempted).
exit $overall

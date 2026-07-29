#!/usr/bin/env zsh
#
# Containerized variant for the Harrington workout scraper.
#
#   harrington -> project_b_harrington_scrape_cli:bun
#
# Scrapes nationalturf.com for daily workout reports (puppeteer/Chromium), parses
# the HTML, POSTs to the prod API, and archives the HTML to the Dropbox share.
# Simpler than tmracingdata or brisnet: no git repo, no push, no pdftotext.
#
# TWO durable outputs, both mounts (see README.container.md in the CLI repo):
#   /archive <- the Dropbox share's dropoff_harrington/processed
#               fetch archives downloaded HTML here after parsing and POSTing
#   /data    <- project_b_national_turf_data (JSON export)
#               fetch writes one JSON per track+date here
#
# A single `fetch` subcommand does everything end-to-end: login, scrape, parse,
# POST, archive. No second pass needed.

source ~/.zshrc
source "${0:A:h}/_lib.sh"   # acquire_lock, ensure_podman, assert_prod_env, podman_run_bounded, env_val, SHARE_HOST

acquire_lock "$HOME/.cron_support/project_b_harrington_scrape.container.lock"

# ---------------------------------------------------------------- config ----

HAR_IMAGE="${HAR_IMAGE:-localhost/project_b_harrington_scrape_cli:bun}"
HAR_CLI_REPO="$HOME/dev/project_b_harrington_scrape_cli"

# PRODUCTION ONLY, deliberately not overridable. fetch posts to EVERY configured
# API target, so a nightly must not carry a dev target it might stall on when
# local Rails is down.
HAR_ENV_FILE="$HAR_CLI_REPO/.env.container.prod"

# Host-side view of the two mounts.
HAR_ARCHIVE_HOST="$SHARE_HOST/documents/dropoff_harrington/processed"
HAR_DATA_HOST="$HOME/dev/project_b_national_turf_data"

# Bound the container run (see podman_run_bounded in _lib.sh). fetch navigates
# several pages via puppeteer, typically finishes in under 5 minutes. 30 minutes
# is generous — revisit once the log has a week of real runs.
CONTAINER_TIMEOUT="${CONTAINER_TIMEOUT:-1800}"

# ------------------------------------------------------------- functions ----

# Both durable paths must resolve inside a mount, or the container writes into
# its own filesystem and --rm discards the work.
assert_container_paths_are_mounted() {
    local archive data
    archive=$(env_val ARCHIVE_DIR "$HAR_ENV_FILE")
    data=$(env_val JSON_EXPORT_FOLDER "$HAR_ENV_FILE")

    if [[ "$archive" != /archive* ]]; then
        echo "[HAR] ✗ REFUSING TO RUN: ARCHIVE_DIR is '$archive'."
        echo "[HAR]   It must be under /archive or the downloaded HTML is silently discarded."
        return 1
    fi
    if [[ "$data" != /data* ]]; then
        echo "[HAR] ✗ REFUSING TO RUN: JSON_EXPORT_FOLDER is '$data'."
        echo "[HAR]   It must be under /data or the exported JSON is silently discarded."
        return 1
    fi
    echo "[HAR] archive (container): $archive"
    echo "[HAR] data (container):    $data"
    return 0
}

har_run() {
    podman_run_bounded \
        --env-file "$HAR_ENV_FILE" \
        -v "$HAR_ARCHIVE_HOST:/archive:rw" \
        -v "$HAR_DATA_HOST:/data:rw" \
        "$HAR_IMAGE" "$@"
}

htm_count() {
    ls -1 "$HAR_ARCHIVE_HOST" 2>/dev/null | grep -ci '\.htm$'
}

# ------------------------------------------------------------------ main ----

echo "=================================================="
echo "Project B Harrington Scrape (containerized)"
echo "Started: $(date)"
echo "=================================================="

if ! ensure_podman; then
    echo "✗ podman unavailable — skipping. Nothing was fetched or processed."
    exit 1
fi

if ! assert_prod_env HAR "$HAR_ENV_FILE" PROD_API_URL; then exit 1; fi
if ! assert_container_paths_are_mounted; then exit 1; fi

if [ ! -d "$HAR_ARCHIVE_HOST" ]; then
    echo "✗ archive directory $HAR_ARCHIVE_HOST is missing — is Dropbox mounted? Skipping."
    exit 1
fi
if [ ! -d "$HAR_DATA_HOST" ]; then
    echo "✗ data directory $HAR_DATA_HOST is missing. Skipping."
    exit 1
fi

before=$(htm_count)
echo "[HAR] archived HTM files before: $before"

echo ""
echo "[HAR] fetching and processing workout reports..."
har_run fetch
rc=$?

after=$(htm_count)
echo "[HAR] archived HTM files after:  $after"

if [ $rc -ne 0 ]; then
    echo "[HAR] ✗ fetch exited $rc"
elif [ "$after" -le "$before" ]; then
    echo "[HAR] ! no new HTML files archived"
    echo "[HAR]   Either today's reports were already archived, the site had nothing"
    echo "[HAR]   new, or the archive path is not landing on the share. Worth checking."
else
    echo "[HAR] ✓ $((after - before)) new report(s) archived and posted"
fi

echo ""
echo "=================================================="
echo "Harrington scrape completed: $(date)"
echo "=================================================="

touch ~/.cron_support/cron_project_b_harrington_scrape.container.txt

exit $rc

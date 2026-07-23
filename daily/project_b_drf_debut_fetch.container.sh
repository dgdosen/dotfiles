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

# Lock file to prevent multiple instances
LOCKFILE="$HOME/.cron_support/project_b_drf_debut_fetch.lock"

if [ -f "$LOCKFILE" ]; then
    OLD_PID=$(cat "$LOCKFILE" 2>/dev/null)
    if [ -n "$OLD_PID" ] && kill -0 "$OLD_PID" 2>/dev/null; then
        echo "Another instance is already running (PID $OLD_PID). Exiting."
        exit 0
    else
        echo "Removing stale lock file (PID $OLD_PID no longer running)."
        rm -f "$LOCKFILE"
    fi
fi

echo $$ > "$LOCKFILE"
trap "rm -f $LOCKFILE" EXIT INT TERM

# ---------------------------------------------------------------- config ----

DRF_DEBUT_IMAGE="${DRF_DEBUT_IMAGE:-localhost/project_b_drf_debut_scrape_cli:bun}"
DRF_DEBUT_REPO="$HOME/dev/project_b_drf_debut_scrape_cli"

# PRODUCTION ONLY, deliberately not overridable: this scraper is also run against
# dev (.env.container.dev -> local Rails), and a nightly that quietly wrote to the
# wrong place would still look successful.
DRF_DEBUT_ENV_FILE="$DRF_DEBUT_REPO/.env.container.prod"
EXPECTED_API_HOST="projectb.makerboarding.com"

SHARE_HOST="${SHARE_HOST:-$HOME/project_b_share}"

# Host-side view of the download target, for the post-run check. Keep in step
# with PROJECT_B_DOWNLOAD_FOLDER in the env-file (container-side /share/...).
DOWNLOAD_DIR_HOST="$SHARE_HOST/documents/dropoff_drf_debut/to_be_processed"

# ------------------------------------------------------------- functions ----

# podman's VM does not survive a reboot, and `podman machine list` then reports
# LastUp as "Never" even though it has run before. Without this, cron fails
# silently after every restart.
ensure_podman() {
    local state
    state=$(podman machine info --format '{{.Host.MachineState}}' 2>/dev/null)
    if [ "$state" != "Running" ]; then
        echo "[PODMAN] machine not running (state: ${state:-unknown}) — starting..."
        podman machine start || return 1
    fi
    podman info >/dev/null 2>&1
}

# Refuse to run if the env-file does not point at production.
assert_prod_env() {
    local label="$1" envfile="$2" root
    if [ ! -f "$envfile" ]; then
        echo "[$label] ✗ env-file not found: $envfile"
        return 1
    fi
    root=$(grep -E '^API_ROOT=' "$envfile" | head -1 | cut -d= -f2- | tr -d '"')
    case "$root" in
        *"$EXPECTED_API_HOST"*)
            echo "[$label] target API: $root"
            return 0
            ;;
        *)
            echo "[$label] ✗ REFUSING TO RUN: $envfile points at '$root',"
            echo "[$label]   which is not $EXPECTED_API_HOST. This script is production-only."
            return 1
            ;;
    esac
}

# The download folder must resolve inside the mount, or Chrome writes into the
# container and --rm throws the PDFs away without any error.
assert_download_path_is_mounted() {
    local p
    p=$(grep -E '^PROJECT_B_DOWNLOAD_FOLDER=' "$DRF_DEBUT_ENV_FILE" | head -1 | cut -d= -f2- | tr -d '"')
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
    podman run --rm \
        --env-file "$DRF_DEBUT_ENV_FILE" \
        -v "$SHARE_HOST:/share:rw" \
        "$DRF_DEBUT_IMAGE" "$@"
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

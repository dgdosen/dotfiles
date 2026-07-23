#!/usr/bin/env zsh
#
# Containerized variant of project_b_gmax_egps_audit.sh.
#
# Both scrapers run via podman:
#   gmax -> project_b_gmax_scrape_cli:bun
#   egps -> project_b_equibase_scrape_cli:bun
#
# Why containers: ~/dev/project_b_gmax_scrape_cli pins node 22.17.1 in
# .node-version, which is NOT installed in nodenv (only system, 18.16.1,
# 24.18.0), so every `yarn dev` there died at the shim. The images carry their
# own runtime (bun) and Chromium, so they are immune to host toolchain drift.
#
# Override GMAX_AUDITS to point at a scratch subtree for smoke tests, e.g.
#   GMAX_AUDITS=/share/state/test_run ./project_b_gmax_egps_audit.container.sh

source ~/.zshrc

# Lock file to prevent multiple instances
LOCKFILE="$HOME/.cron_support/project_b_gmax_egps_audit.lock"

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

GMAX_IMAGE="${GMAX_IMAGE:-localhost/project_b_gmax_scrape_cli:bun}"
GMAX_REPO="$HOME/dev/project_b_gmax_scrape_cli"
# This script writes to PRODUCTION ONLY. Deliberately not overridable: gmax is
# also run against dev (.env.container -> local Rails), and a nightly that
# silently posted into the dev database would still retire the source files, so
# the races would be gone without ever reaching production.
# To run against dev, invoke podman directly with --env-file .env.container.
GMAX_ENV_FILE="$GMAX_REPO/.env.container.prod"
EXPECTED_API_HOST="projectb.makerboarding.com"
SHARE_HOST="${SHARE_HOST:-$HOME/project_b_share}"

EGPS_IMAGE="${EGPS_IMAGE:-localhost/project_b_equibase_scrape_cli:bun}"
EGPS_REPO="$HOME/dev/project_b_equibase_scrape_cli"
# Production only, for the same reason as gmax above.
EGPS_ENV_FILE="$EGPS_REPO/.env.container.prod"

# Container-side paths (under the /share mount), NOT host paths.
GMAX_AUDITS="${GMAX_AUDITS:-/share/documents/audits/gmax}"
EGPS_AUDITS="${EGPS_AUDITS:-/share/documents/audits/egps}"

# Exit code the CLI uses to say "gmax served a bot challenge, nothing scraped".
CHALLENGE_EXIT=2

# Pause between challenge retries. A challenge that clears at all needs some time
# to do so; retrying instantly just burns three identical failures.
CHALLENGE_RETRY_DELAY="${CHALLENGE_RETRY_DELAY:-300}"

# ------------------------------------------------------------- functions ----

# podman's VM does not survive a reboot, and `podman machine list` reports
# LastUp as "Never" afterwards. Without this, cron fails silently after every
# restart.
ensure_podman() {
    local state
    state=$(podman machine info --format '{{.Host.MachineState}}' 2>/dev/null)
    if [ "$state" != "Running" ]; then
        echo "[PODMAN] machine not running (state: ${state:-unknown}) — starting..."
        podman machine start || return 1
    fi
    podman info >/dev/null 2>&1
}

# Run the gmax CLI in a throwaway container. Args pass through to commander.
# Returns the container's exit code; CHALLENGE_EXIT means a human must clear a
# CAPTCHA before any further gmax work can succeed.
gmax_run() {
    podman run --rm \
        --env-file "$GMAX_ENV_FILE" \
        -v "$SHARE_HOST:/share:rw" \
        "$GMAX_IMAGE" "$@"
}

# Same, for the equibase GPS scraper.
egps_run() {
    podman run --rm \
        --env-file "$EGPS_ENV_FILE" \
        -v "$SHARE_HOST:/share:rw" \
        "$EGPS_IMAGE" "$@"
}

# Refuse to run if an env-file does not point at production. Catches a wrong
# file, a bad edit, or a dev/prod mix-up BEFORE anything is scraped — critical
# because the source files are retired afterwards either way, so races posted to
# the wrong database are simply gone.
# Usage: assert_prod_env <LABEL> <env-file>
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
            echo "[$label]   Source files left untouched."
            return 1
            ;;
    esac
}

# ------------------------------------------------------------------ main ----

echo "=================================================="
echo "Project B GMAX/EGPS Audit Processing (containerized)"
echo "Started: $(date)"
echo "=================================================="

# One podman check for both scrapers.
if ! ensure_podman; then
    echo "✗ podman unavailable — skipping ALL processing."
    echo "  Files remain queued; nothing was touched."
    exit 1
fi

if [ -n "$SKIP_EGPS" ]; then
    echo ""
    echo "[EGPS] SKIP_EGPS set — skipping EGPS entirely."
else

echo ""
echo "[EGPS] Starting EGPS audit processing (container: $EGPS_IMAGE)..."

if ! assert_prod_env EGPS "$EGPS_ENV_FILE"; then
    exit 1
fi

# Retry loop, same contract as gmax: the CLI now detects a bot challenge, leaves
# the file in to_be_processed, and exits CHALLENGE_EXIT — so the next pass really
# does retry it. equibase is the more bot-hostile of the two sites.
egps_blocked=0
for run in 1 2 3; do
    echo "[EGPS] Run $run/3: Processing new files..."
    egps_run -d "$EGPS_AUDITS/to_be_processed" -p "$EGPS_AUDITS/to_be_reprocessed"
    rc=$?
    if [ $rc -eq $CHALLENGE_EXIT ]; then
        egps_blocked=1
        if [ $run -lt 3 ]; then
            echo "[EGPS] ! Run $run blocked by a bot challenge — files left queued; retrying in ${CHALLENGE_RETRY_DELAY}s."
            sleep "$CHALLENGE_RETRY_DELAY"
        else
            echo "[EGPS] ✗ Still blocked after $run attempts — a human must clear the challenge."
            echo "[EGPS]   Source files remain in $EGPS_AUDITS/to_be_processed; Slack has been notified."
        fi
        continue
    fi
    egps_blocked=0
    [ $rc -ne 0 ] && echo "[EGPS] ! Run $run exited $rc (continuing)."
    echo "[EGPS] ✓ Run $run completed at $(date '+%H:%M:%S')"
done

# Run the final pass even if blocked: anything that DID reach to_be_reprocessed
# should still be retired, and this is the second scrape attempt for races with
# no cached data.
echo "[EGPS] Final: Moving reprocessed files to processed..."
egps_run -d "$EGPS_AUDITS/to_be_reprocessed" -p "$EGPS_AUDITS/processed" -r
rc=$?
if [ $rc -eq $CHALLENGE_EXIT ]; then
    echo "[EGPS] ✗ Final pass blocked by a bot challenge — files left in to_be_reprocessed."
    egps_blocked=1
fi
[ $egps_blocked -eq 0 ] && echo "[EGPS] ✓ All EGPS processing completed"

fi  # SKIP_EGPS

echo ""
echo "--------------------------------------------------"
echo "[GMAX] Starting GMAX audit processing (container: $GMAX_IMAGE)..."

if ! assert_prod_env GMAX "$GMAX_ENV_FILE"; then
    exit 1
fi

# Retry loop. A bot challenge is transient often enough to be worth re-attempting:
# the CLI now leaves challenged files in to_be_processed (exit CHALLENGE_EXIT), so
# the next pass genuinely picks them up again. Before challenge detection existed,
# the file was moved out after run 1 regardless and these extra passes scanned an
# empty directory — the real retry came from the final -r pass.
gmax_blocked=0
for run in 1 2 3; do
    echo "[GMAX] Run $run/3: Processing new files..."
    gmax_run -d "$GMAX_AUDITS/to_be_processed" -p "$GMAX_AUDITS/to_be_reprocessed"
    rc=$?
    if [ $rc -eq $CHALLENGE_EXIT ]; then
        gmax_blocked=1
        if [ $run -lt 3 ]; then
            echo "[GMAX] ! Run $run blocked by a bot challenge — files left queued; retrying in ${CHALLENGE_RETRY_DELAY}s."
            sleep "$CHALLENGE_RETRY_DELAY"
        else
            echo "[GMAX] ✗ Still blocked after $run attempts — a human must clear the challenge."
            echo "[GMAX]   Source files remain in $GMAX_AUDITS/to_be_processed; Slack has been notified."
        fi
        continue
    fi
    gmax_blocked=0
    if [ $rc -ne 0 ]; then
        echo "[GMAX] ! Run $run exited $rc (continuing)."
    fi
    echo "[GMAX] ✓ Run $run completed at $(date '+%H:%M:%S')"
done

# Run the final pass even if the loop ended blocked: anything that DID make it to
# to_be_reprocessed should still be retired, and this is the second scrape attempt
# for races that failed earlier (they have no cached data, so -r re-scrapes them).
echo "[GMAX] Final: Moving reprocessed files to processed..."
gmax_run -d "$GMAX_AUDITS/to_be_reprocessed" -p "$GMAX_AUDITS/processed" -r
rc=$?
if [ $rc -eq $CHALLENGE_EXIT ]; then
    echo "[GMAX] ✗ Final pass blocked by a bot challenge — files left in to_be_reprocessed."
    gmax_blocked=1
fi
[ $gmax_blocked -eq 0 ] && echo "[GMAX] ✓ All GMAX processing completed"

echo ""
echo "=================================================="
echo "All audit processing completed: $(date)"
echo "=================================================="

# The success marker means "the whole nightly completed". A challenge in EITHER
# scraper leaves source files queued, so the run is not complete.
egps_blocked="${egps_blocked:-0}"
if [ $gmax_blocked -eq 0 ] && [ $egps_blocked -eq 0 ]; then
    touch ~/.cron_support/cron_project_b_gmax_egps_audit.txt
else
    blocked_who=""
    [ $gmax_blocked -ne 0 ] && blocked_who="GMAX"
    [ $egps_blocked -ne 0 ] && blocked_who="${blocked_who:+$blocked_who and }EGPS"
    echo "NOT touching the cron-success marker: $blocked_who was blocked."
    exit $CHALLENGE_EXIT
fi

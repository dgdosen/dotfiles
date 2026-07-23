# Shared scaffolding for the containerized (podman) daily scrapers.
#
# NOT executable and NOT run directly — it is `source`d by the sibling
# *.container.sh scripts, so its functions run in the caller's shell (that is
# why acquire_lock's `exit` and `trap` affect the whole script).
#
#   source "${0:A:h}/_lib.sh"      # zsh: absolute dir of the caller, cwd-safe
#
# Everything here was identical, copy-pasted boilerplate across the individual
# scripts; hoisting it gives the parts that are SUPPOSED to match one source of
# truth so they cannot drift. Job-specific logic (download verification, the
# gmax/egps bot-challenge retry loop) stays in the scripts that own it.

# Defaults, overridable from the environment or before sourcing (`:=` only
# assigns when unset, so an env override from cron/manual still wins).
: "${EXPECTED_API_HOST:=projectb.makerboarding.com}"
: "${SHARE_HOST:=$HOME/project_b_share}"

# Read a single VALUE from a `KEY=VALUE` env-file, stripping surrounding quotes.
# Usage: env_val <key> <file>
env_val() {
    grep -E "^$1=" "$2" | head -1 | cut -d= -f2- | tr -d '"'
}

# Single-instance lock. If a live PID owns the lock we exit 0 (a second nightly
# is not an error); a stale lock is reclaimed. On success we own it and clear it
# on any exit. Called in the caller's shell, so `exit`/`trap` apply script-wide.
# Usage: acquire_lock <lockfile>
acquire_lock() {
    local lockfile="$1" old_pid
    if [ -f "$lockfile" ]; then
        old_pid=$(cat "$lockfile" 2>/dev/null)
        if [ -n "$old_pid" ] && kill -0 "$old_pid" 2>/dev/null; then
            echo "Another instance is already running (PID $old_pid). Exiting."
            exit 0
        else
            echo "Removing stale lock file (PID $old_pid no longer running)."
            rm -f "$lockfile"
        fi
    fi
    echo $$ > "$lockfile"
    trap "rm -f '$lockfile'" EXIT INT TERM
}

# podman's VM does not survive a reboot, and `podman machine list` then reports
# LastUp as "Never" even though it has run before. Without this, cron fails
# silently after every restart. Returns non-zero if podman cannot be brought up.
ensure_podman() {
    local state
    state=$(podman machine info --format '{{.Host.MachineState}}' 2>/dev/null)
    if [ "$state" != "Running" ]; then
        echo "[PODMAN] machine not running (state: ${state:-unknown}) — starting..."
        podman machine start || return 1
    fi
    podman info >/dev/null 2>&1
}

# Refuse to run if an env-file does not point at production. Catches a wrong
# file, a bad edit, or a dev/prod mix-up BEFORE anything is scraped — critical
# because these scrapers retire their source files afterwards either way, so
# work posted to the wrong database is simply gone.
# Usage: assert_prod_env <label> <env-file>
assert_prod_env() {
    local label="$1" envfile="$2" root
    if [ ! -f "$envfile" ]; then
        echo "[$label] ✗ env-file not found: $envfile"
        return 1
    fi
    root=$(env_val API_ROOT "$envfile")
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

# Run one throwaway container against the /share mount. Extra args pass through
# to the image entrypoint. Returns the container's exit code.
# Usage: run_container <image> <env-file> [args...]
run_container() {
    local image="$1" envfile="$2"
    shift 2
    podman run --rm \
        --env-file "$envfile" \
        -v "$SHARE_HOST:/share:rw" \
        "$image" "$@"
}

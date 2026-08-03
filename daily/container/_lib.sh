# Shared scaffolding for the containerized (podman) daily scrapers.
#
# NOT executable and NOT run directly — it is `source`d by the sibling
# *.container.sh scripts, so its functions run in the caller's shell (that is
# why acquire_lock's `exit` affects the whole script). Note that this does NOT
# extend to `trap ... EXIT`, which zsh scopes to the enclosing function — see
# acquire_lock.
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
# is not an error); a stale lock is reclaimed. Called in the caller's shell, so
# `exit` applies script-wide.
#
# Cleanup goes through the `zshexit` hook, NOT `trap ... EXIT`. In zsh an EXIT
# trap set inside a function is scoped to THAT function and fires the moment the
# function returns — so the `trap "rm -f ..." EXIT` this used to end with deleted
# the lock immediately and every script here has in fact been running unlocked.
# `zshexit` is a global hook, and a function defined inside a function is global.
#
# Signals are deliberately not trapped: traps set in a function proved unreliable
# for them too, and zsh defers signal handling while a foreground child (podman
# run) is in flight, which is exactly when a wedged job gets killed. A lock left
# behind by a killed run is reclaimed by the stale-PID check above on the next
# run — that path, not signal handling, is what makes this recoverable.
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
    _LOCKFILE="$lockfile"          # global on purpose: zshexit reads it at exit
    zshexit() { rm -f "$_LOCKFILE" }
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
# The API-root key defaults to API_ROOT; pass a third arg for repos that name it
# differently (e.g. REACT_APP_API_ROOT).
# Usage: assert_prod_env <label> <env-file> [api-root-key]
assert_prod_env() {
    local label="$1" envfile="$2" key="${3:-API_ROOT}" root
    if [ ! -f "$envfile" ]; then
        echo "[$label] ✗ env-file not found: $envfile"
        return 1
    fi
    root=$(env_val "$key" "$envfile")
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

# Bounded `podman run --rm`. Takes the FULL podman-run argument list (mounts, -e
# flags, image, command), so the scripts whose mounts are too bespoke for
# run_container get the same protection: bris (/data_git + SSH key), both
# equibase scrapers (/data_repo + git identity + key) and twinspires_data
# (/data_repo). Returns the container's exit code.
#
# Set CONTAINER_TIMEOUT (seconds) before calling to bound the run; unset means
# unbounded, as before. Opt-in per script rather than one global default, because
# the honest runtimes here span three orders of magnitude — twinspires_data
# finishes in 10 seconds, equibase_program legitimately takes four hours — so any
# single default is either useless or silently truncates real work. Each caller
# sets its own, sized from its observed history.
#
# Why it exists: on 2026-07-25 a puppeteer navigation timeout left Chromium open
# inside the drf_debut container, so the CLI never exited and `podman run` sat
# wedged for three hours while the launch agent waited on it.
# Usage: podman_run_bounded <podman-run-args...>
# Idle watchdog. CONTAINER_TIMEOUT is a wall-clock bound, which cannot tell a
# wedged run from a slow one: on 2026-08-03 twinspires_data was SIGKILLed at
# 3600s while it was actively writing a race file every ~90s. Silence is the
# better signal for "hung", so watch how long it has been since the container
# last said anything.
#
# The heartbeat needs no plumbing: under launchd this script's stdout IS
# ~/log/<agent>.container.log, `podman run` inherits that fd, and every line the
# container prints advances the file's mtime. So the watchdog stats its own
# stdout. Run by hand into a pipe there is no file to stat, and rather than
# invent a signal we fall back to CONTAINER_TIMEOUT alone — the launchd case is
# the unattended one that matters, and a manual run has a human watching it.
#
# Resolve the path with lsof; do NOT stat /dev/fd/1 directly. On macOS that
# stats the device node, whose mtime tracks the clock rather than the file: it
# advanced 3s across 3s of complete silence, so measured idle was always ~0 and
# an earlier version of this watchdog could never fire.
#
# It reports max idle on EVERY run, not only when it fires. The logs carry no
# per-line timestamps, so there is no way to recover from history how long any
# scraper legitimately goes quiet — which means IDLE_LIMIT cannot be derived up
# front. Start generous, collect the real numbers, then tighten per script.
#
# Deliberately does not print to stdout except when reaping: anything it wrote
# would touch the very file it watches and reset the idle clock.
IDLE_LIMIT="${IDLE_LIMIT:-1800}"

_podman_idle_watchdog() {
    local name="$1" hb="$2" marker="$3" limit="$4" maxfile="$5"
    local mt idle max=0

    while [ -e "$marker" ]; do
        sleep 30
        [ -e "$marker" ] || break
        mt=$(stat -f %m "$hb" 2>/dev/null) || continue
        idle=$(( $(date +%s) - mt ))
        [ "$idle" -gt "$max" ] && max=$idle
        if [ "$idle" -gt "$limit" ]; then
            # Removing the container makes the blocked `podman run` return, so
            # the caller unwinds normally instead of waiting out the wall clock.
            print -r -- "[PODMAN] ✗ no output for ${idle}s (IDLE_LIMIT=${limit}s) — reaping '$name' as hung."
            podman rm -f "$name" >/dev/null 2>&1
            break
        fi
    done
    print -r -- "$max" > "$maxfile" 2>/dev/null
}

podman_run_bounded() {
    local -a wrapper
    local name="run_$$" t rc
    local hb="" marker="" maxfile="" wd="" maxidle=""

    hb=$(lsof -a -p $$ -d 1 -F n 2>/dev/null | sed -n 's/^n//p' | head -1)
    if [ -n "$hb" ] && [ -f "$hb" ]; then
        marker="${TMPDIR:-/tmp}/podman_hb_marker_$$"
        maxfile="${TMPDIR:-/tmp}/podman_hb_max_$$"
        : > "$marker"
        : > "$maxfile"
        _podman_idle_watchdog "$name" "$hb" "$marker" "$IDLE_LIMIT" "$maxfile" &
        wd=$!
    fi

    if [ -n "$CONTAINER_TIMEOUT" ]; then
        t=$(command -v timeout || command -v gtimeout)
        if [ -n "$t" ]; then
            wrapper=("$t" --kill-after=30 "$CONTAINER_TIMEOUT")
        else
            echo "[PODMAN] ! CONTAINER_TIMEOUT set but no timeout(1)/gtimeout(1) — running unbounded."
        fi
    fi

    # Anything already holding this name is debris from a dead run — our own PID
    # is live, so no other script can legitimately own it — and podman would
    # refuse to start with a duplicate name.
    podman container exists "$name" 2>/dev/null && podman rm -f "$name" >/dev/null 2>&1

    "${wrapper[@]}" podman run --rm --name "$name" "$@"
    rc=$?

    # Stop the watchdog first: it reaps by name, and the reap below is allowed to
    # find a genuine leak rather than race a watchdog that is still polling.
    if [ -n "$wd" ]; then
        rm -f "$marker"
        wait "$wd" 2>/dev/null
        maxidle=$(cat "$maxfile" 2>/dev/null)
        rm -f "$maxfile"
        [ -n "$maxidle" ] && echo "[PODMAN] max idle gap this run: ${maxidle}s (IDLE_LIMIT=${IDLE_LIMIT}s)"
    fi

    # Reap by NAME rather than by exit code. timeout(1) reports 124 when SIGTERM
    # was enough but 137 when it had to follow up with SIGKILL (which is what
    # actually happens here — a wedged bun/Chromium ignores the stop), and in
    # both cases only the podman CLIENT dies: the container keeps running, which
    # is the very hang being bounded. `--rm` already removes a container that
    # finished on its own, so anything still present is a leak.
    if podman container exists "$name" 2>/dev/null; then
        echo "[PODMAN] ✗ container '$name' outlived the client (rc=$rc, CONTAINER_TIMEOUT=${CONTAINER_TIMEOUT:-unset}s) — removing."
        podman rm -f "$name" >/dev/null 2>&1
    fi
    return $rc
}

# Convenience wrapper for the common shape: one throwaway container with the
# /share mount and an env-file. Extra args pass through to the image entrypoint.
# Bounded by CONTAINER_TIMEOUT exactly as podman_run_bounded, which it delegates to.
# Usage: run_container <image> <env-file> [args...]
run_container() {
    local image="$1" envfile="$2"
    shift 2
    podman_run_bounded \
        --env-file "$envfile" \
        -v "$SHARE_HOST:/share:rw" \
        "$image" "$@"
}

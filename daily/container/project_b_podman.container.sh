#!/usr/bin/env zsh
#
# Ensures the podman machine is running, for the container jobs that follow.
#
# Runs at login (RunAtLoad) and again at 05:50 to pre-warm the VM before the
# earliest scraper (bris at 06:00), so no job has to cold-start it.
#
# Why this exists instead of calling `podman machine start` from the plist:
# start is NOT a no-op on an already-running machine. podman 6.0.2 prints
#   Error: unable to start "podman-machine-default": already running
# and exits 125. The plist did exactly that, so every firing after the login
# run reported a failure while the pipeline was in fact healthy -- and the
# daily status check then spent a Claude investigation re-explaining it. Guard
# on state first so the exit code reflects intent: up == success, however it
# got there.
#
# A genuine start failure still exits non-zero and SHOULD be reported.
#
# Deliberately does not source _lib.sh: this runs on the host to bring the VM
# up, so it needs neither the container locking nor the API-host defaults.

export PATH="/opt/homebrew/bin:$PATH"

log() { print -r -- "$(date '+%Y-%m-%d %H:%M:%S') $*" }

log "podman pre-warm: checking machine state"

# Empty when the machine does not exist yet, or podman itself is broken --
# both fall through to start, which reports the real error.
state=$(podman machine inspect --format '{{.State}}' 2>/dev/null)

if [[ "$state" == "running" ]]; then
    log "podman machine already running -- nothing to do"
    exit 0
fi

log "podman machine state: ${state:-unknown} -- starting"

if podman machine start; then
    log "podman machine started successfully"
    exit 0
fi

rc=$?
log "podman machine start FAILED (exit ${rc})"
exit $rc

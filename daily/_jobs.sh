# Per-service on/off switches for the project_b jobs.
#
# NOT executable and NOT run directly — it is `source`d, by _lib.sh (which every
# container launcher already sources) and directly by the native scripts, which
# have no _lib.sh of their own. Kept separate from _lib.sh precisely because it
# is the one piece of scaffolding both modes need: _lib.sh is container-only.
#
# Switches live in ~/.machine.env, which ~/.zshrc sources and every job script
# sources before this file — so by the time job_enabled runs the values are
# already exported and there is nothing here to parse. See
# .machine.env.template for the full list and for what "off" costs per job.
#
# ── One switch per SERVICE, not per script ──────────────────────────────────
#
# The variable name is derived from the script filename with any `.container`
# dropped, so both halves of a service map to the SAME switch:
#
#   project_b_bris_fetch.sh            ─┐
#                                       ├─→ PROJECT_B_BRIS_FETCH
#   project_b_bris_fetch.container.sh  ─┘
#
# That is deliberate. Native and container variants share dropoff directories,
# git working trees and API targets, and only the container side takes a lock —
# so running both is destructive: queue consumers eat each other's queues and
# report healthy having done nothing, and the git pushers race on the same
# rebase. One knob per service means the config cannot express the broken state.
#
# Deriving from the filename also means there is no mapping table to drift. The
# two Rails DB jobs are the exception — their scripts are named cron_project_b*
# while their agents are project_b_db / project_b_dw_db — so they pass an
# explicit name as the second argument.
#
# ── Fail open ───────────────────────────────────────────────────────────────
#
# Unset, empty, missing ~/.machine.env, misspelled variable: the job RUNS.
# A config mistake must never be able to silently stop the pipeline. A job that
# quietly stops firing is the single failure this fleet is worst at noticing —
# `launchctl list` prints `-` for "has not run this boot" and nothing
# distinguishes that from healthy — which is also why "off" is a state the
# status record reports rather than an absence.
#
# Usage, at the TOP LEVEL of a job script (not inside a function — zsh's
# FUNCTION_ARGZERO makes $0 the function name in there). Always name the
# switch: it is what tells a reader which variable governs this script, and it
# is checked against the filename so it cannot quietly drift.
#
#   job_enabled "$0" PROJECT_B_BRIS_FETCH || exit 0
#   job_enabled "$0" PROJECT_B_DB || exit 0     # script name != agent name
#
# Exit 0, not 1: a switched-off job is not a failure, and reporting it as one
# would put the whole fleet permanently red in the status dashboard.

# Fleet-wide kill switch, checked before the per-service one. Same fail-open
# rule: unset means everything runs.
: "${PROJECT_B_JOBS:=}"

# on / off / off:<reason>. Anything not recognised as off means on, because the
# safe direction for an unparseable value is to keep scraping.
_job_is_off() {
    case "${1:l}" in
        off|off:*|0|no|false|disabled) return 0 ;;
        *) return 1 ;;
    esac
}

# Everything after the first colon is a free-text reason, so a switch can
# record WHY it is off — which is the thing you want during a migration:
#   PROJECT_B_BRIS_FETCH="off: moved to the droplet 2026-08-14"
_job_off_reason() {
    local raw="$1" reason=""
    [[ "$raw" == *:* ]] && reason="${raw#*:}"
    print -r -- "${reason# }"
}

# ── Mode: which implementation this MACHINE runs ────────────────────────────
#
# PROJECT_B_MODE does NOT dispatch. The installed launch agent decides which
# script runs, and a plist that points at the exact thing that ran is worth more
# than any indirection — "what actually executed" has to stay answerable from
# the plist alone. This asserts instead, the same shape as assert_prod_env: a
# fact about configuration, checked at launch, refusing rather than branching.
#
# It only means anything for a service that HAS both variants, so pairing is
# derived from the filesystem rather than a list that would drift: a native
# script whose .container.sh sibling exists (and the reverse) is paired. The
# Rails DB jobs, fetch_scratches and twinspires_data have no counterpart and are
# never refused — a container-only service still runs on a native machine.
#
# Refuses with exit 1, not 0. A wrongly-installed plist is not a quiet "off":
# both variants share dropoff directories, git working trees and API targets and
# only the container side takes a lock, so this is the state LAUNCH_AGENTS.md
# calls destructive. It stays broken until a human fixes it, so it stays red.
# Unset PROJECT_B_MODE asserts nothing, same fail-open rule as the switches.
: "${PROJECT_B_MODE:=}"

_job_mode() {
    [[ "${1:t}" == *.container.sh ]] && print -r -- container || print -r -- native
}

# The other implementation's path. daily/x.sh <-> daily/container/x.container.sh
_job_sibling() {
    local f="${1:A}" dir base
    dir="${f:h}" base="${f:t}"
    if [[ "$base" == *.container.sh ]]; then
        print -r -- "${dir:h}/${base%.container.sh}.sh"
    else
        print -r -- "${dir}/container/${base%.sh}.container.sh"
    fi
}

# project_b_bris_fetch.container.sh -> PROJECT_B_BRIS_FETCH
_job_switch_name() {
    local base="${1:t:r}"          # basename, drop .sh
    base="${base%.container}"      # both variants share one switch
    print -r -- "${${base:u}//[.-]/_}"
}

job_enabled() {
    local script="${1:-}" override="${2:-}" name raw reason

    if _job_is_off "$PROJECT_B_JOBS"; then
        reason=$(_job_off_reason "$PROJECT_B_JOBS")
        echo "[JOBS] PROJECT_B_JOBS is off in ~/.machine.env${reason:+ — $reason}"
        echo "[JOBS] the whole project_b fleet is switched off. Nothing was run."
        return 1
    fi

    # The switch name is written out at every call site so that reading a job
    # script tells you which variable governs it — `job_enabled "$0"` alone
    # never says. It is then CHECKED against the name derived from the
    # filename, so naming it at 24 call sites does not reintroduce 24 places to
    # drift: a typo, or a script copy-pasted without updating the line, would
    # otherwise point at an unset variable and fail open forever, leaving the
    # job silently unswitchable.
    #
    # A mismatch is only refused when the DERIVED variable is actually set —
    # that is the case where two plausible switches exist and it is genuinely
    # ambiguous which one was meant. The Rails DB jobs are the legitimate
    # mismatch (cron_project_b.sh derives CRON_PROJECT_B but the agent, and the
    # switch, are project_b_db); nothing sets CRON_PROJECT_B, so they pass.
    local derived=""
    [ -n "$script" ] && derived=$(_job_switch_name "$script")

    if [ -n "$override" ]; then
        name="${${override:u}//[.-]/_}"
        if [ -n "$derived" ] && [[ "$name" != "$derived" ]] && [ -n "${(P)derived}" ]; then
            echo "[JOBS] ✗ ${name} does not match the switch for this script"
            echo "[JOBS]   (${derived}), which is set in ~/.machine.env. Refusing rather"
            echo "[JOBS]   than reading a switch nobody is setting. Fix the job_enabled"
            echo "[JOBS]   line in ${script:t}, or unset ${derived}."
            exit 1
        fi
    elif [ -n "$derived" ]; then
        name="$derived"
    else
        return 0                   # nothing to key on: fail open
    fi

    raw="${(P)name}"
    if _job_is_off "$raw"; then
        reason=$(_job_off_reason "$raw")
        echo "[JOBS] ${name} is off in ~/.machine.env${reason:+ — $reason}"
        echo "[JOBS] nothing was run. Set it to 'on' (or delete the line) to re-enable."
        return 1
    fi

    # Wrong variant for this machine. Exits rather than returning: the callers
    # all say `|| exit 0`, and this must NOT look like a clean skip.
    if [ -n "$PROJECT_B_MODE" ] && [ -n "$script" ]; then
        local mine sibling
        mine=$(_job_mode "$script")
        sibling=$(_job_sibling "$script")
        if [[ "$mine" != "$PROJECT_B_MODE" ]] && [ -f "$sibling" ]; then
            echo "[JOBS] ✗ REFUSING TO RUN: this is the ${mine} variant of ${name}."
            echo "[JOBS]   PROJECT_B_MODE=${PROJECT_B_MODE} on this machine, and a ${PROJECT_B_MODE}"
            echo "[JOBS]   variant exists: ${sibling}"
            echo "[JOBS]   Both variants share dropoff dirs, git trees and API targets, and only"
            echo "[JOBS]   the container side locks — running both corrupts data. Unload the"
            echo "[JOBS]   ${mine} launch agent, or change PROJECT_B_MODE if this machine really"
            echo "[JOBS]   is a ${mine} host."
            exit 1
        fi
    fi

    return 0
}

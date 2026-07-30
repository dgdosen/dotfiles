#!/usr/bin/env zsh
#
# Health check for all com.makerboarding.* Launch Agents.
# Gathers launchctl status, tails logs for failures, and writes a Bear note.
#
# Runs twice daily via Launch Agent (morning + evening).
# Morning run captures overnight results; evening run catches the day's jobs.
#
# Lives in daily/container/ alongside the jobs it monitors, but unlike its
# neighbours it runs on the HOST, not inside podman -- hence no .container
# suffix and no sourcing of _lib.sh. It needs host launchctl and podman.

# /opt/homebrew/bin is not on launchd's default PATH -- claude and timeout
# both live there, so this is load-bearing under the Launch Agent.
export PATH="$HOME/.local/bin:/opt/homebrew/bin:$PATH"

TODAY=$(date +%Y_%m_%d)
TODAY_ISO=$(date +%Y-%m-%d)
NOW=$(date "+%Y-%m-%d %H:%M")
TITLE="project_b_status_${TODAY}"
LOG_DIR="$HOME/log"
SHARE="$HOME/project_b_share"

# ── Claude investigation config ──────────────────────────────────────────────

# Headless Claude Code ("claude -p") is how a script spawns an agent: it reads
# the prompt, works the tools it is allowed, prints its answer, exits.
# Absent or unauthenticated -> the block below is skipped and the note is
# still written; the investigation is strictly additive.
CLAUDE_BIN="${CLAUDE_BIN:-/opt/homebrew/bin/claude}"
TIMEOUT_BIN="${TIMEOUT_BIN:-/opt/homebrew/bin/timeout}"
CLAUDE_TIMEOUT="${CLAUDE_TIMEOUT:-10m}"   # hard cap; launchd job must not wedge

read -r -d '' CLAUDE_PROMPT <<'PROMPT'
You are triaging a nightly health report for the project_b data pipeline on
macOS. The report is on stdin: Launch Agents that exited non-zero, plus the
last 10 lines of each one's stdout and stderr.

For each failure, work out WHY it failed. Logs live in ~/log and are named
project_b_<agent>.log and project_b_<agent>.error.log -- read further back than
the 10 lines quoted if the cause is upstream of them. Jobs whose label ends in
.container run inside podman; check whether the podman machine was up at the
time. Distinguish a job that failed from one that never started.

Separate transient failures (network timeout, site down, podman not yet up)
from real ones (bad credentials, schema change, code error, disk full). Check
whether the same failure appears on previous days in the log -- a recurring
failure matters more than a one-off.

You are read-only. Do not restart agents or change anything; recommend, and a
human will act.

Reply in Bear-flavoured markdown, no blank lines between elements, under 300
words. The script has already written the "## Investigation" heading -- start
your reply directly with the first "###" line and add no heading above it.
One "### <agent>" section per failure, each with: cause (state plainly
when you are inferring rather than confirming), transient or real, recurring or
new, and the one action you would take. If the logs do not support a
conclusion, say what is missing instead of guessing.
PROMPT

# ── Gather launchctl status ──────────────────────────────────────────────────

typeset -A agent_pid agent_exit
agents=()

while IFS=$'\t' read -r pid exit_code label; do
    agents+=("$label")
    agent_pid[$label]="$pid"
    agent_exit[$label]="$exit_code"
done < <(launchctl list 2>/dev/null | grep 'com\.makerboarding\.' | awk '{printf "%s\t%s\t%s\n", $1, $2, $3}')

# Also include bear_update
while IFS=$'\t' read -r pid exit_code label; do
    agents+=("$label")
    agent_pid[$label]="$pid"
    agent_exit[$label]="$exit_code"
done < <(launchctl list 2>/dev/null | grep 'com\.agidevelopment\.bear_update' | awk '{printf "%s\t%s\t%s\n", $1, $2, $3}')

# ── Podman status ────────────────────────────────────────────────────────────

podman_state=$(podman machine info --format '{{.Host.MachineState}}' 2>/dev/null || echo "unavailable")

# ── Last run times ───────────────────────────────────────────────────────────

# Extract today's run times from an agent's stdout log.
# Returns comma-separated short times (e.g. "07:15, 10:12").
todays_run_times() {
    local name="$1" log_file=""
    for candidate in "${name}" "${name%.container}"; do
        [[ -z "$log_file" && -f "${LOG_DIR}/project_b_${candidate}.log" ]] && \
            log_file="${LOG_DIR}/project_b_${candidate}.log"
        [[ -z "$log_file" && -f "${LOG_DIR}/${candidate}.log" ]] && \
            log_file="${LOG_DIR}/${candidate}.log"
    done
    if [[ -n "$log_file" ]]; then
        local day_pattern=$(date "+%a %b %e")
        grep "Started: ${day_pattern}" "$log_file" 2>/dev/null \
            | sed 's/Started: .* \([0-9][0-9]:[0-9][0-9]\):[0-9][0-9] .*/\1/' \
            | paste -sd',' - | sed 's/,/, /g'
    fi
}

# ── Output counts ────────────────────────────────────────────────────────────

# Count today's commits in a git repo.
today_commits() {
    local repo="$1"
    [[ -d "$repo/.git" ]] || return
    git -C "$repo" log --oneline --since="$TODAY_ISO" 2>/dev/null | wc -l | tr -d ' '
}

# Count files in a directory.
file_count() {
    local dir="$1"
    [[ -d "$dir" ]] || return
    ls -1 "$dir" 2>/dev/null | wc -l | tr -d ' '
}

# Count files modified today in a directory.
today_file_count() {
    local dir="$1"
    [[ -d "$dir" ]] || return
    find "$dir" -maxdepth 1 -type f -newermt "$TODAY_ISO" 2>/dev/null | wc -l | tr -d ' '
}

# Dropoff summary: queued + today's processed.
dropoff_summary() {
    local base="$1" label="$2"
    local queued=$(file_count "$base/to_be_processed")
    local done_today=$(today_file_count "$base/processed")
    local parts=()
    [[ -n "$queued" && "$queued" -gt 0 ]] && parts+=("${queued} queued")
    [[ -n "$done_today" && "$done_today" -gt 0 ]] && parts+=("${done_today} processed today")
    [[ -n "$queued" && "$queued" -eq 0 && ( -z "$done_today" || "$done_today" -eq 0 ) ]] && parts+=("queue empty")
    (( ${#parts[@]} > 0 )) && printf '%s' "${label}: ${(j:, :)parts}"
}

# Per-agent output summary. Returns a short string or empty.
agent_output() {
    local name="$1" parts=()
    case "$name" in
        project_b_bris_fetch*)
            local c=$(today_commits "$HOME/dev/project_b_data_2023")
            [[ -n "$c" && "$c" -gt 0 ]] && parts+=("${c} commits in data_2023")
            local s=$(dropoff_summary "$SHARE/documents/dropoff_bris" "bris")
            [[ -n "$s" ]] && parts+=("$s")
            ;;
        project_b_drf_fetch.container)
            local s=$(dropoff_summary "$SHARE/documents/dropoff_drf_zips" "drf_zips")
            [[ -n "$s" ]] && parts+=("$s")
            ;;
        project_b_drf_debut_fetch*)
            local s=$(dropoff_summary "$SHARE/documents/dropoff_drf_debut" "drf_debut")
            [[ -n "$s" ]] && parts+=("$s")
            ;;
        project_b_equibase_program_scrape*|project_b_equibase_results_scrape*)
            local c=$(today_commits "$HOME/dev/project_b_equibase_data")
            [[ -n "$c" && "$c" -gt 0 ]] && parts+=("${c} commits in equibase_data")
            ;;
        project_b_progressive_breeding*)
            local c=$(today_commits "$HOME/dev/project_b_progressive_data")
            [[ -n "$c" && "$c" -gt 0 ]] && parts+=("${c} commits in progressive_data")
            local s=$(dropoff_summary "$SHARE/documents/dropoff_progressive_daily" "daily")
            [[ -n "$s" ]] && parts+=("$s")
            local s2=$(dropoff_summary "$SHARE/documents/dropoff_progressive_pdf" "pdf")
            [[ -n "$s2" ]] && parts+=("$s2")
            ;;
        project_b_tmracingdata*)
            local c=$(today_commits "$HOME/dev/project_b_tmracingdata")
            [[ -n "$c" && "$c" -gt 0 ]] && parts+=("${c} commits in tmracingdata")
            local s=$(dropoff_summary "$SHARE/documents/dropoff_tm_racing_data" "tmrd")
            [[ -n "$s" ]] && parts+=("$s")
            ;;
        project_b_twinspires_data*)
            local c=$(today_commits "$HOME/dev/project_b_twinspires_data")
            [[ -n "$c" && "$c" -gt 0 ]] && parts+=("${c} commits in twinspires_data")
            ;;
        project_b_harrington*)
            local s=$(dropoff_summary "$SHARE/documents/dropoff_harrington" "harrington")
            [[ -n "$s" ]] && parts+=("$s")
            ;;
        project_b_gmax_egps_audit*)
            local g=$(file_count "$SHARE/documents/audits/gmax")
            [[ -n "$g" ]] && parts+=("${g} files in audits/gmax")
            local e=$(file_count "$SHARE/documents/audits/egps")
            [[ -n "$e" ]] && parts+=("${e} files in audits/egps")
            ;;
    esac
    (( ${#parts[@]} > 0 )) && printf '%s' "${(j:, :)parts}"
}

# ── Build report ─────────────────────────────────────────────────────────────

report=""
failures=()
running=()
healthy=()

typeset -A agent_lastrun

for label in "${(@o)agents}"; do
    pid="${agent_pid[$label]}"
    ec="${agent_exit[$label]}"
    short="${label#com.makerboarding.}"
    short="${short#com.agidevelopment.}"

    agent_lastrun[$short]=$(todays_run_times "$short")

    if [[ "$pid" != "-" && -n "$pid" ]]; then
        running+=("$short (PID $pid)")
    elif [[ "$ec" != "0" ]]; then
        failures+=("$short (exit $ec)")
    else
        healthy+=("$short")
    fi
done

# Header
report+="checked: ${NOW}\n"
report+="podman: ${podman_state}\n"

# Summary counts
report+="## Summary\n"
report+="| Status | Count |\n"
report+="|--------|-------|\n"
report+="| Healthy | ${#healthy[@]} |\n"
report+="| Failed | ${#failures[@]} |\n"
report+="| Running | ${#running[@]} |\n"

# Running
if (( ${#running[@]} > 0 )); then
    report+="## Running\n"
    for item in "${running[@]}"; do
        name="${item%% \(*}"
        ts="${agent_lastrun[$name]}"
        out=$(agent_output "$name")
        report+="- ${item}${ts:+ — ${ts}}${out:+ | ${out}}\n"
    done
fi

# Failures with log excerpts
if (( ${#failures[@]} > 0 )); then
    report+="## Failures\n"
    for item in "${failures[@]}"; do
        name="${item%% \(*}"
        ts="${agent_lastrun[$name]}"
        report+="### ${item}\n"
        out=$(agent_output "$name")
        [[ -n "$ts" ]] && report+="ran: ${ts}\n"
        [[ -n "$out" ]] && report+="output: ${out}\n"

        # Find matching log files (try container variant first, then plain)
        err_log=""
        out_log=""
        for candidate in "${name}" "${name%.container}"; do
            [[ -z "$err_log" && -f "${LOG_DIR}/project_b_${candidate}.error.log" ]] && \
                err_log="${LOG_DIR}/project_b_${candidate}.error.log"
            [[ -z "$err_log" && -f "${LOG_DIR}/${candidate}.error.log" ]] && \
                err_log="${LOG_DIR}/${candidate}.error.log"
            [[ -z "$out_log" && -f "${LOG_DIR}/project_b_${candidate}.log" ]] && \
                out_log="${LOG_DIR}/project_b_${candidate}.log"
            [[ -z "$out_log" && -f "${LOG_DIR}/${candidate}.log" ]] && \
                out_log="${LOG_DIR}/${candidate}.log"
        done

        if [[ -n "$err_log" ]]; then
            last_err=$(tail -10 "$err_log" 2>/dev/null)
            if [[ -n "$last_err" ]]; then
                report+="**stderr** (last 10 lines):\n"
                report+="\`\`\`\n${last_err}\n\`\`\`\n"
            fi
        fi

        if [[ -n "$out_log" ]]; then
            last_out=$(tail -10 "$out_log" 2>/dev/null)
            if [[ -n "$last_out" ]]; then
                report+="**stdout** (last 10 lines):\n"
                report+="\`\`\`\n${last_out}\n\`\`\`\n"
            fi
        fi
    done
else
    report+="## Failures\n"
    report+="None.\n"
fi

# Healthy list
report+="## Healthy\n"
for item in "${healthy[@]}"; do
    ts="${agent_lastrun[$item]}"
    out=$(agent_output "$item")
    report+="- ${item}${ts:+ — ${ts}}${out:+ | ${out}}\n"
done

# ── Write Bear note ──────────────────────────────────────────────────────────

# Always create-if-missing then append. Avoids edit conflicts when the note
# already has content from an earlier run or a manual check.
bearcli create "$TITLE" --tags "project_b/status" --if-not-exists >/dev/null 2>&1
printf '%b' "\n---\n${report}" | bearcli append --title "$TITLE"

echo "project_b_container_status: note written (${TITLE}) at ${NOW}"

# ── Investigate failures with Claude ─────────────────────────────────────────

# Only on failures: a clean run costs nothing and leaves the note quiet.
# The agent is read-only by construction -- it diagnoses and recommends, it
# never restarts an agent or touches podman. Widen --allowedTools with care;
# this runs unattended twice a day.
if (( ${#failures[@]} > 0 )) && [[ -x "$CLAUDE_BIN" ]]; then
    echo "project_b_container_status: ${#failures[@]} failure(s), invoking claude"

    # The report we just wrote is the agent's starting context: it already has
    # the exit codes and the log tails, so the agent spends its turns digging
    # rather than rediscovering.
    investigation=$(printf '%b' "$report" | "$TIMEOUT_BIN" "$CLAUDE_TIMEOUT" "$CLAUDE_BIN" \
        -p "$CLAUDE_PROMPT" \
        --allowedTools \
            "Read" "Grep" "Glob" \
            "Bash(tail:*)" "Bash(head:*)" "Bash(grep:*)" "Bash(ls:*)" "Bash(cat:*)" \
            "Bash(wc:*)" "Bash(stat:*)" "Bash(launchctl list:*)" \
            "Bash(launchctl print:*)" "Bash(podman ps:*)" "Bash(podman logs:*)" \
            "Bash(podman machine info:*)" "Bash(podman machine list:*)" \
        --add-dir "$LOG_DIR" \
        2>>"${LOG_DIR}/project_b_container_status.error.log")
    claude_rc=$?

    if (( claude_rc == 124 )); then
        investigation="Investigation timed out after ${CLAUDE_TIMEOUT}."
    elif (( claude_rc != 0 )); then
        investigation="Investigation failed (claude exit ${claude_rc}); see error log."
    elif [[ -z "$investigation" ]]; then
        investigation="Investigation returned no output."
    fi

    printf '%b' "## Investigation\n${investigation}\n" | bearcli append --title "$TITLE"
    echo "project_b_container_status: investigation appended (claude exit ${claude_rc})"
fi

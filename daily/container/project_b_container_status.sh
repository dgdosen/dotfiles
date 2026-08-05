#!/usr/bin/env zsh
#
# Health check for all com.makerboarding.* Launch Agents.
# Gathers launchctl status, tails logs for failures, writes a JSON record every
# run, and writes a Bear note only when something failed.
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
RUN_AT=$(date -Iseconds)
TITLE="project_b_status_${TODAY}"
LOG_DIR="$HOME/log"
SHARE="$HOME/project_b_share"

# ── JSON record config ───────────────────────────────────────────────────────

# Every run also drops a JSON record into the project_b_status repo, which is
# what the static dashboard reads. The Bear note is unaffected: the JSON is
# strictly additive, written last, and a failure to write it never fails the
# run. See docs/SCHEMA.md in that repo for the record shape.
STATUS_DATA_DIR="${STATUS_DATA_DIR:-$HOME/dev/project_b_status/data}"
RUN_JSON="${STATUS_DATA_DIR}/$(date +%Y-%m-%d-%H%M).json"
JQ_BIN="${JQ_BIN:-/opt/homebrew/bin/jq}"

# /usr/bin/git, not the homebrew one: it ships with the OS and is always
# present, which matters for a job that runs unattended.
GIT_BIN="${GIT_BIN:-/usr/bin/git}"
STATUS_REPO="${STATUS_REPO:-$HOME/dev/project_b_status}"
COMMIT_RECORDS="${COMMIT_RECORDS:-1}"   # set 0 to write records without committing

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

# Resolve an agent's log file. $1 = short name, $2 = suffix ("log" or
# "error.log"). Logs are named inconsistently -- some carry the project_b_
# prefix, some don't, and .container jobs sometimes log under the bare name --
# so try each spelling in turn. Empty output means no log was found.
resolve_log() {
    local name="$1" suffix="$2"
    for candidate in "${name}" "${name%.container}"; do
        [[ -f "${LOG_DIR}/project_b_${candidate}.${suffix}" ]] && {
            print -r -- "${LOG_DIR}/project_b_${candidate}.${suffix}"; return
        }
        [[ -f "${LOG_DIR}/${candidate}.${suffix}" ]] && {
            print -r -- "${LOG_DIR}/${candidate}.${suffix}"; return
        }
    done
}

# Extract today's run times from an agent's stdout log.
# Returns comma-separated short times (e.g. "07:15, 10:12").
todays_run_times() {
    local name="$1" log_file
    log_file=$(resolve_log "$name" "log")
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
# Keyed by short name, for the JSON record. The report buckets above are
# display strings ("name (exit 3)"); these keep the values unmangled.
typeset -A agent_label agent_status agent_short_pid agent_short_exit
typeset -A agent_stderr agent_stdout

for label in "${(@o)agents}"; do
    pid="${agent_pid[$label]}"
    ec="${agent_exit[$label]}"
    short="${label#com.makerboarding.}"
    short="${short#com.agidevelopment.}"

    agent_lastrun[$short]=$(todays_run_times "$short")
    agent_label[$short]="$label"
    agent_short_pid[$short]="$pid"
    agent_short_exit[$short]="$ec"

    if [[ "$pid" != "-" && -n "$pid" ]]; then
        running+=("$short (PID $pid)")
        agent_status[$short]="running"
    elif [[ "$ec" != "0" ]]; then
        failures+=("$short (exit $ec)")
        # launchctl prints "-" for a job that has not run this boot. The
        # report keeps calling that a failure (unchanged behaviour), but the
        # record distinguishes it -- a job that silently stops firing looks
        # identical to a healthy one if you only read exit codes.
        if [[ "$ec" == "-" ]]; then
            agent_status[$short]="never_ran"
        else
            agent_status[$short]="failed"
        fi
    else
        healthy+=("$short")
        agent_status[$short]="healthy"
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

        err_log=$(resolve_log "$name" "error.log")
        out_log=$(resolve_log "$name" "log")

        # Stashed as well as printed: the JSON record carries the tails so an
        # old record stays useful after ~/log has rotated out from under it.
        last_err=""
        last_out=""

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

        agent_stderr[$name]="$last_err"
        agent_stdout[$name]="$last_out"
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

# Only on failures. A clean run has nothing worth reading, and a note every
# night trains you to ignore the tag -- the JSON record below still captures
# healthy runs, and the dashboard is the place to look at them.
#
# Create-if-missing then append. Avoids edit conflicts when the note already
# has content from an earlier run or a manual check.
if (( ${#failures[@]} > 0 )); then
    bearcli create "$TITLE" --tags "project_b/status" --if-not-exists >/dev/null 2>&1
    printf '%b' "\n---\n${report}" | bearcli append --title "$TITLE"

    echo "project_b_container_status: note written (${TITLE}) at ${NOW}"
else
    echo "project_b_container_status: clean run, no note written at ${NOW}"
fi

# ── Investigate failures with Claude ─────────────────────────────────────────

# Only on failures: a clean run costs nothing and leaves the note quiet.
# The agent is read-only by construction -- it diagnoses and recommends, it
# never restarts an agent or touches podman. Widen --allowedTools with care;
# this runs unattended twice a day.
investigation_ran=0
investigation=""
claude_rc=0
claude_seconds=0

if (( ${#failures[@]} > 0 )) && [[ -x "$CLAUDE_BIN" ]]; then
    echo "project_b_container_status: ${#failures[@]} failure(s), invoking claude"
    investigation_ran=1
    claude_started=$SECONDS

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
    claude_seconds=$(( SECONDS - claude_started ))

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

# ── Emit the JSON record ─────────────────────────────────────────────────────

# Built with jq --arg, never string interpolation: log tails contain quotes,
# backslashes and control characters that would otherwise produce invalid
# JSON. This is the one place in the pipeline worth being strict about.
#
# Everything here is best-effort. Any Bear note for this run is already written
# by this point, so a missing jq or an unwritable repo costs a record, not a run.
emit_record() {
    [[ -x "$JQ_BIN" ]] || { echo "project_b_container_status: no jq at ${JQ_BIN}, skipping JSON"; return 1; }
    mkdir -p "$STATUS_DATA_DIR" || return 1

    local tmp_agents
    tmp_agents=$(mktemp) || return 1

    local short st ec pid out rt_json exit_json pid_json
    for short in "${(@ko)agent_status}"; do
        st="${agent_status[$short]}"
        ec="${agent_short_exit[$short]}"
        pid="${agent_short_pid[$short]}"
        out=$(agent_output "$short")

        # "-" is launchctl's placeholder, not a value. null it out.
        exit_json="null"
        [[ "$st" != "running" && "$ec" != "-" && -n "$ec" ]] && exit_json="$ec"
        pid_json="null"
        [[ "$st" == "running" && "$pid" != "-" && -n "$pid" ]] && pid_json="$pid"

        # -n with --arg, not -R on stdin: jq -R emits nothing at all for empty
        # input, which would hand the next --argjson an empty string.
        rt_json=$("$JQ_BIN" -n --arg s "${agent_lastrun[$short]}" \
            '$s | split(", ") | map(select(length > 0))')

        "$JQ_BIN" -n \
            --arg name    "$short" \
            --arg label   "${agent_label[$short]}" \
            --arg status  "$st" \
            --arg output  "$out" \
            --arg so      "${agent_stdout[$short]}" \
            --arg se      "${agent_stderr[$short]}" \
            --argjson exit_code "$exit_json" \
            --argjson pid       "$pid_json" \
            --argjson run_times "$rt_json" \
            '{
               name: $name, label: $label, status: $status,
               exit: $exit_code, pid: $pid, run_times: $run_times,
               output:      (if $output == "" then null else $output end),
               stdout_tail: (if $so     == "" then null else $so     end),
               stderr_tail: (if $se     == "" then null else $se     end)
             }' >> "$tmp_agents" || { rm -f "$tmp_agents"; return 1; }
    done

    local inv_json="null"
    if (( investigation_ran )); then
        inv_json=$("$JQ_BIN" -n \
            --arg markdown "$investigation" \
            --argjson exit_code "$claude_rc" \
            --argjson duration  "$claude_seconds" \
            '{ran: true, exit: $exit_code, duration_s: $duration, markdown: $markdown}')
    fi

    "$JQ_BIN" -s \
        --arg run_at "$RUN_AT" \
        --arg host   "$(hostname -s)" \
        --arg podman "$podman_state" \
        --argjson healthy "${#healthy[@]}" \
        --argjson failed  "${#failures[@]}" \
        --argjson running "${#running[@]}" \
        --argjson investigation "$inv_json" \
        '{
           schema_version: 1,
           run_at: $run_at, host: $host, podman_state: $podman,
           summary: {healthy: $healthy, failed: $failed, running: $running},
           agents: .,
           investigation: $investigation
         }' "$tmp_agents" > "$RUN_JSON" || { rm -f "$tmp_agents"; return 1; }

    rm -f "$tmp_agents"

    # Rebuild the index. The dashboard reads this to list runs and draw the
    # trend without needing a directory listing, so it is derived state --
    # always safe to regenerate from the records themselves.
    local f
    for f in "$STATUS_DATA_DIR"/[0-9]*.json; do
        [[ -f "$f" ]] || continue
        "$JQ_BIN" -c --arg file "${f:t}" \
            '{file: $file, run_at: .run_at, summary: .summary,
              investigated: (.investigation != null)}' "$f"
    done | "$JQ_BIN" -s --arg gen "$RUN_AT" \
        '{schema_version: 1, generated_at: $gen,
          runs: (sort_by(.run_at) | reverse)}' > "${STATUS_DATA_DIR}/index.json"

    echo "project_b_container_status: record written (${RUN_JSON:t})"
}

emit_record || echo "project_b_container_status: JSON record failed (note was still written)"

# ── Commit the records ───────────────────────────────────────────────────────

# Is HEAD still local? Amending a commit that has been pushed means a force
# push to fix, so the batching below refuses to rewrite anything published.
# No upstream configured at all counts as local.
head_is_unpushed() {
    local upstream
    upstream=$("$GIT_BIN" -C "$STATUS_REPO" rev-parse --abbrev-ref \
        --symbolic-full-name '@{upstream}' 2>/dev/null) || return 0
    [[ -z "$upstream" ]] && return 0
    # HEAD already contained in the upstream branch => published.
    "$GIT_BIN" -C "$STATUS_REPO" merge-base --is-ancestor HEAD "$upstream" 2>/dev/null && return 1
    return 0
}

# Commit today's records, batched to one commit per day.
#
# Two runs a day committing separately is ~700 commits a year, which makes the
# log useless to read. So the evening run folds into the morning's commit
# rather than adding its own. Records are append-only, so nothing is lost by
# squashing them -- the record files themselves carry the per-run timestamps.
#
# This only ever commits; it does not push. A Launch Agent has no ssh-agent,
# so `git push` over SSH fails here even though the identical command works in
# an interactive shell. Pushing is left to a manual push or the nightly
# dotfiles sweep. To push from here instead, give the job a deploy key with an
# explicit IdentityFile via GIT_SSH_COMMAND in the plist environment.
commit_records() {
    (( COMMIT_RECORDS )) || return 0
    [[ -x "$GIT_BIN" ]] || { echo "project_b_container_status: no git at ${GIT_BIN}, not committing"; return 1; }
    [[ -d "${STATUS_REPO}/.git" ]] || { echo "project_b_container_status: ${STATUS_REPO} is not a git repo, not committing"; return 1; }

    # Stage data/ only. Never sweep up work in progress elsewhere in the repo.
    "$GIT_BIN" -C "$STATUS_REPO" add -- data || return 1

    if "$GIT_BIN" -C "$STATUS_REPO" diff --cached --quiet -- data; then
        echo "project_b_container_status: no record changes to commit"
        return 0
    fi

    local subject="status records ${TODAY_ISO}"
    local head_subject
    head_subject=$("$GIT_BIN" -C "$STATUS_REPO" log -1 --format=%s 2>/dev/null)

    # The pathspec form restricts the commit to data/, so anything the user
    # happened to have staged elsewhere is left staged and uncommitted.
    if [[ "$head_subject" == "$subject" ]] && head_is_unpushed; then
        "$GIT_BIN" -C "$STATUS_REPO" commit --amend --no-edit --only -- data >/dev/null || return 1
        echo "project_b_container_status: records folded into today's commit (${subject})"
    else
        "$GIT_BIN" -C "$STATUS_REPO" commit -m "$subject" --only -- data >/dev/null || return 1
        echo "project_b_container_status: records committed (${subject})"
    fi
}

commit_records || echo "project_b_container_status: commit failed (records were still written)"

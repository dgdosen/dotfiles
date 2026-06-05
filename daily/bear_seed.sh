#!/usr/bin/env zsh
export PATH="$HOME/.local/bin:$PATH"

# Seed Bear intent notes from templates for a rolling ~6-month window.
#
# Horizon = last day of (current month + 5). Intended to run on the 1st of each
# month; each run extends the tail by one month. All creates use
# --if-not-exists, so re-running (on any day) is safe and only fills gaps.
#
#   daily      <date>                   today .. horizon
#   weekly     <Sunday>-weekly          this week's Sunday .. horizon (step 7d)
#   monthly    <year-month>-monthly     current month .. +5 (6 notes)
#   quarterly  <year>-Q<n>-quarterly    current quarter .. quarter of horizon
#
# Example: run on 2026-06-01 -> daily through 2026-11-30, weekly through
# 2026-11-29, monthly through 2026-11, quarterly through 2026-Q4.

LOG_FILE=~/.cron_support/bear_seed.txt
TEMPLATES=~/.dotfiles/templates
TODAY=$(date +%Y-%m-%d)
HORIZON=$(date -v1d -v+6m -v-1d +%Y-%m-%d)   # last day of (current month + 5)

echo "running bear_seed ($TODAY -> $HORIZON)"

# Create one note from a template (if absent), then collapse the title blank line.
create_note() {
  local title=$1 template=$2
  cat "$template" | bearcli create "$title" --if-not-exists >/dev/null
  bearcli edit --title "$title" --find "# ${title}\n\n" --replace "# ${title}\n" 2>/dev/null || true
  echo "  seeded: $title"
}

# Daily: today .. horizon (inclusive). Lexical compare is valid for YYYY-MM-DD.
d="$TODAY"
while [[ ! "$d" > "$HORIZON" ]]; do
  create_note "$d" "$TEMPLATES/tasks.md"
  d=$(date -j -v+1d -f "%Y-%m-%d" "$d" "+%Y-%m-%d")
done

# Weekly: this week's Sunday .. horizon, stepping 7 days.
DOW=$(date +%w)
w=$(date -v-${DOW}d +%Y-%m-%d)
while [[ ! "$w" > "$HORIZON" ]]; do
  create_note "${w}-weekly" "$TEMPLATES/weekly.md"
  w=$(date -j -v+7d -f "%Y-%m-%d" "$w" "+%Y-%m-%d")
done

# Monthly: current month .. +5 (6 notes).
m=0
while [[ $m -le 5 ]]; do
  ym=$(date -v1d -v+${m}m +%Y-%m)
  create_note "${ym}-monthly" "$TEMPLATES/monthly.md"
  ((m++))
done

# Quarterly: current quarter's start .. horizon, stepping 3 months.
MONTH=$(date +%m)
qsm=$(( ((10#$MONTH - 1) / 3) * 3 + 1 ))      # first month of current quarter
qd=$(date -v1d -v${qsm}m +%Y-%m-%d)
while [[ ! "$qd" > "$HORIZON" ]]; do
  qy=$(date -j -f "%Y-%m-%d" "$qd" "+%Y")
  qm=$(date -j -f "%Y-%m-%d" "$qd" "+%m")
  qn=$(( (10#$qm - 1) / 3 + 1 ))
  create_note "${qy}-Q${qn}-quarterly" "$TEMPLATES/quarterly.md"
  qd=$(date -j -v+3m -f "%Y-%m-%d" "$qd" "+%Y-%m-%d")
done

echo "bear_seed completed"
touch "$LOG_FILE"

#!/usr/bin/env zsh
export PATH="$HOME/.local/bin:$PATH"

# Daily "touch" for Bear intent notes.
#
# Every run bumps the four current-period notes so each shows as edited today:
#   daily      <today>                  every day
#   weekly     <Sunday>-weekly          re-touched daily, all week (Sun-anchored)
#   monthly    <year-month>-monthly     re-touched daily, all month
#   quarterly  <year>-Q<n>-quarterly    re-touched daily, all quarter
#
# "Touch" = rewrite the note's "updated ..." line to "updated <today>". This
# handles both the fresh template line ("updated prep") and a prior
# "updated <olddate>" line, so it is safe to run on any day in the period.
# Notes are created ahead of time by bear_seed.sh; a missing note is skipped.

LOG_FILE=~/.cron_support/bear_update.txt
TODAY=$(date +%Y-%m-%d)

# Skip if already run today. The touch is idempotent on its own; this just
# avoids redundant Bear churn when the agent fires more than once a day.
if [[ -f "$LOG_FILE" ]]; then
  LAST_RUN=$(date -r "$LOG_FILE" +%Y-%m-%d 2>/dev/null)
  if [[ "$LAST_RUN" == "$TODAY" ]]; then
    echo "bear_update already ran today ($TODAY), skipping..."
    exit 0
  fi
fi

echo "running bear_update ($TODAY)"

# Bump a single note's "updated" line to today. No-op if the note is missing,
# has no "updated" line, or is already stamped with today's date.
touch_note() {
  local title=$1
  # Collapse Bear's auto-inserted blank line between title and body. No-op if absent.
  bearcli edit --title "$title" --find "# ${title}\n\n" --replace "# ${title}\n" 2>/dev/null || true

  local content current
  content=$(bearcli cat --title "$title" 2>/dev/null) || { echo "  skip (missing): $title"; return 0; }
  current=$(printf '%s\n' "$content" | grep -m1 '^updated ') || true
  if [[ -z "$current" ]]; then
    echo "  skip (no 'updated' line): $title"
    return 0
  fi
  if [[ "$current" == "updated ${TODAY}" ]]; then
    echo "  ok (already today): $title"
    return 0
  fi
  if bearcli edit --title "$title" --find "$current" --replace "updated ${TODAY}" 2>/dev/null; then
    echo "  touched: $title"
  else
    echo "  WARN: failed to touch $title"
  fi
}

# Current-period note titles
DOW=$(date +%w)                          # 0=Sun .. 6=Sat
SUNDAY=$(date -v-${DOW}d +%Y-%m-%d)      # this week's Sunday
YM=$(date +%Y-%m)                        # this month
YEAR=$(date +%Y)
MONTH=$(date +%m)
Q=$(( (10#$MONTH - 1) / 3 + 1 ))         # this quarter

touch_note "$TODAY"                       # daily     - every day
touch_note "${SUNDAY}-weekly"             # weekly    - all week
touch_note "${YM}-monthly"                # monthly   - all month
touch_note "${YEAR}-Q${Q}-quarterly"      # quarterly - all quarter

echo "bear_update completed"
touch "$LOG_FILE"

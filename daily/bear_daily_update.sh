#!/usr/bin/env zsh
export PATH="$HOME/.local/bin:$PATH"

# Update today's daily note in Bear via bcli
# Replaces bear_daily_update which used bear_export_sync.py

LOG_FILE=~/.cron_support/bear_daily_update.txt
TODAY=$(date +%Y-%m-%d)

# Check if already run today
if [[ -f "$LOG_FILE" ]]; then
  LAST_RUN=$(date -r "$LOG_FILE" +%Y-%m-%d 2>/dev/null)
  if [[ "$LAST_RUN" == "$TODAY" ]]; then
    echo "bear_daily_update already ran today ($TODAY), skipping..."
    exit 0
  fi
fi

echo "running bear_daily_update"

# Refresh auth token before calling bcli
bear-token-agent --once || { echo "Token refresh failed"; exit 1; }

# Find today's note by title
NOTE_ID=$(bcli search "$TODAY" --json | jq -r '.[] | select(.title == "'"$TODAY"'") | .id' | head -1)

if [[ -z "$NOTE_ID" ]]; then
  echo "No note found with title $TODAY"
  exit 1
fi

echo "Found note: $NOTE_ID"

# Get current content, replace "updated prep" with today's date, push back
CONTENT=$(bcli get "$NOTE_ID" --raw)
CONTENT=$(echo "$CONTENT" | sed "s/updated prep/updated ${TODAY}/")
echo "$CONTENT" | bcli edit "$NOTE_ID" --stdin
bcli sync

if [ $? -eq 0 ]; then
  echo "bear_daily_update completed successfully"
  touch "$LOG_FILE"
else
  echo "bear_daily_update failed"
  exit 1
fi

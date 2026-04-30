#!/usr/bin/env zsh
export PATH="$HOME/.local/bin:$PATH"

# Update today's daily note in Bear via bearcli

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

bearcli edit --title "$TODAY" --at "updated prep" --replace "updated ${TODAY}"

if [ $? -eq 0 ]; then
  echo "bear_daily_update completed successfully"
  touch "$LOG_FILE"
else
  echo "bear_daily_update failed"
  exit 1
fi

#!/usr/bin/env zsh
export PATH="$HOME/.local/bin:$PATH"

# Create 7 daily notes + 1 weekly note in Bear via bcli
# Replaces bear_weekly_create which used bear_export_sync.py

LOG_FILE=~/.cron_support/bear_weekly_create.txt
TODAY=$(date +%Y-%m-%d)

# Check if already run today
if [[ -f "$LOG_FILE" ]]; then
  LAST_RUN=$(date -r "$LOG_FILE" +%Y-%m-%d 2>/dev/null)
  if [[ "$LAST_RUN" == "$TODAY" ]]; then
    echo "bear_weekly_create already ran today ($TODAY), skipping..."
    exit 0
  fi
fi

echo "running bear_weekly_create"

# Daily notes
counter=1
while [ $counter -le 7 ]; do
  TEMPLATE_DATE=$(date -v+${counter}d +"%Y-%m-%d")
  cat ~/.dotfiles/templates/tasks.md | bcli create "${TEMPLATE_DATE}" --stdin
  ((counter++))
done

# Weekly note
WEEKLY_DATE=$(date -v+1d +"%Y-%m-%d")
cat ~/.dotfiles/templates/weekly.md | bcli create "${WEEKLY_DATE}-Weekly" --stdin

if [ $? -eq 0 ]; then
  echo "bear_weekly_create completed successfully"
  touch "$LOG_FILE"
else
  echo "bear_weekly_create failed"
  exit 1
fi

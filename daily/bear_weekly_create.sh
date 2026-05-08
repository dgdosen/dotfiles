#!/usr/bin/env zsh
export PATH="$HOME/.local/bin:$PATH"

# Create 7 daily notes + 1 weekly note in Bear via bearcli

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

# Collapse Bear's auto-inserted blank line between title and body. No-op if absent.
collapse_title_blank() {
  local title=$1
  bearcli edit --title "$title" --find "# ${title}\n\n" --replace "# ${title}\n" 2>/dev/null || true
}

# Daily notes
counter=1
while [ $counter -le 7 ]; do
  TEMPLATE_DATE=$(date -v+${counter}d +"%Y-%m-%d")
  cat ~/.dotfiles/templates/tasks.md | bearcli create "${TEMPLATE_DATE}" --if-not-exists
  collapse_title_blank "${TEMPLATE_DATE}"
  ((counter++))
done

# Weekly note
WEEKLY_DATE=$(date -v+1d +"%Y-%m-%d")
WEEKLY_TITLE="${WEEKLY_DATE}-Weekly"
cat ~/.dotfiles/templates/weekly.md | bearcli create "${WEEKLY_TITLE}" --if-not-exists
collapse_title_blank "${WEEKLY_TITLE}"

if [ $? -eq 0 ]; then
  echo "bear_weekly_create completed successfully"
  touch "$LOG_FILE"
else
  echo "bear_weekly_create failed"
  exit 1
fi

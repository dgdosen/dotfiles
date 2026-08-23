#!/usr/bin/env zsh
source ~/.zshrc
source "${0:A:h}/_jobs.sh"
job_enabled "$0" PROJECT_B_HARRINGTON_SCRAPE || exit 0

# Only run after 7 PM Pacific, regardless of local timezone
PACIFIC_HOUR=$(TZ=America/Los_Angeles date +%H)
if [[ $PACIFIC_HOUR -lt 19 ]]; then
  echo "Too early — current Pacific hour: $PACIFIC_HOUR, waiting for 19"
  exit 0
fi

# Only run once per day (Pacific date)
PACIFIC_DATE=$(TZ=America/Los_Angeles date +%Y-%m-%d)
SENTINEL=~/.cron_support/cron_project_b_harrington_scrape.txt
if [[ -f "$SENTINEL" ]]; then
  LAST_RUN=$(stat -f %Sm -t %Y-%m-%d "$SENTINEL" 2>/dev/null)
  if [[ "$LAST_RUN" == "$PACIFIC_DATE" ]]; then
    echo "Already ran today ($PACIFIC_DATE) — skipping"
    exit 0
  fi
fi

# Past the guards — from here any failure should fail the job, leaving the
# sentinel unstamped so the 21:15 run retries.
set -e
cd $HOME/dev/project_b_harrington_scrape_cli
har() { bun src/index.ts "$@" }

if ! har check-archive; then
  echo "Tomorrow's archive already present — skipping"
  exit 0
fi

har fetch
touch "$SENTINEL"

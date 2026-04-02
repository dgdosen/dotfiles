#!/usr/bin/env zsh
source ~/.zshrc

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

cd $HOME/dev/project_b_harrington_scrape_cli

# Skip if archive file already exists for tomorrow
if ! pnpm start check-archive; then
  exit 0
fi

# Only fetch if SA has races scheduled tomorrow
if pnpm start check-schedule SA; then
  pnpm start fetch
fi

touch "$SENTINEL"

#!/usr/bin/env zsh
# Hourly (at :15) via com.quantifiedflow.qf_echo_scrape: collect new posts from
# the X lists in ~/dev/qf_echo/config.json (also republishes the scrolling viewer).
source ~/.zshrc

cd $HOME/dev/qf_echo || exit 1
echo "== $(date '+%Y-%m-%d %H:%M:%S') scrape"

# Shared lock with qf_echo_edition.sh: never scrape and cut an edition at once.
/usr/bin/lockf -t 600 $HOME/.cron_support/qf_echo.lock npm run scrape || exit $?

touch ~/.cron_support/cron_qf_echo_scrape.txt

#!/usr/bin/env zsh
# 07:30 / 12:00 / 16:00 / 22:00 via com.quantifiedflow.qf_echo_edition: scrape,
# cut the due edition, and publish pages + RSS to the TrueNAS `sites` share.
# Late/missed runs are fine: `edition` publishes the latest due slot and is idempotent.
# Keep these times in sync with the `editions` schedule in qf_echo (docs/editions.md).
source ~/.zshrc

cd $HOME/dev/qf_echo || exit 1
echo "== $(date '+%Y-%m-%d %H:%M:%S') edition"

# Shared lock with qf_echo_scrape.sh: wait for an in-flight scrape to finish.
/usr/bin/lockf -t 600 $HOME/.cron_support/qf_echo.lock npm run edition || exit $?

touch ~/.cron_support/cron_qf_echo_edition.txt

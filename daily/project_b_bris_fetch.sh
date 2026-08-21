#!/usr/bin/env zsh
source ~/.zshrc
source "${0:A:h}/_jobs.sh"
job_enabled "$0" PROJECT_B_BRIS_FETCH || exit 0
cd $HOME/dev/project_b_brisnet_scrape_cli
bun run dev

touch ~/.cron_support/cron_project_b_drf_bris_scrape.txt

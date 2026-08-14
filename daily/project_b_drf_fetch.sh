#!/usr/bin/env zsh
source ~/.zshrc
source "${0:A:h}/_jobs.sh"
job_enabled "$0" PROJECT_B_DRF_FETCH || exit 0
cd $HOME/dev/project_b_drf_scrape_cli
bun src/index.ts scrape_drf_data
bun src/index.ts download_drf_files

touch ~/.cron_support/cron_project_b_drf_scrape.txt

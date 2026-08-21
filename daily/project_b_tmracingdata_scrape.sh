#!/usr/bin/env zsh
source ~/.zshrc
source "${0:A:h}/_jobs.sh"
job_enabled "$0" PROJECT_B_TMRACINGDATA_SCRAPE || exit 0
set -e
cd $HOME/dev/project_b_tmracingdata_scrape_cli

bun src/index.ts fetch-all

bun src/index.ts process

touch ~/.cron_support/cron_project_b_tmracingdata_scrape.txt

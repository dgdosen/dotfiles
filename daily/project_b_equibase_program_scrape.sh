#!/usr/bin/env zsh
source ~/.zshrc
source "${0:A:h}/_jobs.sh"
job_enabled "$0" PROJECT_B_EQUIBASE_PROGRAM_SCRAPE || exit 0

cd $HOME/dev/project_b_equibase_program_scrape_cli
pnpm exec tsx src/index.ts fetch-all

touch ~/.cron_support/cron_project_b_equibase_program_scrape.txt

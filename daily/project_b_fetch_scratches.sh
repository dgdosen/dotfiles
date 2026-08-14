#!/usr/bin/env zsh
source ~/.zshrc
source "${0:A:h}/_jobs.sh"
job_enabled "$0" PROJECT_B_FETCH_SCRATCHES || exit 0
cd $HOME/dev/project_b_api
RAILS_ENV=development bundle exec rake project_b:fetch_scratches

touch ~/.cron_support/cron_project_b_fetch_scratches.txt

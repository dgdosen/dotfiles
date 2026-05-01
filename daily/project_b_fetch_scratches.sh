#!/usr/bin/env zsh
source ~/.zshrc
cd $HOME/dev/project_b_api
RAILS_ENV=development bundle exec rake project_b:fetch_scratches

touch ~/.cron_support/cron_project_b_fetch_scratches.txt

#!/usr/local/bin/zsh
# run the audit locally...
source ~/.zshrc
echo - running the project b gmax (and other?) audit for missing race data
cd $HOME/dev/project_b_api
export RAILS_ENV=development
bundle exec rake project_b:audit:json_for_missing_gmax_for_future_races
touch ~/.cron_support/cron_project_b_gmax_audit.txt

# tirgger tehe processing right away!
cd $HOME/dev/project_b_gmax_scrape_cli
yarn dev

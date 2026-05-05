#!/usr/bin/env zsh
source ~/.zshrc

cd $HOME/dev/project_b_twinspires_odds_scrape_cli
yarn dev

touch ~/.cron_support/cron_project_b_twinspires_scrape.txt


#!/usr/bin/env zsh
source ~/.zshrc
cd $HOME/dev/project_b_drf_scrape_cli
yarn dev

touch ~/.cron_support/cron_project_drf_scrape.txt

#!/usr/bin/env zsh
source ~/.zshrc
cd $HOME/dev/project_b_drf_scrape_cli
yarn start scrape_drf_data
yarn start download_drf_files

touch ~/.cron_support/cron_project_drf_scrape.txt

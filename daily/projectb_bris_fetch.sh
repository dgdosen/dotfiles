#!/bin/zsh
source ~/.zshrc
cd $HOME/dev/project_b_brisnet_scrape_cli
yarn dev

touch ~/.cron_support/cron_project_drf_bris_scrape.txt

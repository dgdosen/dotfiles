#!/usr/bin/env zsh
source ~/.zshrc
cd $HOME/dev/project_b_drf_scrape_cli
bun src/index.ts scrape_drf_data
bun src/index.ts download_drf_files

touch ~/.cron_support/cron_project_b_drf_scrape.txt

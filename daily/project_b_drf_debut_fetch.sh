#!/usr/bin/env zsh
source ~/.zshrc
cd $HOME/dev/project_b_drf_debut_scrape_cli
bun src/index.ts

touch ~/.cron_support/cron_project_b_drf_debut_scrape.txt

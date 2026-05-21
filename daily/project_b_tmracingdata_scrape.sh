#!/usr/bin/env zsh
source ~/.zshrc
set -e
cd $HOME/dev/project_b_tmracingdata_scrape_cli

pnpm build

pnpm dev fetch-all
pnpm dev process

touch ~/.cron_support/cron_project_b_tmracingdata_scrape.txt

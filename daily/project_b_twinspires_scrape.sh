#!/usr/bin/env zsh
source ~/.zshrc

cd $HOME/dev/project_b_twinspires_odds_scrape_cli
pnpm exec tsx src/index.ts fetch-all

touch ~/.cron_support/cron_project_b_twinspires_scrape.txt


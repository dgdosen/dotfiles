#!/usr/bin/env zsh
set -e
source ~/.zshrc
cd $HOME/dev/project_b_progressive_breeding_scrape_cli

pnpm build

pnpm start fetch -t sa
pnpm start fetch -t cd
pnpm start fetch -t dmr
pnpm start process

touch ~/.cron_support/cron_project_b_progressive_breeding_scrape.txt

#!/usr/bin/env zsh
source ~/.zshrc
set -e
cd $HOME/dev/project_b_progressive_breeding_scrape_cli

pnpm build

pnpm dev fetch
pnpm dev process

# pnpm start fetch -t sa
# pnpm start fetch -t cd
# pnpm start fetch -t dmr
# pnpm start process

touch ~/.cron_support/cron_project_b_progressive_breeding_scrape.txt

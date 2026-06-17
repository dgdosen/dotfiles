#!/usr/bin/env zsh
source ~/.zshrc

cd $HOME/dev/quantified_so
npm run scrape

touch ~/.cron_support/cron_quantified_so_scrape.txt

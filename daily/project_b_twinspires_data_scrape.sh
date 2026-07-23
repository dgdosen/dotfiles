#!/usr/bin/env zsh
source ~/.zshrc

cd $HOME/dev/project_b_twinspires_data_scrape_cli
# Run with bun (host has it at /opt/homebrew/bin/bun), matching the container's
# `ENTRYPOINT ["bun", "src/index.ts"]`. Was `pnpm exec tsx …`, but tsx is not a
# declared dependency in this repo, so it failed with `Command "tsx" not found`
# on every fire. bun executes the TypeScript directly — no tsx needed.
bun src/index.ts fetch-all

touch ~/.cron_support/cron_project_b_twinspires_data_scrape.txt

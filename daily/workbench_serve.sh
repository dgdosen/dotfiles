#!/usr/bin/env zsh
# Read-only Project B workbench tool server for Open WebUI, on 127.0.0.1:8082.
# Run by com.agidevelopment.workbench_serve. Mac Studio only.
# Code and repo/database list: ~/dev/ds4/workbench/. SQL runs as the Postgres
# role project_b_reader (SELECT-only). Registered in Open WebUI under
# Admin Settings > External Tools with the bearer token below.

export WORKBENCH_TOKEN=$(cat $HOME/.config/workbench/token)
export PATH=/opt/homebrew/bin:$PATH   # launchd's PATH lacks Homebrew; file tools need rg

exec /opt/homebrew/bin/bun $HOME/dev/ds4/workbench/workbench.ts

#!/usr/bin/env zsh
source ~/.zshrc
# PGDATA=$HOME/Library/Application\ Support/Postgres/var-13 pg_ctl stop
# PGDATA=$HOME/Library/Application\ Support/Postgres/var-13 pg_ctl start
PGDATA=/opt/homebrew/var/postgres pg_ctl stop
PGDATA=/opt/homebrew/var/postgres pg_ctl start
# echo - updating project b db
# $HOME/.dotfiles/.postgres/postgres_project_b_dw_reset.sh
# touch ~/.cron_support/cron_project_b_dw.txt

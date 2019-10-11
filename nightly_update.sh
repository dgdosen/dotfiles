#!/usr/local/bin/zsh
source ~/.zshrc
touchfoo
echo - updating zsh components
dotup
echo - updating brew components
brewup
echo - updating project b data
PGDATA=/Users/ddosen/Library/Application\ Support/Postgres/var-11 pg_ctl stop
PGDATA=/Users/ddosen/Library/Application\ Support/Postgres/var-11 pg_ctl start
echo - updating project b dw
$HOME/postgres_project_b_dw_reset.sh
echo - updating project b db
$HOME/postgres_project_b_reset.sh

#!/usr/local/bin/zsh
echo - updating zsh components
dotup
echo - updating brew components
brewup
echo - fetching git repos
fetchthegits
echo - updating project b data
PGDATA=$HOME/Library/Application\ Support/Postgres/var-12 pg_ctl stop
PGDATA=$HOME/Library/Application\ Support/Postgres/var-12 pg_ctl start
echo - updating project b dw
$HOME/.dotfiles/.postgres/postgres_project_b_dw_reset.sh
echo - updating project b db
$HOME/.dotfiles/.postgres/postgres_project_b_reset.sh

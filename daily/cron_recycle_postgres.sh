#!/usr/local/bin/zsh
source ~/.zshrc
echo - recyling postgres
# PGDATA=$HOME/Library/Application\ Support/Postgres/var-13 pg_ctl stop
# PGDATA=$HOME/Library/Application\ Support/Postgres/var-13 pg_ctl start
# PGDATA=/opt/homebrew/var/postgres pg_ctl stop
# PGDATA=/opt/homebrew/var/postgres pg_ctl start
brew services stop postgresql
sleep 5
brew services start postgresql

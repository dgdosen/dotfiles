#!/usr/bin/env zsh
source ~/.zshrc
echo - updating project b data

# Replace 'your_database_name' and 'your_username' with actual database name and username
DB_NAME="project_b_dw_development"
DB_USER="postgres"
SQL_CMD="SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '$DB_NAME' AND pid <> pg_backend_pid();"
psql -U $DB_USER -c "$SQL_CMD"

# PGDATA=$HOME/Library/Application\ Support/Postgres/var-13 pg_ctl stop
# PGDATA=$HOME/Library/Application\ Support/Postgres/var-13 pg_ctl start
# PGDATA=/opt/homebrew/var/postgresql@14 pg_ctl stop
# PGDATA=/opt/homebrew/var/postgresql@14 pg_ctl start
echo - updating project b db
$HOME/.dotfiles/.postgres/postgres_project_b_dw_reset.sh

cd $HOME/dev/project_b_api
export RAILS_ENV=development
bundle exec rake db:migrate:warehouse

touch ~/.cron_support/cron_project_b_dw.txt

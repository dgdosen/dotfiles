#!/bin/zsh

set -e
set -u
psql \
    -U postgres \
    -f $HOME/.dotfiles/.postgres/sp_data.sql \
    project_b_development

# psql_exit_status = $?

# if [ $psql_exit_status != 0 ]; then
#     echo "psql failed while trying to run this sql script" 1>&2
#     exit $psql_exit_status
# fi

echo "sql script successful"
exit 0

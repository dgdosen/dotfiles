#!/bin/zsh

set -e
set -u
psql \
    -U postgres \
    -f $HOME/.dotfiles/.postgres/sp_data.sql \
    project_b_development

exit 0

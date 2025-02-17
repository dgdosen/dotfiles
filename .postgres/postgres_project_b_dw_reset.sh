#!/usr/bin/env zsh
echo --
echo dropping database
dropdb -U postgres -h localhost project_b_dw_development
echo creating database
createdb -U postgres -h localhost project_b_dw_development

echo restoring
date
file=$(ls -t "$DROPBOX_BUSINESS/Daniel Dosen/joined_shares/project_b_share/pg_dw_database_backup/"project_b* | head -1)
echo $file
pg_restore "$file" -U postgres -d project_b_dw_development -h localhost -Fc >> /dev/null
# pg_restore $file -U postgres -d project_b_dw_development -h localhost -Fc > /dev/null
date
echo finished restoring

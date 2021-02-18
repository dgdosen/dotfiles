#!/bin/bash
echo --

echo backing up
date
FILE_DATE=$(date +"%Y-%m-%d")
FILE_NAME_DW="project_b_dw_7x-${FILE_DATE}.backup"
FILE_NAME="project_b_7x-${FILE_DATE}.backup"

DW_DB_FILE=$HOME/dropboxm/joined_shares/project_b_share/pg_dw_database_staging_backup/$FILE_NAME_DW
pg_dump --host=localhost --format=c --username=postgres --file=$DW_DB_FILE project_b_dw_development

DB_FILE=$HOME/dropboxm/joined_shares/project_b_share/pg_database_staging_backup/$FILE_NAME
pg_dump --host=localhost --format=c --username=postgres --file=$DB_FILE project_b_development

# file=$HOME/dropboxm/joined_shares/project_b_share/pg_database_staging_backup/$FILE_NAME

# pg_dump --host=localhost --format=c --username=postgres --file=#{CONFIG[:project_b_backup_location]}#{name} project_b_development

# file=$(ls -t $HOME/dropboxm/joined_shares/project_b_share/pg_database_backup/project_b* | head -1)
echo $file
# pg_restore $file -U postgres -d project_b_development -h localhost -j 3 -Fc > /dev/null
date
echo finished restoring

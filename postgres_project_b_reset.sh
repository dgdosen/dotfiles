#!/bin/bash
echo dropping database
dropdb -U postgres -h localhost project_b
echo creating database
createdb -U postgres -h localhost project_b

echo restoring
date
time
file=$(ls -t /Users/ddosen/Dropbox/joined_shares/project_b_share/pg_database_backup/project_b* | head -1)
echo $file
pg_restore $file -U postgres -d project_b -h localhost -j 3 -Fc > /dev/null
date
echo finished restoring

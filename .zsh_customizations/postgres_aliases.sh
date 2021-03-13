local_pg_backup() {
  todays_date=`date '+%Y_%m_%d'`
  computer_name=`scutil --get LocalHostName`
  filename=/Users/ddosen/Dropbox\ \(personal\)/_my.documents/data.backup/_pg.backup/esi/site_visit_$today\_$computer_name.backup

  pg_dump --file=$filename --format=c --port=5432 --username=postgres site_visit_dev

  filename=/Users/ddosen/Dropbox\ \(personal\)/_my.documents/data.backup/_accounting.backup/accountingtrak/accountingtrak_$today\_$computer_name.backup
  pg_dump --file=$filename --format=c --port=5432 --username=postgres accountingtrak

  filename=/Users/ddosen/Dropbox\ \(personal\)/_my.documents/data.backup/_accounting.backup/huntington_court/huntingtoncourt_$today\_$computer_name.backup
  pg_dump --file=$filename --format=c --port=5432 --username=postgres huntingtoncourt

  filename=/Users/ddosen/Dropbox\ \(personal\)/_my.documents/data.backup/_accounting.backup/dosen_financial/dosen_financial_$today\_$computer_name.backup
  pg_dump --file=$filename --format=c --port=5432 --username=postgres dosen_financial
}

postgres_stop_pg_ctl() {
  
}

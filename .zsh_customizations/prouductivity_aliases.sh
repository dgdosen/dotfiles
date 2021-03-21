bear_backlink_update() {
  CURRENT_DIR=$PWD
  echo updating bear backlinks
  cd ~/dev/bear_markdown_export

  python3 ~/dev/bear_markdown_export/bear_export_sync.py --out ~/dropboxm/Apps/bearapp/sync --backup ~/dropboxm/Apps/bearapp/backup

  note-link-janitor ~/dropboxm/Apps/bearapp/sync

  python3 ~/dev/bear_markdown_export/bear_export_sync.py --out ~/dropboxm/Apps/bearapp/sync --backup ~/dropboxm/Apps/bearapp/backup

  cd $CURRENT_DIR

}

bear_daily_update() {
  TEMPLATE_DATE=$(date +"%Y-%m-%d")
  TASKS_FILE_NAME="${TEMPLATE_DATE}.md"

  gsed -i "s/updated prep/updated ${TEMPLATE_DATE}/" ~/dropboxm/Apps/bearapp/sync/${TASKS_FILE_NAME}

  python3 ~/dev/bear_markdown_export/bear_export_sync.py --out ~/dropboxm/Apps/bearapp/sync --backup ~/dropboxm/Apps/bearapp/backup

}


bear_weekly_create() {

  counter=1
  while [ $counter -le 7 ]
  do
    TEMPLATE_DATE=$(date -v +${counter}d +"%Y-%m-%d")
    TASKS_FILE_NAME="${TEMPLATE_DATE}"

    echo "# ${TEMPLATE_DATE}" > /tmp/newfile
    cat ~/.dotfiles/templates/tasks.md >> /tmp/newfile
    cp /tmp/newfile ~/dropboxm/Apps/bearapp/sync/${TASKS_FILE_NAME}

    ((counter ++))
  done

  bear_backlink_update

}

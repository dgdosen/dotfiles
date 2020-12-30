bear-backlink-update() {
  CURRENT_DIR=$PWD
  echo updating bear backlinks
  cd ~/dev/bear_markdown_export

  python3 ~/dev/bear_markdown_export/bear_export_sync.py --out ~/dropboxm/Apps/bearapp/sync --backup ~/dropboxm/Apps/bearapp/backup

  note-link-janitor ~/dropboxm/Apps/bearapp/sync

  python3 ~/dev/bear_markdown_export/bear_export_sync.py --out ~/dropboxm/Apps/bearapp/sync --backup ~/dropboxm/Apps/bearapp/backup

  cd $CURRENT_DIR

}

bear-create-daily() {

  CURRENT_DATE=$(date +"%Y-%m-%d")
  JOURNAL_FILE_NAME="${CURRENT_DATE} journal.md"
  TASKS_FILE_NAME="${CURRENT_DATE} tasks.md"

  # use the day:
  # create a couple of new files in bear, using template,
  # cp ~/.dotfiles/templates/journal.md ~/dropboxm/Apps/bearapp/sync/${JOURNAL_FILE_NAME}

  echo "# ${CURRENT_DATE} journal" > /tmp/newfile
  cat ~/.dotfiles/templates/journal.md >> /tmp/newfile
  cp /tmp/newfile ~/dropboxm/Apps/bearapp/sync/${JOURNAL_FILE_NAME}

  echo "# ${CURRENT_DATE} tasks" > /tmp/newfile
  cat ~/.dotfiles/templates/tasks.md >> /tmp/newfile
  cp /tmp/newfile ~/dropboxm/Apps/bearapp/sync/${TASKS_FILE_NAME}

  bear-backlink-update

}

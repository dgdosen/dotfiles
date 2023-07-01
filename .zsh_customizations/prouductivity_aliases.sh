bear_backlink_update() {
  CURRENT_DIR=$PWD
  echo updating bear backlinks
  cd ~/dev/bear_markdown_export

  # sync
  python3 ~/dev/bear_markdown_export/bear_export_sync.py --out ~/dev/bear_sync/sync --backup ~/dev/bear_sync/backup

  # update
  note-link-janitor ~/dev/bear_sync/sync

  # sync again?
  python3 ~/dev/bear_markdown_export/bear_export_sync.py --out ~/dev/bear_sync/sync --backup ~/dev/bear_sync/backup

  cd $CURRENT_DIR

}

bear_daily_update() {
  TEMPLATE_DATE=$(date +"%Y-%m-%d")
  # NOTE: this is macos only, linux is different
  TEMPLATE_YESTERDAY=$(date -j -v -1d +"%Y-%m-%d")
  TASKS_FILE_NAME="${TEMPLATE_DATE}.md"

  # for file in `find  ~/dev/bear_sync/sync -maxdepth 1 -type f -name "${TEMPLATE_YESTERDAY}*"`
  # do
  #   REPLACEMENT="${file}/${TEMPLATE_DATE}/${TEMPLATE_YESTERDAY}"
  #   echo "${TEMPLATE_DATE} - ${TEMPLATE_YESTERDAY} - ${REPLACEMENT}"
  #   echo cp "$file" "${REPLACEMENT}"
  # done

  gsed -i "s/updated prep/updated ${TEMPLATE_DATE}/" ~/dev/bear_sync/sync/${TASKS_FILE_NAME}

  # sync
  python3 ~/dev/bear_markdown_export/bear_export_sync.py --out ~/dev/bear_sync/sync --backup ~/dev/bear_sync/backup

}


bear_weekly_create() {

  counter=1
  while [ $counter -le 7 ]
  do
    TEMPLATE_DATE=$(date -v +${counter}d +"%Y-%m-%d")
    TASKS_FILE_NAME="${TEMPLATE_DATE}.md"

    echo "# ${TEMPLATE_DATE}" > /tmp/newfile
    cat ~/.dotfiles/templates/tasks.md >> /tmp/newfile
    cp /tmp/newfile ~/dev/bear_sync/sync/${TASKS_FILE_NAME}

    ((counter ++))
  done

  # sync
  python3 ~/dev/bear_markdown_export/bear_export_sync.py --out ~/dev/bear_sync/sync --backup ~/dev/bear_sync/backup

}

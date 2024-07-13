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
  # python3 ~/dev/bear_markdown_export/bear_export_sync.py --out ~/dev/bear_sync/sync --backup ~/dev/bear_sync/backup


  gsed -i "s/updated prep/updated ${TEMPLATE_DATE}/" ~/dev/bear_sync/sync/${TASKS_FILE_NAME}

  # sync
  python3 ~/dev/bear_markdown_export/bear_export_sync.py --out ~/dev/bear_sync/sync --backup ~/dev/bear_sync/backup

}

bear_weekly_create() {

  # create new daily's
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

  # create new weekly
  WEEKLY_TEMPLATE_DATE=$(date +"%Y-%m-%d")
  WEEKLY_TASKS_FILE_NAME="${WEEKLY_TEMPLATE_DATE}-Weekly.md"
  echo "# ${WEEKLY_TEMPLATE_DATE}-Weekly" > /tmp/newfile
  cat ~/.dotfiles/templates/weekly.md >> /tmp/newfile
  cp /tmp/newfile ~/dev/bear_sync/sync/${WEEKLY_TASKS_FILE_NAME}

  # sync
  python3 ~/dev/bear_markdown_export/bear_export_sync.py --out ~/dev/bear_sync/sync --backup ~/dev/bear_sync/backup

}

function display_pipe() {
  clear
  # Check if the pipe path is provided as an argument
  if [ -z "$1" ]; then
    echo "Usage: display_pipe <path_to_pipe>"
    return 1  # Return with error if no argument is given
  fi

  # Read from the pipe and process the output with awk
  cat "$1" | awk '{
      len = length($0);
      for (i = 1; i <= len; i++) {
          printf "%s", substr($0, i, 1);
          fflush(stdout);  # Flush output immediately
          system("sleep 0.02");  # Delay between characters, adjust as needed
      }
      printf "\n";  # Print newline at the end of each line
  }'
}




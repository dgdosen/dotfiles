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




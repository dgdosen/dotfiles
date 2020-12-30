bear-backlink-update() {
  CURRENT_DIR=$PWD
  echo updating bear backlinks
  cd ~/dev/bear_markdown_export

  python3 ~/dev/bear_markdown_export/bear_export_sync.py --out ~/dropboxm/Apps/bearapp/sync --backup ~/dropboxm/Apps/bearapp/backup

  note-link-janitor ~/dropboxm/Apps/bearapp/sync

  python3 ~/dev/bear_markdown_export/bear_export_sync.py --out ~/dropboxm/Apps/bearapp/sync --backup ~/dropboxm/Apps/bearapp/backup

  cd $CURRENT_DIR

}


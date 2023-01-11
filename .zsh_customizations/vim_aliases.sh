nvim_lua() {
  # force a move of the nvim_lua .local and .config files to nvim
  # TODO: is this to risky?
  rm -f ~/.config/nvim
  rm -f ~/.local/share/nvim

  ln -sf  ~/.config/nvim_lua ~/.config/nvim
  ln -sf  ~/.local/share/nvim_lua ~/.local/share/nvim

  # TEMPLATE_DATE=$(date +"%Y-%m-%d")
  # # NOTE: this is macos only, linux is different
  # TEMPLATE_YESTERDAY=$(date -j -v -1d +"%Y-%m-%d")
  # TASKS_FILE_NAME="${TEMPLATE_DATE}.md"

  # # for file in `find  ~/dropboxp/Apps/bearapp_b2/sync -maxdepth 1 -type f -name "${TEMPLATE_YESTERDAY}*"`
  # # do
  # #   REPLACEMENT="${file}/${TEMPLATE_DATE}/${TEMPLATE_YESTERDAY}"
  # #   echo "${TEMPLATE_DATE} - ${TEMPLATE_YESTERDAY} - ${REPLACEMENT}"
  # #   echo cp "$file" "${REPLACEMENT}"
  # # done

  # gsed -i "s/updated prep/updated ${TEMPLATE_DATE}/" ~/dropboxp/Apps/bearapp_b2/sync/${TASKS_FILE_NAME}

  # # sync
  # python3 ~/dev/bear_markdown_export/bear_export_sync.py --out ~/dropboxp/Apps/bearapp_b2/sync --backup ~/dropboxp/Apps/bearapp_b2/backup
}

# TEMPLATE_DATE=$(date +"%Y-%m-%d")
# # NOTE: this is macos only, linux is different
# TEMPLATE_YESTERDAY=$(date -j -v -1d +"%Y-%m-%d")
# TASKS_FILE_NAME="${TEMPLATE_DATE}.md"

# # for file in `find  ~/dropboxp/Apps/bearapp_b2/sync -maxdepth 1 -type f -name "${TEMPLATE_YESTERDAY}*"`
# # do
# #   REPLACEMENT="${file}/${TEMPLATE_DATE}/${TEMPLATE_YESTERDAY}"
# #   echo "${TEMPLATE_DATE} - ${TEMPLATE_YESTERDAY} - ${REPLACEMENT}"
# #   echo cp "$file" "${REPLACEMENT}"
# # done

# gsed -i "s/updated prep/updated ${TEMPLATE_DATE}/" ~/dropboxp/Apps/bearapp_b2/sync/${TASKS_FILE_NAME}

# # sync
# python3 ~/dev/bear_markdown_export/bear_export_sync.py --out ~/dropboxp/Apps/bearapp_b2/sync --backup ~/dropboxp/Apps/bearapp_b2/backup

nvim_vimscript() {
  rm -f ~/.config/nvim
  rm -f ~/.local/share/nvim
  ln -sf ~/.config/nvim_vimscript ~/.config/nvim
  ln -sf ~/.local/share/nvim_vimscript ~/.local/share/nvim
}

nvim_lua_kickstart() {
  rm -f ~/.config/nvim
  rm -f ~/.local/share/nvim
  ln -sf  ~/.config/nvim_lua_kickstart ~/.config/nvim
  ln -sf  ~/.local/share/nvim_lua_kickstart ~/.local/share/nvim
}

nvim_reset() {
  unset VIM
}

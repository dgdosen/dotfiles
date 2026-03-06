-- require("vim-dadbod-ui").setup({})
-- nothing to see here
vim.g['db_ui_win_position'] = 'right'
vim.g['db_ui_use_nerd_fonts'] = 1
vim.g['db_ui_execute_on_save'] = 0
vim.g['db_ui_use_nerd_fonts'] = 1
-- vim.g['db_ui_save_location'] = '~/.local/share/dbui'
-- this next line works, but is achieved by a symlink we have in .local
-- vim.g['db_ui_save_location'] = '~/.dotfiles/local/share/nvim/sqlua'

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "dbui", "sql" },
  callback = function()
    vim.keymap.set("n", "<leader>r", "<Plug>(DBUI_ExecuteQuery)", { buffer = true, remap = true })
    vim.keymap.set("v", "<leader>r", "<Plug>(DBUI_ExecuteQuery)", { buffer = true, remap = true })
  end,
})

-- require("vim-dadbod-ui").setup({})
-- nothing to see here
vim.g['db_ui_win_position'] = 'right'
vim.g['db_ui_use_nerd_fonts'] = 1
vim.g['db_ui_execute_on_save'] = 0
vim.g['db_ui_use_nerd_fonts'] = 1

-- WHERE SAVED QUERIES LIVE (pinned explicitly so it's documented, not remembered).
-- Saved queries land in <save_location>/<connection_name>/<name>.sql, e.g.
--   ~/.dotfiles/local/share/nvim/sqlua/hchoa_dev/vendors.sql
-- Previously this relied on the default (~/.local/share/db_ui) + a symlink into
-- .dotfiles. Pointing straight at the repo path removes that hidden dependency.
-- (connections.json also lives here — it defines hchoa_dev, project_b_dev, etc.)
vim.g['db_ui_save_location'] = '~/.dotfiles/local/share/nvim/sqlua'

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "dbui", "sql" },
  callback = function()
    vim.keymap.set("n", "<leader>r", "<Plug>(DBUI_ExecuteQuery)", { buffer = true, remap = true })
    vim.keymap.set("v", "<leader>r", "<Plug>(DBUI_ExecuteQuery)", { buffer = true, remap = true })

    -- Reliable <leader>W save. Dadbod only defines <Plug>(DBUI_SaveQuery) inside a
    -- *New query* scratch buffer, so its own <leader>W is a dead key everywhere else
    -- -- which is how queries used to get lost to $TMPDIR via a plain :w. This wrapper
    -- prompts + saves into the connection folder when in a scratch buffer, and just
    -- writes the file when it's already a saved query.
    vim.keymap.set("n", "<leader>W", function()
      if vim.fn.maparg("<Plug>(DBUI_SaveQuery)", "n") ~= "" then
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<Plug>(DBUI_SaveQuery)", true, false, true), "m", false)
      else
        vim.cmd("write") -- already a real file under the save_location tree
      end
    end, { buffer = true, desc = "DBUI: save query" })
  end,
})

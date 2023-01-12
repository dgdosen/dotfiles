vim.g.copilot_filetypes = { xml = false }
vim.cmd[[highlight CopilotSuggestion guifg=#10B870C ctermfg=8]]


-- vim.cmd[[imap <silent><script><expr> <C-a> copilot#Accept("\<CR>")]]
-- vim.g.copilot_no_tab_map = true
-- vim.keymap.set.keymap("i", "<C-a>", ":copilot#Accept('\\<CR>')<CR>", {silent = true })
--
-- -- <C-]>                   Dismiss the current suggestion.
-- -- <Plug>(copilot-dismiss)


-- require('copilot').setup({
--   vim.g.copilot_filetypes = {xml = false},
-- })

-- NOT USED
-- See plugins.lua - this setup is not loaded
-- using copilot.lua and cmp.copilot in plugins.

-- vim.g.copilot_filetypes = { xml = false }
-- vim.cmd [[highlight CopilotSuggestion guifg=#10B870C ctermfg=8]]
--
-- -- vim.api.nvim_set_keymap("i", "<C-a>", "copilot#Accept('<CR>')", { expr = true, silent = true})
--
-- vim.cmd[[imap <silent><script><expr> <C-a> copilot#Accept("\<CR>")]]
-- vim.g.copilot_no_tab_map = true
-- -- vim.keymap.set.keymap("i", "<C-a>", ":copilot#Accept('\\<CR>')<CR>", {silent = true })

-- <C-]>                   Dismiss the current suggestion.
-- <Plug>(copilot-dismiss)


-- require('copilot').setup({
--   vim.g.copilot_filetypes = {xml = false},
-- })


-- via copilot.luau
require('copilot').setup({
  panel = {
    enabled = true,
    auto_refresh = false,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>"
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = false,
    debounce = 75,
    keymap = {
      accept = "<M-l>",
      accept_word = false,
      accept_line = false,
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  filetypes = {
    yaml = false,
    markdown = false,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
  copilot_node_command = 'node', -- Node.js version must be > 16.x
  server_opts_overrides = {},
})

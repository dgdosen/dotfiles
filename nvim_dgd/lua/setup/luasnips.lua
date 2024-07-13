-- if vim.g.snippets == 'luasnips' then
--   return
-- end
-- nil print(vim.g.snippets)

-- print("hello from luasnips 3")

local ls = require('luasnip')
local types = require('luasnip.util.types')
-- require("luasnip.loaders.from_vscode").lazy_load()

ls.config.set_config({
  history = true,
  updateevents = 'TextChanged,TextChangedI',
})

vim.keymap.set({ "i", "s" }, "<C-j>", function()
  if ls.expand_or_jumpable(-1) then
    ls.expand_or_jump(-1)
  end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-l>", function()
  if ls.choice_active() then
    ls.change_choice()
  end
end)

require('setup/luasnips_custom/dgd')

-- vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/lua/setup/luasnips.lua<cr>|<cmd>source ~/.config/nvim/lua/setup/luasnips_custom/dgd.lua<cr>")

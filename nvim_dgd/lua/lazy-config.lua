local appearance = os.getenv('APPEARANCE')

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  spec = {
    { import = "plugins" },
  },
})

-- Setup that still needs to be done after plugins load
require('setup/ruby')

-- Just the keymap for alternate-toggler
vim.keymap.set('n', '<space>ta', '<cmd>ToggleAlternate<cr>')


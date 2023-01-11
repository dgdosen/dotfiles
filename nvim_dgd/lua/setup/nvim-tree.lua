-- [[ Configure nvim-tree ]]
require('nvim-tree').setup{
  vim.keymap.set('n', "<C-n>", vim.cmd.NvimTreeToggle, { desc = '[N]erdish nvim-tree toggle' })
}



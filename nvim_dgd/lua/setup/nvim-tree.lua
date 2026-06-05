-- [[ Configure nvim-tree ]]
require('nvim-tree').setup {
  vim.keymap.set('n', "<C-n>", vim.cmd.NvimTreeToggle, { desc = '[N]erdish nvim-tree toggle' }),
  -- Let oil.nvim own directory buffers (oil sets default_file_explorer=true);
  -- without this both plugins fight to hijack netrw and the winner is load-order dependent.
  hijack_netrw = false,
  filters = {
    dotfiles = false,
    exclude = { '*.yml' },
  },
}

vim.keymap.set('n', '<leader>f', ':NvimTreeFindFile<CR>',
  { noremap = true, silent = true, desc = '[f]ind current file in nvim tree' })
vim.keymap.set('n', '<leader>R', ':NvimTreeRefresh<CR>', { noremap = true, silent = true, desc = '[R]efresh nvim tree' })

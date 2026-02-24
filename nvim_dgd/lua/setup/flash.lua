local flash = require('flash')

vim.keymap.set({ 'n', 'x', 'o' }, '<leader>o', function()
  flash.jump()
end, { desc = 'find via flash jump' })

vim.keymap.set('c', '<C-s>', function()
  flash.toggle()
end, { desc = 'toggle flash search' })

vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, { expr = true })
vim.keymap.set('n', '<leader>cc', '<leader>c_', { remap = true })
vim.keymap.set('x', '<leader>c', require('osc52').copy_visual)

vim.keymap.set('n', '<leader>q', ':q<CR>', { expr = true })
vim.keymap.set('n', '<leader>w', ':w<CR>', { expr = true })


-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- smash jk to escape
vim.keymap.set("i", "kj", "<esc>")
vim.keymap.set("i", "jk", "<esc>")

-- insert date or time
vim.keymap.set("i", ',d', 'strftime("%y-%m-%d")', { expr = true })
vim.keymap.set("i", ',t', 'strftime("%H:%M")', { expr = true })


-- -- rails search helpers
-- vim.keymap.set('n', '<leader>gm', ':FZF app/models<cr>', { expr = true }

-- Description: Keymaps
-- write/quit
vim.keymap.set('n', '<leader>q', ':q<CR>', { expr = true })
vim.keymap.set('n', '<leader>w', ':w<CR>', { expr = true })

-- copy/paste
vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, { expr = true })
vim.keymap.set('n', '<leader>cc', '<leader>c_', { remap = true })
vim.keymap.set('x', '<leader>c', require('osc52').copy_visual)
-- vim.keymap.set({ "n", "x" }, "<leader>p", [["0p]], { desc = "paste from yank register" })

-- scratch
-- vim.keymap,set('n', '<leader>gd', ':lua git_last_commit()<CR>')


-- TODO: trying to 'remap' rails vim commands for older (project_b) rails projects.
-- vim.keymap.set('n', '<leader>gff', require('rails').rails_gf(), { expr=true})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- smash jk to escape
vim.keymap.set("i", "kj", "<esc>")
vim.keymap.set("i", "jk", "<esc>")

-- Move text up and down
-- vim.keymap.set("v", "<C-j>", ":m .+1<CR>==")
-- vim.keymap.set("v", "<C-k>", ":m .-2<CR>==")
-- -- keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv")
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv")
vim.keymap.set("x", "<C-j>", ":move '>+1<CR>gv-gv")
vim.keymap.set("x", "<C-k>", ":move '<-2<CR>gv-gv")
-- vim.keymap.set('n', "<C-j>", "<C-w>j", { noremap = true, silent = true })
-- vim.keymap.set('n', "<C-k>", "<C-w>k", { nremap = true, silent = true })

-- "http://vimcasts.org/episodes/bubbling-text/
-- nmap <C-k> [e
-- nmap <C-j> ]e
-- Bubble multiple lines
-- vmpu <C-k> [egv
-- vmap <C-j> ]egv"

-- insert date or time
vim.api.nvim_set_keymap('i', ',d', [[<C-R>=strftime("%Y-%m-%d")<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', ',t', [[<C-R>=strftime("%H:%M")<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', ',dt', [[<C-R>=strftime("%Y-%m-%d %H:%M")<CR>]], { noremap = true, silent = true })
-- vim.keymap.set("i", ',d', 'strftime("%y-%m-%d")', { expr = true })
-- vim.keymap.set("i", ',t', 'strftime("%H:%M")', { expr = true })

-- -- rails search helpers
-- vim.keymap.set('n', '<leader>gm', ':FZF app/models<cr>', { expr = true }

-- oil
-- Open parent directory in current window
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Open parent directory in floating window
vim.keymap.set("n", "<space>-", require("oil").toggle_float, { desc = "oil file explorer" })

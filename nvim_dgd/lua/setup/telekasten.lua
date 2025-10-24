vim.keymap.set("n", "<leader>zn", function() require('telekasten').new_note() end)
vim.keymap.set("n", "<leader>zd", function() require('telekasten').goto_today() end)
vim.keymap.set("n", "<leader>zf", function() require('telekasten').find_notes() end)

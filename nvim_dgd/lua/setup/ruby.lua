vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = ".pryrc",
  command = "set filetype=ruby"
})

local function search_in_folder(folder)
  -- Replace `:Telescope find_files` with your actual search command and adjust the parameters as needed
  -- This example uses Telescope for searching, but you can use any command or function you prefer
  require('telescope.builtin').find_files({
    prompt_title = "< Search in: " .. folder .. " >",
    cwd = vim.fn.getcwd() .. '/' .. folder,
  })
end

-- Define keymaps for each search
vim.keymap.set('n', '<leader>sym', function() search_in_folder("app/models") end, { desc = '[s]earch Rub[y] [m]odels' })
vim.keymap.set('n', '<leader>syt', function() search_in_folder("spec") end, { desc = '[s]earch Rub[y] [t]pec' })
vim.keymap.set('n', '<leader>syo', function() search_in_folder("app/objects") end, { desc = '[s]earch Rub[y] [o]bjects' })
vim.keymap.set('n', '<leader>sys', function() search_in_folder("app/services") end,
  { desc = '[s]earch Rub[y] [s]ervices' })

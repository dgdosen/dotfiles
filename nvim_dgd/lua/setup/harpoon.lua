local harpoon = require("harpoon")
harpoon:setup({})

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "ha", function() harpoon:list():add() end, { desc = '[a]dd file to harpoon' })
vim.keymap.set("n", "hr", function() harpoon:list():remove() end, { desc = 'harpoon [r]]emove current file' })

-- vim.keymap.set("n", "ha", function()
--   harpoon.ui:toggle_quick_menu()
--   harpoon:list()
-- end)

-- vim.keymap.set("n", "hs", function() harpoon:list():select(1) end)
-- vim.keymap.set("n", "hd", function() harpoon:list():select(2) end)
-- vim.keymap.set("n", "hf", function() harpoon:list():select(3) end)
-- vim.keymap.set("n", "hg", function() harpoon:list():select(4) end)
vim.keymap.set("n", "h0", function() harpoon:list():select(0) end, { desc = '[h]arpoon select [0] if it is there... ' })
vim.keymap.set("n", "h1", function() harpoon:list():select(1) end, { desc = '[h]arpoon select [1]' })
vim.keymap.set("n", "h2", function() harpoon:list():select(2) end, { desc = '[h]arpoon select [2]' })
vim.keymap.set("n", "h3", function() harpoon:list():select(3) end, { desc = '[h]arpoon select [3]' })
vim.keymap.set("n", "h4", function() harpoon:list():select(4) end, { desc = '[h]arpoon select [4]' })
vim.keymap.set("n", "h5", function() harpoon:list():select(5) end, { desc = '[h]arpoon select [5]' })
vim.keymap.set("n", "h6", function() harpoon:list():select(6) end, { desc = '[h]arpoon select [6]' })
vim.keymap.set("n", "hx", function() harpoon:list():clear() end, { desc = '[h]arpoon [x] :wthem out' })

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "hp", function() harpoon:list():prev() end, { desc = 'harpoon previous' })
vim.keymap.set("n", "hn", function() harpoon:list():next() end, { desc = 'harpoon next' })

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers").new({}, {
    prompt_title = "Harpoon",
    finder = require("telescope.finders").new_table({
      results = file_paths,
    }),
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end

vim.keymap.set("n", "hh", function() toggle_telescope(harpoon:list()) end,
  { desc = "Open harpoon window" })

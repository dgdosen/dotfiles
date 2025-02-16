local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

--
vim.keymap.set("n", "Ha", function() harpoon:list():add() end, { desc = '[a]dd file to harpoon' })
vim.keymap.set("n", "Hr", function() harpoon:list():remove() end, { desc = 'harpoon [r]emove current file' })
--
vim.keymap.set("n", "H0", function() harpoon:list():select(0) end, { desc = '[H]arpoon select [0] if it is there... ' })
vim.keymap.set("n", "H1", function() harpoon:list():select(1) end, { desc = '[H]arpoon select [1]' })
vim.keymap.set("n", "H2", function() harpoon:list():select(2) end, { desc = '[H]arpoon select [2]' })
vim.keymap.set("n", "H3", function() harpoon:list():select(3) end, { desc = '[H]arpoon select [3]' })
vim.keymap.set("n", "H4", function() harpoon:list():select(4) end, { desc = '[H]arpoon select [4]' })
vim.keymap.set("n", "H5", function() harpoon:list():select(5) end, { desc = '[H]arpoon select [5]' })
vim.keymap.set("n", "H6", function() harpoon:list():select(6) end, { desc = '[H]arpoon select [6]' })
-- vim.keymap.set("n", "hx", function() harpoon:list():clear() end, { desc = '[h]arpoon [x] :wthem out' })
--
-- -- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "Hp", function() harpoon:list():prev({ ui_nav_wrap = true }) end, { desc = '[H]arpoon [p]revious' })
vim.keymap.set("n", "Hn", function() harpoon:list():next({ ui_nav_wrap = true }) end, { desc = '[H]arpoon [n]ext' })

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

-- local function cycle_harpoon_next()
--   local marks = require("harpoon.mark").get_length()
--   local current_index = require("harpoon.ui").get_menu_index()
--
--   if current_index == marks then
--     harpoon.nav_file(1)                 -- Go to the first file if at the end
--   else
--     harpoon.nav_file(current_index + 1) -- Otherwise go to the next file
--   end
-- end

vim.keymap.set("n", "Hh", function() toggle_telescope(harpoon:list()) end,
  { desc = "Open [h]arpoon window" })

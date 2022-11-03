local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Map leader to space
vim.g.mapleader = " "

-- pane/tmux navigation
-- NOTE: just done with plugin
-- TODO; still trying to figure this out...
-- vim.keymap.set("t", "<c-h>", "<c-\><c-n><c-w>h")
-- vim.keymap.set("t", "<c-j>", "<c-\><c-n><c-w>j")
-- vim.keymap.set("t", "<c-k>", "<c-\><c-n><c-w>k")
-- vim.keymap.set("t", "<c-l>", "<c-\><c-n><c-w>l")

-- -- Switch Session
-- map("n", "<Leader>1", ":SearchSession<CR>")

-- Update Plugins
map("n", "<Leader>u", ":PackerSync<CR>")

-- Quick new file
map("n", "<Leader>n", "<cmd>enew<CR>")

-- Easy select all of file
map("n", "<Leader>sa", "ggVG<c-$>")

-- Make visual yanks place the cursor back where started
map("v", "y", "ygv<Esc>")

-- Easier file save
map("n", "<Leader>w", "<cmd>:w<CR>")

-- Open Lazygit
map("n", "<leader>l", ":LazyGit<cr>", { silent = true })
map("n", "<Delete>", "<cmd>:w<CR>")

map("n", "<c-n>", ":NvimTreeToggle<CR>")


-- Telescope
local km = vim.keymap

-- Add moves of more than 5 to the jump list
km.set("n", "j", [[(v:count > 5 ? "m'" . v:count : "") . 'j']], { expr = true, desc = "if j > 5 then add to jumplist" })
km.set("n", "<leader>p", function()
  require("telescope.builtin").find_files()
end)
km.set("n", "<leader>r", function()
  require("telescope.builtin").registers()
end)
km.set("n", "<leader>m", function()
  Require("telescope.builtin").marks()
end)
km.set("n", "<leader>g", function()
  require("telescope.builtin").live_grep()
end)
km.set("n", "<leader>b", function()
  require("telescope.builtin").buffers()
end)
km.set("n", "<leader>j", function()
  require("telescope.builtin").help_tags()
end)
km.set("n", "<leader>y", function()
  require("telescope.builtin").git_bcommits()
end)
km.set("n", "<leader>f", function()
  require("telescope").extensions.file_browser.file_browser()
end)
km.set("n", "<leader>s", function()
  require("telescope.builtin").spell_suggest(require("telescope.themes").get_cursor({}))
end)
km.set("n", "<leader>i", function()
  require("telescope.builtin").git_status()
end)
km.set("n", "<leader>ca", function()
  vim.lsp.buf.code_action()
end)
km.set("n", "<leader>cs", function()
  require("telescope.builtin").lsp_document_symbols()
end)
km.set("n", "<leader>cd", function()
  require("telescope.builtin").diagnostics({ bufnr = 0 })
end)
km.set("n", "<leader>cr", function()
  require("telescope.builtin").lsp_references()
end)
km.set({ "v", "n" }, "<leader>cn", function()
  vim.lsp.buf.rename()
end, { noremap = true, silent = true })
km.set("n", "<leader>ci", function()
  vim.diagnostic.open_float()
end)

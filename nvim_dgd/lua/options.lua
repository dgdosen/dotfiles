-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = true
-- ? not working on linux
vim.keymap.set('n', '<CR>', vim.cmd.noh, { silent = true })

-- Make line numbers default
vim.wo.number = true
-- relative line numbers
vim.o.relativenumber = true

-- ? not working on linux
vim.o.cursorline = true

-- clipboard
vim.o.clipboard = 'unnamedplus'

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.autoindent = true

-- save file on leaving insert mode
vim.cmd("autocmd InsertLeave * silent! write")

vim.cmd("let g:gruvbox_transparent_bg = 1")
vim.cmd("autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE")

-- trim trailing whitespace on save
vim.api.nvim_command("autocmd BufWritePre * :%s/\\s\\+$//e")

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
-- ? not working on linux
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
-- ? not working on linux
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.claude",
  callback = function()
    vim.bo.filetype = "markdown"
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "swift",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = function()
    vim.opt_local.indentkeys:remove(".")
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.textwidth = 80            -- Hard wrap at 80 characters
    vim.opt_local.colorcolumn = "80"        -- Show a visual column at 80
    vim.opt_local.formatoptions:append("t") -- Auto-wrap text
    vim.opt_local.wrap = true               -- Enable soft wrapping
    vim.opt_local.linebreak = true          -- Wrap at word boundaries
  end
})

vim.filetype.add({
  extension = {
    claude = 'markdown',
  }
})

function show_popup()
  -- Create a new buffer with some text
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, { 'Hello, world!', 'This is a popup window.' })

  -- Calculate the size and position of the popup window
  local win_width = math.floor(vim.api.nvim_win_get_width(0) * 0.8)
  local win_height = math.floor(vim.api.nvim_win_get_height(0) * 0.8)
  local win_row = math.floor((vim.api.nvim_win_get_height(0) - win_height) / 2)
  local win_col = math.floor((vim.api.nvim_win_get_width(0) - win_width) / 2)

  -- Create a new popup window with the buffer content
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'cursor',
    row = win_row,
    col = win_col,
    width = win_width,
    height = win_height,
    style = 'minimal',
  })
  -- Define a new highlight group with a lighter shade
  vim.api.nvim_command('hi MyPopupHighlight guibg=#4F4945')
  -- 4F4945
  -- 63, 56, 53

  -- Set the popup window options
  vim.api.nvim_win_set_option(win, 'winhl', 'Normal:MyPopupHighlight')
  vim.api.nvim_win_set_option(win, 'cursorline', false)
end

vim.api.nvim_set_keymap('n', '<leader>g', ':lua show_popup()<CR>', { noremap = true, silent = true })

-- chatgpt/shellbot
vim.cmd("command! ChatGPT lua require'chatgpt'.chatgpt()")

-- keep folds open by default
vim.opt.foldenable = false

-- diagnostics
vim.diagnostic.config({
  virtual_text = true, -- Enable inline diagnostics
})

-- More control over virtual text:
vim.diagnostic.config({
  virtual_text = {
    spacing = 8, -- Space between code and diagnostic
    prefix = '■', -- Custom prefix character
    severity_limit = vim.diagnostic.severity.WARN, -- Only show warnings and errors
  }
})

-- gruvbox light/dark
vim.o.termguicolors = true
vim.o.background = 'dark' -- or light
-- vim.o.background = 'light'

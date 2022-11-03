print('hello from lua')
-- You will need to install language servers `npm i -g vscode-langservers-extracted` and `npm install -g typescript typescript-language-server`
--

require("plugins")
-- require("options")
-- require("setup.spelling")
require("mappings")

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

-- vim.bo.columcolor = '80'
vim.opt.modelines = 5 -- scan this many lines looking for modeline
vim.opt.number = true -- show line numbers in gutter
vim.opt.pumblend = 10 -- pseudo-transparency for popup-menu
vim.opt.relativenumber = true -- show relative numbers in gutter
vim.opt.scrolloff = 3 -- start scrolling 3 lines before edge of viewport

vim.opt.backup = false -- don't make backups before writing
vim.opt.backupcopy = 'yes' -- overwrite files to update, instead of renaming + rewriting
vim.opt.tabstop = 2 -- spaces per tab
vim.opt.termguicolors = true -- use guifg/guibg instead of ctermfg/ctermbg in terminal
vim.opt.textwidth = 80 -- automatically hard wrap at 80 columns

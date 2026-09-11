-- nvim-treesitter `main` branch. Unlike the old `master` API there is no
-- `highlight = { enable = true }` option: highlighting is turned on per buffer
-- with vim.treesitter.start(), and parsers are installed explicitly.
local ts = require('nvim-treesitter')

ts.setup({})

-- Parsers to keep installed. Neovim itself bundles c, lua, vim, vimdoc,
-- query and markdown. Installing needs the `tree-sitter` CLI and a C compiler.
local parsers = { 'swift', 'typescript', 'tsx', 'javascript', 'ruby', 'xml', 'json', 'yaml', 'bash', 'markdown_inline' }

local installed = {}
for _, name in ipairs(ts.get_installed()) do installed[name] = true end
local missing = vim.tbl_filter(function(name) return not installed[name] end, parsers)
if #missing > 0 then ts.install(missing) end

-- Enable treesitter highlighting and indentation wherever a parser exists;
-- buffers without one silently fall back to regex syntax.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter_start', { clear = true }),
  callback = function(ev)
    local ok = pcall(vim.treesitter.start, ev.buf)
    if ok then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

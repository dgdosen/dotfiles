vim.g.vim_markdown_borderless_table = 0
vim.g.vim_markdown_toml_frontmatter = 1
-- Let treesitter (autocmd below) own folding; vim-markdown's Foldexpr_markdown
-- otherwise overrides it in its ftplugin and yields no folds here.
vim.g.vim_markdown_folding_disabled = 1

vim.api.nvim_create_autocmd('FileType', {
  -- telekasten re-tags notes under its home as ft=telekasten after markdown
  pattern = { 'markdown', 'telekasten' },
  callback = function()
    vim.opt_local.foldmethod = 'expr'
    vim.opt_local.foldexpr   = 'v:lua.vim.treesitter.foldexpr()'
    vim.opt_local.foldenable = true
    vim.opt_local.foldlevel  = 99
  end,
})

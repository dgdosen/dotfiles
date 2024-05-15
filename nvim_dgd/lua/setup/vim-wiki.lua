vim.g.vimwiki_list = {
  {
    path = '/Users/dgdosen/dev/zettel_dialing_in_lean/',
    syntax = 'markdown',
    ext = '.md',
    auto_tags = 1,
    auto_toc = 1
  },
  {
    path = '/Users/dgdosen/dev/zettel/',
    syntax = 'markdown',
    ext = '.md',
    auto_tags = 1,
    auto_toc = 1
  }
}
vim.g.zettel_format = "%Y-%m-%d:%H:%M-%title"
vim.g.zettel_options = { { front_matter = { tags = '' } } }
vim.api.nvim_echo({ { '-setup/vim-wiki.lua loaded', "None" } }, false, {})

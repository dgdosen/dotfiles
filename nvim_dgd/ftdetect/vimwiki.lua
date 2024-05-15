-- vimwiki configuration
vim.g.vimwiki_list = {
  {
    path = '/Users/dgdosen/dev/zettel/',
    syntax = 'markdown',
    ext = '.md',
    auto_tags = 1,
    auto_toc = 1
  },
  {
    path = '/Users/dgdosen/dev/zettel_dialing_in_lean/',
    syntax = 'markdown',
    ext = '.md',
    auto_tags = 1,
    auto_toc = 1
  }
}

-- Additional vimwiki configurations if needed
vim.g.vimwiki_ext2syntax = { ['.md'] = 'markdown' }
vim.api.nvim_echo({ { '-ftdetect/vimwiki.lua loaded', "None" } }, false, {})

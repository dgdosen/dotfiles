-- vim wiki/ :help vim-wiki
-- NOTE: <leader> ws -- selects wiki (if multiple)

vim.g.vimwiki_list = { { path = '/Users/dgdosen/dev/zettel/', syntax = 'markdown', ext = '.md', auto_tags = 1,
  auto_toc = 1 },
  { path = '/Users/dgdosen/dev/zettel_dialing_in_lean/', syntax = 'markdown', ext = '.md', auto_tags = 1, auto_toc = 1 } }
-- vim.g.vimwiki_list = {{path = '/Users/dgdosen/dev/zettel/', syntax = 'markdown', ext = '.md', auto_tags = 1, auto_toc = 1}}

-- let g:vimwiki_list = [{'path': '~/dev/zettel/', 'syntax': 'markdown', 'ext': '.md', 'auto_tags': 1, 'auto_toc': 1}, {'path': '~/dev/zettel_dialing_in_lean/', 'syntax': 'markdown', 'ext': '.md', 'auto_tags': 1, 'auto_toc': 1}]

-- vim.g.zettel_options = {{ front_matter = { tags = '' }}}
-- let g:zettel_options = [{'front_matter': {'tags': ''}}]

vim.g.zettel_format = "%Y-%m-%d:%H:%M-%title"
-- let g:zettel_format= "%Y-%m-%d:%H:%M-%title"

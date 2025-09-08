return {
  -- VimWiki for note taking
  {
    'vimwiki/vimwiki',
    config = function()
      -- VimWiki configuration consolidated from ftdetect and setup files
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
      
      -- Additional VimWiki configurations
      vim.g.vimwiki_ext2syntax = { ['.md'] = 'markdown' }
      vim.g.zettel_format = "%Y-%m-%d:%H:%M-%title"
      vim.g.zettel_options = { { front_matter = { tags = '' } } }
    end,
  },

  -- Zettelkasten / Notes with Telekasten
  {
    'renerocksai/telekasten.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' }, -- or 'ibhagwan/fzf-lua'
    config = function()
      require('telekasten').setup({
        home = vim.fn.expand("~/dev/zettel"), -- or wherever your notes live
        take_over_my_home = true,
        dailies = "daily",
        weeklies = "weekly",
        templates = vim.fn.expand("~/.config/nvim/templates"),
        extension = ".md",
        template_new_note = "new_note.md",
      })
      require('setup/telekasten')
    end
  },

  -- text/markdown
  {
    'preservim/vim-markdown',
    dependencies = {
      'godlygeek/tabular'
    },
    config = function()
      require('setup/vim-markdown')
    end,
  },

  -- environment variables
  'tpope/vim-dotenv',
}
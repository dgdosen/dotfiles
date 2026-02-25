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
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      local home = vim.fn.expand("~/dev/zettel")
      require('telekasten').setup({
        home = home,
        take_over_my_home = true,
        dailies = home .. "/daily",
        weeklies = home .. "/weekly",
        templates = home .. "/templates",
        extension = ".md",
        template_new_note = home .. "/templates/new_note.md",

        -- UUID prefix with timestamp
        new_note_filename = "uuid-title",
        uuid_type = "%Y-%m-%d:%H:%M", -- This creates the timestamp
        uuid_sep = "-",               -- Separator between timestamp and title
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>zn", function() require('telekasten').new_note() end)
      vim.keymap.set("n", "<leader>zd", function() require('telekasten').goto_today() end)
      vim.keymap.set("n", "<leader>zf", function() require('telekasten').find_notes() end)
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

  -- Markdown preview in browser (with Mermaid support)
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = 'cd app && npx --yes yarn install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
      vim.g.mkdp_theme = 'automatic'
    end,
  },

  -- environment variables
  'tpope/vim-dotenv',
}

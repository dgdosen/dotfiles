return {
  -- VimWiki for note taking
  {
    'vimwiki/vimwiki',
    init = function()
      -- VimWiki globals MUST be set before the plugin loads, so use init (not config).
      vim.g.vimwiki_list = {
        {
          path = '/Users/dgdosen/dev/handicapping_wiki/',
          syntax = 'markdown',
          ext = '.md',
          auto_tags = 1,
          auto_toc = 1
        },
        {
          path = '/Users/dgdosen/dev/electricity_wiki/',
          syntax = 'markdown',
          ext = '.md',
          auto_tags = 1,
          auto_toc = 1
        }
      }

      -- Remap the <leader>w… prefix (which collides with save) to <leader>v…
      vim.g.vimwiki_map_prefix = '<Leader>v'

      -- Additional VimWiki configurations
      vim.g.vimwiki_ext2syntax = { ['.md'] = 'markdown' }
      -- Only treat .md files INSIDE the wiki paths above as vimwiki; every other
      -- .md stays filetype=markdown so vim-markdown/treesitter folding applies.
      vim.g.vimwiki_global_ext = 0
      -- Fold by header inside the wikis (vimwiki uses its own foldexpr)
      vim.g.vimwiki_folding = 'expr'
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
        template_new_daily = home .. "/templates/daily.md",

        -- UUID prefix with timestamp
        new_note_filename = "uuid-title",
        uuid_type = "%Y-%m-%d:%H:%M", -- This creates the timestamp
        uuid_sep = "-",               -- Separator between timestamp and title
      })

      -- Keymaps: <leader>n ([n]otes). <leader>z is taken by ZenMode/Twilight in which-key.
      local tk = function(fn) return function() require('telekasten')[fn]() end end
      vim.keymap.set("n", "<leader>nn", tk('new_note'),       { desc = "[n]ew note" })
      vim.keymap.set("n", "<leader>nd", tk('goto_today'),     { desc = "to[d]ay's daily note" })
      vim.keymap.set("n", "<leader>nf", tk('find_notes'),     { desc = "[f]ind notes by title" })
      vim.keymap.set("n", "<leader>ng", tk('search_notes'),   { desc = "[g]rep note contents" })
      vim.keymap.set("n", "<leader>nl", tk('insert_link'),    { desc = "insert [l]ink" })
      vim.keymap.set("n", "<leader>nb", tk('show_backlinks'), { desc = "show [b]acklinks" })
      vim.keymap.set("n", "<leader>nt", tk('show_tags'),      { desc = "show [t]ags" })
      vim.keymap.set("n", "<leader>np", tk('panel'),          { desc = "command [p]anel" })

      -- Zettelbox: draft in ~/dev/zettelbox, flush to Bear.app, delete local file.
      local zbox = require("setup/zettelbox")
      vim.keymap.set("n", "<leader>nz", zbox.new_draft,   { desc = "new [z]ettelbox draft" })
      vim.keymap.set("n", "<leader>nB", zbox.send_to_bear,{ desc = "send zettelbox → [B]ear" })
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

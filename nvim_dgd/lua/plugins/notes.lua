return {
  -- Zettelkasten / Notes
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

  -- vimwiki setup
  'tpope/vim-dotenv',
}
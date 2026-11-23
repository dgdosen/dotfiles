return {
  -- text plugs
  'rmagatti/alternate-toggler',
  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({
        disable_filetype = { 'TelescopePrompt', 'vim' }
      })
    end,
  },

  -- commenting: using Neovim 0.12+ built-in gc/gcc

  -- surround
  {
    'kylechui/nvim-surround',
    config = function()
      require('nvim-surround').setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },

  -- todo comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
    config = function()
      require('setup/todo-comments')
    end,
  },

  -- trouble (diagnostics)
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },

  -- clipboard
  {
    "AckslD/nvim-neoclip.lua",
    dependencies = {
      -- you'll need at least one of these
      { 'nvim-telescope/telescope.nvim' },
      -- {'ibhagwan/fzf-lua'},
    },
    config = function()
      require('neoclip').setup()
    end,
  },

  -- text management
  {
    'alexghergh/nvim-tmux-navigation',
    config = function()
      local nvim_tmux_nav = require('nvim-tmux-navigation')

      nvim_tmux_nav.setup {
        disable_when_zoomed = true -- defaults to false
      }
      -- <C-h/j/k/l>: inside tmux use tmux-navigation; otherwise rex-navigator
      -- (below) owns them, so they cross into Rex panes at the edge.
      if vim.env.TMUX then
        vim.keymap.set('n', "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
        vim.keymap.set('n', "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
        vim.keymap.set('n', "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
        vim.keymap.set('n', "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
      end
      vim.keymap.set('n', "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
      vim.keymap.set('n', "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
    end
  },

  -- Rex counterpart of the above: <C-h/j/k/l> moves between Neovim splits and
  -- hands off to the next Rex pane at the edge (via `rex do`). Rex half is
  -- loaded in .config/rex/init.lua. Not lazy-loaded: the maps must exist when
  -- the first ctrl+h/j/k/l arrives from Rex. Outside Rex it's plain wincmd.
  {
    'wassimk/rex-navigator.nvim',
    version = '*',
    lazy = false,
    cond = function() return vim.env.TMUX == nil end,
    opts = {},
  },
}
return {
  -- Highlight, edit, and navigate code
  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    config = function()
      require('setup/treesitter')
    end,
    -- dependencies = {
    --   'nvim-treesitter/nvim-treesitter-textobjects',
    -- }
  },

  'nvim-treesitter/playground',

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function()
      require('setup/telescope')
    end,
  },

  -- Fuzzy Finder Algorithm which dependencies local dependencies to be built. Only load if `make` is available
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable 'make' == 1 },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require('setup/harpoon')
    end,
  },

  -- InPane navigation
  {
    'smoka7/hop.nvim',
    version = "*",
    opts = {},
    config = function()
      require('setup/hop')
    end,
  },

  {
    'chaoren/vim-wordmotion',
    init = function()
      -- Optional: change the default prefix for toggling wordmotion
      -- Default prefix is <leader>, so <leader>w toggles wordmotion mode.
      -- You can set something else, or just always leave it enabled.
      -- Example to set it to comma (`,`):
      -- vim.g.wordmotion_prefix = ','

      -- Optional: always start in wordmotion mode
      vim.g.wordmotion_motions = {
        w = 1,
        e = 1,
        b = 1,
        ge = 1
      }
      vim.g.wordmotion_text_objects = {
        iw = 1,
        aw = 1,
        iW = 1,
        aW = 1
      }
    end
  },

  -- Scrolling
  {
    'karb94/neoscroll.nvim',
    config = function()
      require('setup/neoscroll')
    end,
  },

  -- Which key
  {
    'folke/which-key.nvim',
    event = "BufWinEnter",
    config = function()
      require('setup/which-key')
    end,
  },

  -- symbols outline
  'simrat39/symbols-outline.nvim',

  -- buffer explorer
  'jlanzarotta/bufexplorer',

  -- Align tables
  'junegunn/vim-easy-align',
}

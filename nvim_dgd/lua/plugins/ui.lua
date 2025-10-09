return {
  -- File managers
  {
    'nvim-tree/nvim-tree.lua',
    -- dependencies = { "echasnovski/mini.icons" },
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    config = function()
      require('setup/nvim-tree')
    end,
    -- tag = 'nightly' -- optional, updated every week. (see issue #1193)
  },

  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    -- dependencies = { "echasnovski/mini.icons" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('setup/oil')
    end,
  },

  -- colors
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end
  },
  -- 'brenoprata10/nvim-highlight-colors',

  -- colorschemes
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        transparent_mode = true,
        constrast = "high",
      })
    end
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "auto", -- will be set dynamically
        integrations = {
          treesitter = true,
          telescope = true,
          lsp_saga = true,
          lsp_trouble = true,
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          which_key = true,
        }
      })
    end
  },

  -- { 'shaunsingh/nord.nvim' },
  -- { 'folke/tokyonight.nvim' },

  -- statusline
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('setup/lualine')
    end,
  },

  -- indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('setup/indent_blankline')
    end,
  },

  -- zen mode
  {
    'folke/zen-mode.nvim',
    config = function()
      require('setup/zen-mode')
    end,
  },

  {
    "folke/twilight.nvim",
    config = function()
      require("setup/twilight")
    end
  },
}

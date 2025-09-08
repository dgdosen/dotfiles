return {
  -- LSP Configuration & Plugins
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      "mason-org/mason.nvim",
      -- 'RubixDev/mason-update-all',
      -- 'WhoIsSethDaniel/mason-tool-installer.nvim',
      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },
      -- 'j-hui/fidget.nvim',
      'jose-elias-alvarez/typescript.nvim',
      'b0o/schemastore.nvim',
      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
    checker = { enabled = true },
    config = function()
      require('setup/lsp')
      require('setup/neodev')
    end,
  },

  -- Useful status updates for LSP
  {
    'j-hui/fidget.nvim',
    frequency = 3600,
    notify = true,
  },

  {
    "mason-org/mason.nvim",
    config = function()
      require('setup/mason')
    end,
  },
  "mason-org/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",

  -- formatting
  { -- Autoformat
    'stevearc/conform.nvim',
    opts = {
      notify_on_error = false,
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        -- javascript = { { "prettierd", "prettier" } },
      },
    },
  },

  -- svelte (no lsp?)
  'evanleck/vim-svelte',

  -- elixir
  { 'elixir-editors/vim-elixir' },

  -- rails
  'tpope/vim-rails',
}
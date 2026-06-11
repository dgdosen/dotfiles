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
      'b0o/schemastore.nvim',
      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
    checker = { enabled = true },
    config = function()
      require('setup/neodev')
      require('setup/lsp')

      -- Configure sourcekit LSP for Swift
      vim.lsp.config('sourcekit', {
        cmd = { 'sourcekit-lsp' },
        filetypes = { 'swift', 'objective-c', 'objective-cpp' },
        root_dir = function(filename, bufnr)
          return vim.fs.root(bufnr, { 'Package.swift', '.git' })
        end,
      })
      vim.lsp.enable("sourcekit")
    end,
  },

  -- TypeScript/JavaScript LSP. Native tsserver client; replaces the
  -- archived jose-elias-alvarez/typescript.nvim. Provides :TSTools* commands
  -- (see <leader>t* maps in setup/which-key.lua). Shares the standard LSP
  -- on_attach so TS buffers get the same gd/gr/K/rename/code-action maps.
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig', 'hrsh7th/cmp-nvim-lsp' },
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    opts = function()
      return {
        on_attach = require('setup.lsp_on_attach'),
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      }
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

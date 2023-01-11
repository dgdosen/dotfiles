vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

local fn = vim.fn
local is_bootstrap = false
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  is_bootstrap = true
  fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end

vim.api.nvim_command("packadd packer.nvim")
-- returns the require for use in `config` parameter of packer's use
-- expects the name of the config file
function get_setup(name)
  return string.format('require("setup/%s")', name)
end

-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installednv'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

return require("packer").startup({
  function(use)
    use({
      "windwp/nvim-autopairs",
      after = "nvim-cmp",
      config = get_setup("autopairs"),
    })
    use({
      "hrsh7th/nvim-cmp",
      requires = {
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lua" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-cmdline" },
        { "L3MON4D3/LuaSnip" },
        { "saadparwaiz1/cmp_luasnip" },
        { "hrsh7th/cmp-calc" },
				{ "quangnguyen30192/cmp-nvim-tags",
				  ft = {
				    'ruby',
				   }
				},
        { "rafamadriz/friendly-snippets" },
      },
      config = function ()
        require'cmp'.setup {
        sources = {
          { name = 'tags' },
          -- more sources
          }
        }
      end,
      config = get_setup("cmp")
    })
    use({
      "lewis6991/gitsigns.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      event = "BufReadPre",
      config = get_setup("gitsigns"),
    })
    use({ "wbthomason/packer.nvim",
      config = get_setup("lsp"),
    })
    use({ "kdheepak/lazygit.nvim" })
		use({ "ojroques/nvim-osc52",
      config = get_setup("osc52"),
		})
    use({
      "nvim-treesitter/nvim-treesitter",
      config = get_setup("treesitter"),
      run = ":TSUpdate",
    })
    use({ "neovim/nvim-lspconfig",
      config = get_setup("lsp") })
    use({ "williamboman/mason.nvim",
      config = get_setup("lsp.mason") })
      -- use({ "williamboman/mason-lspconfig.nvim", config = get_setup("lsp.mason-lspconfig") }) -- simple to use language server installer
    use({ "nvim-treesitter/nvim-treesitter-textobjects" })
    use({
      "nvim-telescope/telescope.nvim",
      module = "telescope",
      cmd = "Telescope",
      requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      },
      config = get_setup("telescope"),
    })
    -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

    use({ "nvim-telescope/telescope-file-browser.nvim" })
    -- NOTE: why would I use sessions?
    -- use({
    --   "rmagatti/session-lens",
    --   requires = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" },
    -- --  config = get_setup("session"),
    -- })
    use({
      "ellisonleao/gruvbox.nvim",
      config = get_setup("gruvbox"),
    })
    use({ "famiu/bufdelete.nvim" })
    use({
      "kylechui/nvim-surround",
      config = function()
        require("nvim-surround").setup({})
      end,
    })
    use {
      'nvim-tree/nvim-tree.lua',
      requires = {
        'nvim-tree/nvim-web-devicons', -- optional, for file icons
      },
      config = get_setup("nvim-tree"),
      tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }
    use {
      "folke/todo-comments.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("todo-comments").setup({signs = false})
      end,
    }
    use({
      "aserowy/tmux.nvim",
      config = get_setup("tmux"),
    })
    use { -- tmux navigation
      'alexghergh/nvim-tmux-navigation',
      config = function()
        local nvim_tmux_nav = require('nvim-tmux-navigation')

        nvim_tmux_nav.setup {
          disable_when_zoomed = true -- defaults to false
        }
        vim.keymap.set('n', "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
        vim.keymap.set('n', "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
        vim.keymap.set('n', "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
        vim.keymap.set('n', "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
        vim.keymap.set('n', "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
        vim.keymap.set('n', "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
      end,
    }
    use({
      "github/copilot.vim",
      config = get_setup("copilot"),
    })
    -- use ({
    --   "zbirenbaum/copilot.lua",
    --   event = "VimEnter",
    --   config = function()
    --     vim.defer_fn(function()
    --       require("copilot").setup()
    --     end, 100)
    --   end,
    -- })
    use({
      "folke/zen-mode.nvim",
      config = get_setup("zen-mode"),
    })
    use({ "tpope/vim-dadbod" })
    use({
      "kristijanhusak/vim-dadbod-ui",
      requires = {
        { "tpope/vim-dadbod" },
        { "tpope/vim-dotenv" },
      },
      config = get_setup("vim-dadbod-ui"),
    })
    use({
      "tpope/vim-rails",
      config = get_setup("vim-rails"),
    })
  end,
})

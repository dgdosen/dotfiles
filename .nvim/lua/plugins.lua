print('hello from plugins')
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
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
        { "rafamadriz/friendly-snippets" },
      },
      config = get_setup("cmp"),
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
    use({
      "nvim-treesitter/nvim-treesitter",
      config = get_setup("treesitter"),
      run = ":TSUpdate",
    })
    use({ "neovim/nvim-lspconfig", config = get_setup("lsp") })
    use({ "williamboman/mason.nvim", config = get_setup("lsp.mason") })
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
    use({ "nvim-telescope/telescope-file-browser.nvim" })
    use({
      "rmagatti/session-lens",
      requires = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" },
    --  config = get_setup("session"),
    })
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

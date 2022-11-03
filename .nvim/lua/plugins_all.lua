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
    -- Packer can manage itself
    use({ "wbthomason/packer.nvim" })
    use({ "kdheepak/lazygit.nvim" })
    -- use({ "EdenEast/nightfox.nvim", config = get_setup("nightfox") })
    use({ "kyazdani42/nvim-web-devicons" })
    use({ "stevearc/dressing.nvim" })
    use({ "lukas-reineke/indent-blankline.nvim", config = get_setup("indent-blankline") })
    use({ "catppuccin/nvim", as = "catppuccin", config = get_setup("catppuccin"), before = "lualine.nvim" })
    use({
      "nvim-lualine/lualine.nvim",
      config = get_setup("lualine"),
      event = "VimEnter",
      requires = { "kyazdani42/nvim-web-devicons", opt = true },
    })
    use({
      "gen740/SmoothCursor.nvim",
      config = get_setup("smoothcursor"),
    })
    use({
      "folke/zen-mode.nvim",
      config = get_setup("zen-mode"),
    })
    use({ "brenoprata10/nvim-highlight-colors", config = get_setup("highlight-colors") })
    use({
      "nvim-treesitter/nvim-treesitter",
      config = get_setup("treesitter"),
      run = ":TSUpdate",
    })
    use({ "nvim-treesitter/nvim-treesitter-textobjects" })
    use({ "rcarriga/nvim-notify" })
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
        -- { "hrsh7th/vim-vsnip" },
        -- { "hrsh7th/cmp-vsnip" },
        -- { "hrsh7th/vim-vsnip-integ" },
        { "L3MON4D3/LuaSnip" },
        { "saadparwaiz1/cmp_luasnip" },
        { "hrsh7th/cmp-calc" },
        { "rafamadriz/friendly-snippets" },
      },
      config = get_setup("cmp"),
    })
    use({
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup()
      end,
    })
    use({
      "rlane/pounce.nvim",
      config = get_setup("pounce"),
    })
    use({
      "lewis6991/gitsigns.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      event = "BufReadPre",
      config = get_setup("gitsigns"),
    })
    use({ "jose-elias-alvarez/null-ls.nvim", config = get_setup("null-ls") })
    use({ "neovim/nvim-lspconfig", config = get_setup("lsp") })
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
    use({ "famiu/bufdelete.nvim" })
    use({
      "kylechui/nvim-surround",
      config = function()
        require("nvim-surround").setup({})
      end,
    })
    use({ "wellle/targets.vim" })
    -- use({
    --   "rmagatti/session-lens",
    --   requires = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" },
    --   config = get_setup("session"),
    -- })
    use({ "windwp/nvim-ts-autotag" })
    use({
      "winston0410/range-highlight.nvim",
      requires = { { "winston0410/cmd-parser.nvim" } },
      config = get_setup("range-highlight"),
    })
    use({ "goolord/alpha-nvim", config = get_setup("alpha") })

    if packer_bootstrap then
      require("packer").sync()
    end
  end,
  config = {
    display = {
      open_fn = require("packer.util").float,
    },
    profile = {
      enable = true,
      threshold = 1, -- the amount in ms that a plugins load time must be over for it to be included in the profile
    },
  },
})

-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	is_bootstrap = true
	vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
	vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
	-- Package manager
	use 'wbthomason/packer.nvim'

	use { -- LSP Configuration & Plugins
		'neovim/nvim-lspconfig',
		requires = {
			-- Automatically install LSPs to stdpath for neovim
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			'jose-elias-alvarez/null-ls.nvim',

			-- Useful status updates for LSP
			'j-hui/fidget.nvim',
			'b0o/schemastore.nvim',

			-- Additional lua configuration, makes nvim stuff amazing
			'folke/neodev.nvim',
		},
	}

	-- Scrolling
	use 'karb94/neoscroll.nvim'

	-- InPane navigation
	use {
		'phaazon/hop.nvim',
		branch = 'v2', -- optional but strongly recommended
	}

	-- Text Copy/Paste with Tmux
	use { 'ojroques/nvim-osc52' }

	-- Autocompletion
	use {
		'hrsh7th/nvim-cmp',
		requires = {
			'hrsh7th/cmp-nvim-lsp',
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
			'rafamadriz/friendly-snippets',
			'quangnguyen30192/cmp-nvim-tags',

			-- -- if you want the sources is available for some file types
			-- ft = {
			--   'ruby',
			--   'yamlls'
			-- }
		},
	}

	-- Highlight, edit, and navigate code
	use {
		'nvim-treesitter/nvim-treesitter',
		run = function()
			pcall(require('nvim-treesitter.install').update { with_sync = true })
		end,
	}
	use 'wfxr/minimap.vim'

	-- formatting
	-- use 'lukas-reineke/lsp-format.nvim'
	use { 'jose-elias-alvarez/null-ls.nvim',
		config = function()
			require('setup/null-ls')
		end,
		requires = { "nvim-lua/plenary.nvim" }
	}

	use {
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons', -- optional, for file icons
		},
		-- tag = 'nightly' -- optional, updated every week. (see issue #1193)
	}

	use { -- Additional text objects via treesitter
		'nvim-treesitter/nvim-treesitter-textobjects',
		after = 'nvim-treesitter',
	}

	use { 'kristijanhusak/vim-dadbod-ui',
		requires = {
			'tpope/vim-dadbod',
			'tpope/vim-dotenv',
		}
	}

	use { 'folke/which-key.nvim', event = "BufWinEnter", config = "require('setup/which-key')" }

	-- Vim-Zettel for Zettel?
	use { 'michal-h21/vim-zettel',
		requires = {
			'vimwiki/vimwiki',
			'junegunn/fzf',
			'junegunn/fzf.vim',
		}
	}

	-- Telekasten for Zettel?
	-- use { 'renerocksai/telekasten.nvim',
	--   requires = {
	--     'nvim-telescope/telescope.nvim'
	--   }
	-- }
	--

	-- -- true zen
	-- use({
	--   'Pocco81/true-zen.nvim',
	--  config = function()
	--   require('true-zen').setup {
	-- 	-- your config goes here
	-- 	-- or just leave it empty :)
	--   }
	--  end,
	-- })

	-- zen-mode is much better!
	use {
		'folke/zen-mode.nvim',
		config = function()
			require('setup/zen-mode')
		end,
	}

	use {
		"folke/twilight.nvim",
		config = function()
			require("setup/twilight")
		end
	}

	use {
		"AckslD/nvim-neoclip.lua",
		requires = {
			-- you'll need at least one of these
			{ 'nvim-telescope/telescope.nvim' },
			-- {'ibhagwan/fzf-lua'},
		},
		config = function()
			require('neoclip').setup()
		end,
	}

	-- Git related plugins
	use 'tpope/vim-fugitive'
	use 'tpope/vim-rhubarb'
	use 'lewis6991/gitsigns.nvim'

	use 'ellisonleao/gruvbox.nvim'
	use 'nvim-lualine/lualine.nvim' -- Fancier statusline
	use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
	use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
	use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically
	use 'tpope/vim-dotenv' -- Detect tabstop and shiftwidth automatically
	use 'simrat39/symbols-outline.nvim' -- Provides symbols view
	use 'jlanzarotta/bufexplorer' -- Buffer Explorer 
	use({
		'kylechui/nvim-surround',
		tag = "*", -- Use for stability;
		config = function()
			require('nvim-surround').setup({
				-- Configuration here, or leave empty to use defaults
			})
		end
	})

	use 'junegunn/vim-easy-align' -- Align tables

	-- Fuzzy Finder (files, lsp, etc)
	use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

	-- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
	use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

	-- copilot
	use 'github/copilot.vim'

	-- rails
	use 'tpope/vim-rails'

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

	-- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
	local has_plugins, plugins = pcall(require, 'custom.plugins')
	if has_plugins then
		plugins(use)
	end

	if is_bootstrap then
		require('packer').sync()
	end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
	print '=================================='
	print '    Plugins are being installednv'
	print '    Wait until Packer completes,'
	print '       then restart nvim'
	print '=================================='
	return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
	command = 'source <afile> | PackerCompile',
	group = packer_group,
	pattern = vim.fn.expand '$MYVIMRC',
})

require('setup/lsp')
require('setup/bufexplorer')
require('setup/cmp')
require('setup/comment')
require('setup/copilot')
require('setup/gitsigns')
require('setup/hop')
require('setup/indent_blankline')
require('setup/lualine')
-- require('setup/neoclip')
require('setup/neodev')
require('setup/neoscroll')
require('setup/nvim-tree')
require('setup/telescope')
require('setup/treesitter')
require('setup/osc52')
require('setup/vim-dadbod-ui')
-- require('setup/telekasten')
require('setup/vim-wiki')

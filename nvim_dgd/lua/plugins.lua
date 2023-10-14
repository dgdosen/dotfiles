local appearance = os.getenv('APPEARANCE')

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	{ -- LSP Configuration & Plugins
		'neovim/nvim-lspconfig',
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
      'RubixDev/mason-update-all',
      'j-hui/fidget.nvim',
			'jose-elias-alvarez/null-ls.nvim',
			'jose-elias-alvarez/typescript.nvim',
			'b0o/schemastore.nvim',
			-- Additional lua configuration, makes nvim stuff amazing
			'folke/neodev.nvim',
		},
	},
  -- Useful status updates for LSP
  {
    'j-hui/fidget.nvim',
    version = 'legacy',
  },

	-- Scrolling
	'karb94/neoscroll.nvim',

	-- InPane navigation
	{
		'phaazon/hop.nvim',
		branch = 'v2', -- optional but strongly recommended
	},

	-- Text Copy/Paste with Tmux
	'ojroques/nvim-osc52',

	-- Autocompletion
	{ 'folke/which-key.nvim', event = "BufWinEnter", config = "require('setup/which-key')" },

	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-nvim-lua',
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
			'rafamadriz/friendly-snippets',
			'quangnguyen30192/cmp-nvim-tags',
			'zbirenbaum/copilot-cmp',
			'onsails/lspkind-nvim',
			'kristijanhusak/vim-dadbod-completion',
			-- -- if you want the sources is available for some file types
			-- ft = {
			--   'ruby',
			--   'yamlls'
			-- }
		},
		config = "require('setup/cmp')"
	},

	-- Highlight, edit, and navigate code
	{
		'nvim-treesitter/nvim-treesitter',
		build = function()
			pcall(require('nvim-treesitter.install').update { with_sync = true })
		end,
    dependencies = {
		  'nvim-treesitter/nvim-treesitter-textobjects',
    }
	},
  'nvim-treesitter/playground',
	'wfxr/minimap.vim',

	-- formatting
  'lukas-reineke/lsp-format.nvim',
	{ 'jose-elias-alvarez/null-ls.nvim',
		config = function()
			require('setup/null-ls')
		end,
		dependencies = { "nvim-lua/plenary.nvim" }
	},

	-- svelte (no lsp?
  'evanleck/vim-svelte',

	{
		'nvim-tree/nvim-tree.lua',
		dependencies = {
			'nvim-tree/nvim-web-devicons', -- optional, for file icons
		},
		-- tag = 'nightly' -- optional, updated every week. (see issue #1193)
	},

	-- debugging
	-- {
	-- 	"mfussenegger/nvim-dap",
	-- 	config = function()
	-- 		require('setup/dap')
	-- 	end,
	-- 	dependencies = {
      -- "rcarriga/nvim-dap-ui",
      -- -- "mxsdev/nvim-dap-vscode-js",
      -- "leoluz/nvim-dap-go",
      -- "suketa/nvim-dap-ruby",
      -- "nvim-telescope/telescope-dap.nvim",
    -- },
	-- },

  -- {
  --   "microsoft/vscode-js-debug",
  --   opt = true,
  --   build = "npm install --legacy-peer-deps && npm build compile"
  -- },

  -- {"mhanberg/elixir.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim"
  --   }
  -- },

  { 'elixir-editors/vim-elixir' },

	{ 'kristijanhusak/vim-dadbod-ui',
		dependencies = {
			'tpope/vim-dadbod',
			'tpope/vim-dotenv',
		}
	},

	{ 'folke/which-key.nvim', event = "BufWinEnter", config = "require('setup/which-key')" },

	-- Vim-Zettel for Zettel?
	{ 'michal-h21/vim-zettel',
		dependencies = {
			'vimwiki/vimwiki',
			'junegunn/fzf',
			'junegunn/fzf.vim',
		}
	},

	-- zen-mode is much better!
	{
		'folke/zen-mode.nvim',
		config = function()
			require('setup/zen-mode')
		end,
	},

  -- text/markdown
  'preservim/vim-markdown',


	{
		"folke/twilight.nvim",
		config = function()
			require("setup/twilight")
		end
	},

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

	-- text plugs (via youtuber bitter tea sweet orange)
	'rmagatti/alternate-toggler',
	'windwp/nvim-autopairs',
	-- 'mg979/vim-visual-multi',
	-- 'gcmt/wildfire.vim',
	-- 'tpope/vim-surround',

	-- Git related plugins
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',
	'lewis6991/gitsigns.nvim',

  {
    "aaronhallaert/ts-advanced-git-search.nvim",
    config = function()
      require("telescope").load_extension("advanced_git_search")
    end,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      -- to show diff splits and open commits in browser
      "tpope/vim-fugitive",
    },
  },

  -- colors
  {'ellisonleao/gruvbox.nvim',
    commit = 'cb7a8a867cfaa7f0e8ded57eb931da88635e7007',
    config = function()
      vim.cmd("let g:gruvbox_transparent_bg = 1")
      vim.cmd("autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE")
      vim.cmd("colorscheme gruvbox")
      -- vim.o.background = "light"
      vim.o.background = appearance
    end
  },
  {'folke/tokyonight.nvim',
    -- config = function()
    --   vim.cmd("autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE")
    --   vim.cmd("colorscheme tokyonight")
    --   vim.cmd("set background=dark")
    -- end
  },


	'nvim-lualine/lualine.nvim',
	'lukas-reineke/indent-blankline.nvim',
	'numToStr/Comment.nvim',
	'tpope/vim-dotenv',
	'simrat39/symbols-outline.nvim',
	'jlanzarotta/bufexplorer',

  {
		'kylechui/nvim-surround',
		config = function()
			require('nvim-surround').setup({
				-- Configuration here, or leave empty to use defaults
			})
		end
	},

  -- Align tables
	'junegunn/vim-easy-align',

	-- Fuzzy Finder (files, lsp, etc)
	{ 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },

	-- Fuzzy Finder Algorithm which dependencies local dependencies to be built. Only load if `make` is available
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable 'make' == 1 },

	-- copilot
	-- via tpope
	-- 'github/copilot.vim'
	-- via lua
  {
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "VimEnter",
		config = function()
			vim.defer_fn(function()
				require("copilot").setup(
					{
						suggestion = { enabled = false },
						panel = { enabled = false },
						-- suggestion = {
						-- 	enabled = true,
						-- 	auto_trigger = false,
						-- 	debounce = 75,
						-- 	keymap = {
						-- 		accept = "<C-l>",
						-- 		accept_word = false,
						-- 		accept_line = false,
						-- 		next = "<C-]>",
						-- 		prev = "<C-[>",
						-- 		dismiss = "<C-x>",
						-- 	},
						-- },
					 --  copilot_node_command = 'node', -- Node.js version must be > 16.x
						-- server_opts_overrides = {},
					}
				)
			end, 100)
		end,
	},

  {
    "zbirenbaum/copilot-cmp",
    dependencies = {
      'zbirenbaum/copilot.lua'
    },
    config = function ()
      require("copilot_cmp").setup()
    end,
  },

	-- {
	-- 	"zbirenbaum/copilot-cmp",
	-- 	after = { "copilot.lua" },
	-- 	config = function ()
	-- 		require("copilot_cmp").setup(
	-- 			{
	-- 				method = "getCompletionsCycling",
	-- 				-- formatters = {
	-- 				-- 	label = require("copilot_cmp.format").format_label_text,
	-- 				-- 	insert_text = require("copilot_cmp.format").format_insert_text,
	-- 				-- 	preview = require("copilot_cmp.format").deindent,
	-- 				-- }
	-- 			}
	-- 		)

	-- 	end
	-- },

	-- rails
	'tpope/vim-rails',

	{ -- tmux navigation
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
	},

  {
    'fei6409/log-highlight.nvim',
    config = function()
        require('log-highlight').setup {}
    end,
  },

	-- wip custom plugin development
	-- { [[/Users/dgdosen/dev/which_snip.nvim]] },

})

-- TODO: should these setups be in the configs above? Is there any benefit to doing it here?

require('setup/mason')

require('setup/lsp')
-- require('setup/bufexplorer')
require('setup/cmp')
require('setup/comment')
require('setup/dap')
require('setup/gruvbox')
-- require('setup/elixir')
require('setup/gitsigns')
require('setup/hop')
require('setup/indent_blankline')
require('setup/lualine')
require('setup/luasnips')
-- require('setup/neoclip')
require('setup/neodev')
require('setup/neoscroll')
require('setup/nvim-tree')
require('setup/null-ls')
require('setup/telescope')
require('setup/text')
-- require('setup/treesitter')
require('setup/typescript')
require('setup/osc52')
require('setup/vim-dadbod-ui')
-- require('setup/telekasten')
require('setup/which-key')
require('setup/vim-wiki')

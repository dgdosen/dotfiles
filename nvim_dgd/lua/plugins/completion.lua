return {
  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
      -- 'delphinus/cmp-ctags',
      'quangnguyen30192/cmp-nvim-tags',
      -- 'zbirenbaum/copilot-cmp',
      'onsails/lspkind-nvim',
      'kristijanhusak/vim-dadbod-completion',
      -- -- if you want the sources is available for some file types
      -- ft = {
      --   'ruby',
      --   'yamlls'
      -- }
    },
    config = function()
      require('setup/cmp')
      require('setup/luasnips')
    end,
  },
}
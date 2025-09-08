vim.g.completeopt = "menu,menuone,noselect,noinsert"

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Load required modules
local cmp = require 'cmp'
local luasnip = require 'luasnip'
local lspkind = require 'lspkind'

-- LuaSnip Configuration
require("luasnip.loaders.from_vscode").lazy_load()
require 'luasnip'.filetype_extend("ruby", { "rails" })
require 'luasnip'.filetype_extend("typescript", { "ts" })


-- LSPKind & Highlight Configuration
lspkind.init({
  symbol_map = {
    Copilot = "",
  },
})

-- Set Copilot highlight color
vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#98971A" })

-- Define completion source menu labels
local source_menu = {
  buffer = "[buf]",
  nvim_lsp = "[lsp]",
  nvim_lua = "[api]",
  ['vim-dadbod-completion'] = '[db]',
  path = "[path]",
  luasnip = "[snip]",
  gh_issues = "[issues]",
  copilot = "[cp]",
  tags = '[tags]'
}

-- Formatting configuration
local formatting_config = {
  format = lspkind.cmp_format({
    mode = 'symbol_text',
    maxwidth = 50,
    ellipsis_char = '...',
    menu = source_menu,
    before = function(entry, vim_item)
      -- Customize the appearance of different sources
      if entry.source.name == 'copilot' then
        vim_item.kind_hl_group = 'CmpItemKindCopilot'
      end
      return vim_item
    end,
  })
}

-- Main CMP Setup
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-y>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<C-Space>'] = cmp.mapping.complete {},
    -- Documentation scrolling
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    -- Smart Tab completion with snippet jumping
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = cmp.config.sources({
    -- High priority: LSP and snippets
    { name = 'nvim_lsp', priority = 1000 },
    { name = 'luasnip', priority = 750 },
  }, {
    -- Medium priority: AI assistance and tags
    { name = 'copilot', priority = 600 },
    { 
      name = 'tags', 
      priority = 500,
      option = {
        complete_defer = 100,
        max_items = 10,
        keyword_length = 3,
        exact_match = false,
        current_buffer_only = false,
      },
    },
  }, {
    -- Lower priority: buffer text and paths
    { name = 'buffer', keyword_length = 4, priority = 300 },
    { name = 'path', priority = 250 },
    { name = 'treesitter', priority = 200 },
  }),
  formatting = formatting_config,
}

-- Filetype-specific Completion Setup

-- SQL file completion setup
local sql_augroup = vim.api.nvim_create_augroup("DadbodSql", { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sql', 'mysql', 'plsql' },
  callback = function()
    require('cmp').setup.buffer({
      sources = {
        { name = "vim-dadbod-completion" },
        { name = "buffer" },
      },
    })
  end,
  group = sql_augroup,
})


-- Zsh file completion setup  
local zsh_augroup = vim.api.nvim_create_augroup("CmpZsh", { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'zsh',
  callback = function()
    require('cmp').setup.buffer({
      sources = {
        { name = 'zsh' },
      },
    })
  end,
  group = zsh_augroup,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

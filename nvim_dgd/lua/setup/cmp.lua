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
    -- ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
    --
    -- default next/previous via ins-completion
    -- ['<C-n>'] = next...(),
    -- ['<C-p>'] = previous(),
    --
    --   ['<Tab>'] = cmp.mapping(function(fallback)
    --     if cmp.visible() then
    --       cmp.select_next_item()
    --     elseif luasnip.expand_or_jumpable() then
    --       luasnip.expand_or_jump()
    --     else
    --       fallback()
    --     end
    --   end, { 'i', 's' }),
    --   ['<S-Tab>'] = cmp.mapping(function(fallback)
    --     if cmp.visible() then
    --       cmp.select_prev_item()
    --     elseif luasnip.jumpable(-1) then
    --       luasnip.jump(-1)
    --     else
    --       fallback()
    --     end
    --   end, { 'i', 's' }),
  },
  sources = {
    -- Tags completion with custom configuration
    {
      name = 'tags',
      option = {
        complete_defer = 100,     -- Delay after user input (ms)
        max_items = 10,           -- Max items when searching taglist
        keyword_length = 3,       -- Min chars to trigger completion
        exact_match = false,      -- Use fuzzy matching
        current_buffer_only = false,
      },
    },
    -- Core completion sources
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'copilot' },
    -- Buffer completion (requires 4+ chars to avoid noise)
    { name = 'buffer', keyword_length = 4 },
    -- Additional sources
    { name = 'path' },
    { name = 'treesitter' },
  },
  formatting = {
    format = lspkind.cmp_format({
      with_text = true,
      maxwidth = 50,
      menu = source_menu,
    })
  },
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

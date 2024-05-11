vim.g.completeot = "menu,menuone,noselect,noinsert"

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'
local lspkind = require 'lspkind'
require("luasnip.loaders.from_vscode").lazy_load()
require 'luasnip'.filetype_extend("ruby", { "rails" })
require 'luasnip'.filetype_extend("typescript", { "ts" })

-- lspconfig for copliot
lspkind.init({
  symbol_map = {
    Copilot = "",
  },
})

-- defining colors
-- vim.api.nvim_set_hl(0, "CmpItemKindCopilot", {fg ="#689D6A"})
vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#98971A" })

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
    {
      name = 'tags',
      option = {
        -- this is the default options, change them if you want.
        -- Delayed time after user input, in milliseconds.
        complete_defer = 100,
        -- Max items when searching `taglist`.
        max_items = 10,
        -- The number of characters that need to be typed to trigger
        -- auto-completion.
        keyword_length = 3,
        -- Use exact word match when searching `taglist`, for better searching
        -- performance.
        exact_match = false,
        -- Prioritize searching result for current buffer.
        current_buffer_only = false,
      },
    },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    -- { name = 'nvim_lua' },
    { name = "copilot" },
    { name = 'buffer',    keyword_length = 4 },
    { name = 'path' },
    { name = 'treesitter' },
  },
  formatting = {
    format = lspkind.cmp_format({
      with_text = true,
      maxwidth = 50,
      menu = {
        buffer = "[buf]",
        nvim_lsp = "[lsp]",
        nvim_lua = "[api]",
        ['vim-dadbod-completion'] = '[db]',
        path = "[path]",
        luasnip = "[snip]",
        gh_issues = "[issues]",
        copilot = "[cp]",
        tags = '[tags]'
      },
    })
  },
}

local autocomplete_group = vim.api.nvim_create_augroup('vimrc_autocompletion', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sql', 'mysql', 'plsql' },
  callback = function()
    cmp.setup.buffer({ sources = { { name = 'vim-dadbod-completion' } } })
  end,
  group = autocomplete_group,
})

-- Add vim-dadbod-completion in sql files
_ = vim.cmd [[
  augroup DadbodSql
    au!
    autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer { sources = { { name = 'vim-dadbod-completion' } } }
  augroup END
]]

_ = vim.cmd [[
  augroup CmpZsh
    au!
    autocmd Filetype zsh lua require'cmp'.setup.buffer { sources = { { name = "zsh" }, } }
  augroup END
]]

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

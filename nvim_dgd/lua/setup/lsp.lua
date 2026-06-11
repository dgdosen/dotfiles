local capabilities = vim.lsp.protocol.make_client_capabilities()

-- LSP settings.
--  on_attach runs when an LSP connects to a buffer; it wires the buffer-local
--  keymaps. Extracted to setup/lsp_on_attach.lua so typescript-tools.nvim
--  (which sets itself up independently of this servers loop) shares the maps.
local on_attach = require('setup.lsp_on_attach')

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.

local servers = {
  -- clangd = {},
  html = {},
  graphql = {},
  dockerls = {},

  -- solargraph = {
  --   cmd = {"solargraph", "stdio"}
  -- },
  svelte = {},
  -- gopls = {},
  -- pyright = {},
  rust_analyzer = {
    cmd = {
      "rustup", "run", "stable", "rust-analyzer"
    }
    -- capabilities = capabilities,
    -- on_attach = on_attach,
  },

  yamlls = {
    yaml = {
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
      schemas = {
        kubernetes = "*.yaml",
        -- ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
        -- ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
        ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
        ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
        -- ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
        -- ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
        -- ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
        -- ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
        "*docker-compose*.{yml,yaml}",
        --   ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
      },
      -- format = {
      --   enable = false,
      -- },
      -- validate = false,
      completion = true,
      hover = true,

    },
  },
  lua_ls = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim', 'print' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup()

-- require('lspconfig').ruby_lsp.setup({
--   init_options = {
--     formatter = "rubocop",
--     linters = { "rubocop" }
--   }
-- })
--
-- Configure each LSP server using the new vim.lsp.config API
for server_name, server_config in pairs(servers) do
  vim.lsp.config(server_name, {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = server_config,
  })
end

-- Enable all configured servers
local server_names = {}
for server_name, _ in pairs(servers) do
  table.insert(server_names, server_name)
end
vim.lsp.enable(server_names)

-- mason_lspconfig.setup_handlers {
--   function(server_name)
--     require('lspconfig')[server_name].setup {
--       capabilities = capabilities,
--       on_attach = on_attach,
--       settings = servers[server_name],
--     }
--     -- if server_name == 'tsserver' then
--     --   require('lspconfig').ts_ls.setup({
--     --     settings = {
--     --       completions = {
--     --         completeFunctionCalls = true
--     --       }
--     --     }
--     --   })
--     -- end
--   end,
-- }

-- Turn on lsp status information
-- require('fidget').setup()

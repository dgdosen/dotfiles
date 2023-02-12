-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[r]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction')

  nmap('gd', vim.lsp.buf.definition, '[g]oto [d]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[g]oto [r]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[g]oto [i]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[d]ocument [s]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[w]orkspace [s]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  nmap("<leader>lf", function()
    vim.lsp.buf.format({ async = true })
  end, 'null-[L]s [F]ormat')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  html = {},
  ruby_ls = {},
  graphql = {},
  dockerls = {},

  -- solargraph = {},
  svelte = {},
  -- gopls = {},
  -- pyright = {},
  rust_analyzer = {},
  -- tsserver = {},

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
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
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

  -- sumneko_lua = {
  --   Lua = {
  --     workspace = { checkThirdParty = false },
  --     telemetry = { enable = false },
  --     diagnostics = {
  --       -- Get the language server to recognize the `vim` global
  --       globals = {'vim'},
  --     },
  --   },
  -- },
}

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  -- function(server_name)
    -- require('lspconfig')[server_name].setup {
    --   capabilities = capabilities,
    --   on_attach = on_attach,
    --   settings = servers[server_name],
    -- }
    -- if server_name == 'tsserver' then
    --   require('lspconfig').tsserver.setup({
    --     settings = {
    --       completions = {
    --         completeFunctionCalls = true
    --       }
    --     }
    --   })
    -- end
  -- end,
}

-- Turn on lsp status information
require('fidget').setup()

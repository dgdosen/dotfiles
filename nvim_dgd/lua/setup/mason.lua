require("mason").setup()
require('mason-update-all').setup()
require('mason-lspconfig').setup()
-- require("mason-lspconfig").setup_handlers({
--   -- Will be called for each installed server that doesn't have
--   -- a dedicated handler.
--   --
--   function(server_name) -- default handler (optional)
--     -- https://github.com/neovim/nvim-lspconfig/pull/3232
--     if server_name == "tsserver" then
--       server_name = "ts_ls"
--     end
--     local capabilities = require("cmp_nvim_lsp").default_capabilities()
--     require("lspconfig")[server_name].setup({
--
--       capabilities = capabilities,
--     })
--   end,
-- })

local null_ls = require('null-ls')

local sources = {
  null_ls.builtins.formatting.eslint,
  null_ls.builtins.formatting.gofmt,
  null_ls.builtins.formatting.isort,
  null_ls.builtins.formatting.tidy,
  -- null_ls.builtins.formatting.stylelua,
  null_ls.builtins.formatting.rufo,
  null_ls.builtins.formatting.prettier,
  null_ls.builtins.formatting.yamlfmt,
  null_ls.builtins.formatting.codespell.with({ filetypes = { 'markdown' } }),
  null_ls.builtins.diagnostics.eslint,
  -- null_ls.builtins.diagnostics.rubocop,
  null_ls.builtins.completion.spell,
}

null_ls.setup({
  sources = sources,
  -- on_attach = function(client)
  --   if client.resolved_capabilities.document_formatting then
  --     vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()")
  --   end
  --   -- vim.cmd [[
  --   --   augroup document_highlight
  --   --     autocmd! * <buffer>
  --   --     autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
  --   --     autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
  --   --   augroup END
  --   -- ]]
  -- end
})

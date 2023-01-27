local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

vim.keymap.set('n', '<F5>', ":lua require'dap'.continue()<CR>")
vim.keymap.set('n', '<F10>', ":lua require'dap'.step_over()<CR>")
vim.keymap.set('n', '<leader>b', ":lua require'dap'.toggle_breakpoint()<CR>")

require("dap-vscode-js").setup({
  node_path = os.getenv('HOME') .. '/.nvm/versions/node/v18.2.0/bin/node',
  debugger_path = os.getenv('HOME') .. '/vscode-js-debug/',
  adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
})

for _, language in ipairs({ "typescript", "typescriptreact", "javascript" }) do
  dap.configurations[language] = {
   {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    skipFiles = { "<node_internals>/**", "node_modules/**" },
  },
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach",
    processId = require'dap.utils'.pick_process,
    cwd = "${workspaceFolder}",
  }}
end


-- vim.keymap.set("n", "<leader><leader>x", "<cmd>source ~/.config/nvim/lua/setup/luasnips.lua<cr>|<cmd>source ~/.config/nvim/lua/setup/dap.lua<cr>")


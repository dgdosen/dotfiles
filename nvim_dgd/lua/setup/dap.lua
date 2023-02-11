local ok, _ = pcall(require, "dap")
if not ok then return end

vim.keymap.set('n', '<leader>xt', ":lua require('dap-go').debug_test()<CR>")
vim.keymap.set('n', '<F5>', ":lua require'dap'.continue()<CR>")
vim.keymap.set('n', '<F4>', ":lua require'dap'.step_over()<CR>")
vim.keymap.set('n', '<F3>', ":lua require'dap'.step_into()<CR>")
vim.keymap.set('n', '<F2>', ":lua require'dap'.step_out()<CR>")
vim.keymap.set('n', '<leader>b', ":lua require'dap'.toggle_breakpoint()<CR>")
-- vim.keymap.set('n', '<leader>b', vim.dap.toggle_breakpoint())
vim.keymap.set('n', '<leader>B', ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set('n', '<leader>lp', ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message:  '))<CR>")

-- require("dap-vscode-js").setup({
--   debugger_path = os.getenv('HOME') .. '/dev/vscode-js-debug/',
--   debugger_cmd = { 'js-debug-adapter' },
--   adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
-- })

require('dap-go').setup()
require("dapui").setup()
require('dap-ruby').setup()

local dap = require("dap")
local dapui = require("dapui")

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

dap.adapters.ruby = {
	type = "executable",
	command = "rdbg",
}
dap.configurations.ruby = {
	{
		type = "ruby",
		name = "Debug current file with rdbg",
		request = "launch",
		program = "${file}"
	},
}
-- custom adapter for running tasks before starting debug
local custom_adapter = 'pwa-node-custom'
dap.adapters[custom_adapter] = function(cb, config)
  if config.preLaunchTask then
    local async = require('plenary.async')
    local notify = require('notify').async

    async.run(function()
      ---@diagnostic disable-next-line: missing-parameter
      notify('Running [' .. config.preLaunchTask .. ']').events.close()
    end, function()
      vim.fn.system(config.preLaunchTask)
      config.type = 'pwa-node'
      dap.run(config)
    end)
  end
end

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
      type = 'pwa-node',
      request = 'attach',
      name = 'Attach to node process',
      processId = require('dap.utils').pick_process,
      -- rootPath = '${workspaceFolder}',
      cwd = "${workspaceFolder}",
    },
  }

end

-- dap.configurations["ruby"] = {
--   {
--     type = "ruby",
--     name = "Debug current file with rdbg",
--     request = "launch",
--     program = "${file}",
--   },
-- }

-- vim.keymap.set("n", "<leader><leader>x", "<cmd>source ~/.config/nvim/lua/setup/luasnips.lua<cr>|<cmd>source ~/.config/nvim/lua/setup/dap.lua<cr>")


-- claudecode.nvim: bridge between nvim and the `claude` CLI.
--
-- Usage (nvim + claude in separate tmux panes, same repo):
--   1. In nvim:  press <leader>ab  (loads plugin, starts server, writes lock file)
--   2. In claude pane:  run /ide  -> pick this nvim instance -> connected
--   Now Claude sees your active buffer/selection and shows edits as nvim diffs.
--
-- Keymaps:  <leader>ab add buffer | <leader>as send selection (visual)
--           <leader>ay accept diff | <leader>an deny diff
--
-- Loaded lazily (cmd/keys, not VeryLazy) on purpose: eager-start raced for a
-- port when smug/tmux launched many nvim instances at once (EADDRINUSE).
return {
  {
    'coder/claudecode.nvim',
    cmd = { 'ClaudeCode', 'ClaudeCodeAdd', 'ClaudeCodeSend', 'ClaudeCodeDiffAccept', 'ClaudeCodeDiffDeny' },
    opts = {
      terminal = {
        provider = 'none',
      },
    },
    keys = {
      { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>',      desc = '[a]I add [b]uffer' },
      { '<leader>as', '<cmd>ClaudeCodeSend<cr>',       mode = 'v',                  desc = '[a]I [s]end selection' },
      { '<leader>ay', '<cmd>ClaudeCodeDiffAccept<cr>', desc = '[a]I diff [y]es/accept' },
      { '<leader>an', '<cmd>ClaudeCodeDiffDeny<cr>',   desc = '[a]I diff [n]o/deny' },
    },
  },
}

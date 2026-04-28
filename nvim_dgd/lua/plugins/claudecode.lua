return {
  {
    'coder/claudecode.nvim',
    event = 'VeryLazy',
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

return {
  {
    'coder/claudecode.nvim',
    event = 'VeryLazy',
    config = true,
    keys = {
      { '<leader>at', '<cmd>ClaudeCode<cr>',            desc = '[a]I [t]oggle Claude' },
      { '<leader>af', '<cmd>ClaudeCodeFocus<cr>',       desc = '[a]I [f]ocus Claude' },
      { '<leader>ar', '<cmd>ClaudeCode --resume<cr>',   desc = '[a]I [r]esume session' },
      { '<leader>ac', '<cmd>ClaudeCode --continue<cr>', desc = '[a]I [c]ontinue session' },
      { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = '[a]I select [m]odel' },
      { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>',       desc = '[a]I add [b]uffer' },
      { '<leader>as', '<cmd>ClaudeCodeSend<cr>',        mode = 'v',                                         desc = '[a]I [s]end selection' },
      {
        '<leader>as',
        '<cmd>ClaudeCodeTreeAdd<cr>',
        desc = '[a]I [s]end file from tree',
        ft = { 'oil', 'NvimTree', 'neo-tree', 'minifiles' },
      },
      { '<leader>ay', '<cmd>ClaudeCodeDiffAccept<cr>', desc = '[a]I diff [y]es/accept' },
      { '<leader>an', '<cmd>ClaudeCodeDiffDeny<cr>',   desc = '[a]I diff [n]o/deny' },
    },
  },
}

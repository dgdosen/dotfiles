-- Enable Comment.nvim
require('Comment').setup {
  pre_hook = function(ctx)
    return require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()(ctx)
  end,
  mappings = {
    ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
    basic = true,
    ---Extra mapping; `gco`, `gcO`, `gcA`
    extra = true,
  },
}

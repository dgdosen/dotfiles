if vim.loader then
  vim.loader.enable()
end

require('options')
require('plugins')
require('mappings')
require('chatgpt')

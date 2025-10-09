if vim.loader then
  vim.loader.enable()
end

require('options')
require('lazy-config')
require('mappings')
require('chatgpt')
require('theme-loader')

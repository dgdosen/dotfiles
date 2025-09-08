local plugins = {}

-- adding local dev of nvim plugins (if exists on current machine)
if vim.fn.isdirectory(vim.fn.expand("~/dev/plugins/present.nvim")) == 1 then
  table.insert(plugins, {
    "present.nvim",
    dir = "~/dev/plugins/present.nvim",
    dev = true,
    config = function()
      require("present").setup()
    end,
  })
end

return plugins

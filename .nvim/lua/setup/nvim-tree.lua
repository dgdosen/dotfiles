require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
	git = {
    enable = true,
    ignore = false,
    timeout = 500,
  },
--  filters = {
--    dotfiles = true,
--  },
})

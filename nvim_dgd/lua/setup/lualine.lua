-- Set lualine as statuslinea
-- See `:help lualine.txt`
local appearance = vim.fn.system("echo $APPEARANCE"):gsub("\n", "")

local symbols = {
  unix = '', -- e712
  dos = '', -- e70f
  mac = '', -- e711
}

-- Conditionally set the lualine theme
-- local lualine_theme
-- if appearance == "dark" then
--   lualine_theme = 'gruvbox_dark'
-- else
--   lualine_theme = 'gruvbox_light'
-- end

require('lualine').setup {
  options = {
    icons_enabled = true,
    -- theme = 'gruvbox',
    theme = 'catppuccin',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = { diagnostics },
      lualine_x = { diff, spaces, "encoding", { 'fileformat', symbols = { unix = 'Unix', dos = '', mac = '', } }, filetype },
      lualine_y = { location },
      lualine_z = { "progress" },
    },
  },
}

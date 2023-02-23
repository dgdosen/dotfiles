-- Set lualine as statuslinea
-- See `:help lualine.txt`
local symbols = {
  unix = '', -- e712
  dos = '', -- e70f
  mac = '', -- e711
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox_dark',
    -- theme = 'tokyonight',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {"branch"},
      lualine_c = { diagnostics },
      lualine_x = { diff, spaces, "encoding", {'fileformat', symbols = { unix = 'Unix', dos = '', mac = '',}}, filetype },
      lualine_y = { location },
      lualine_z = { "progress" },
    },
  },
}

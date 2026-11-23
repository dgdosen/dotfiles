-- Catppuccin Mocha on a pure black background, for more contrast.
-- Matches the terminal theme catppuccin-mocha-dark (alacritty/kitty/ghostty/tmux).
--
-- catppuccin.nvim only ships four flavours. Rather than re-running its setup
-- with color_overrides (its compiler keeps the options from the first setup,
-- so a second build in one session comes out stale), this loads stock Mocha
-- and remaps its background shades in every highlight group. Stock
-- `:colorscheme catppuccin-mocha` is left untouched.
local remap = {
  [0x1e1e2e] = 0x000000, -- base    editor background
  [0x181825] = 0x0c0c14, -- mantle  sidebars, statusline
}

-- Call catppuccin's loader directly: a nested `:colorscheme` inside a colors
-- file is silently ignored (Neovim blocks recursive colorscheme loads).
require("catppuccin").load("mocha")

for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
  if not hl.link then
    local changed = false
    for _, key in ipairs({ "bg", "fg", "sp" }) do
      local new = hl[key] and remap[hl[key]]
      if new then
        hl[key] = new
        changed = true
      end
    end
    if changed then vim.api.nvim_set_hl(0, name, hl) end
  end
end

vim.g.colors_name = "catppuccin-mocha-dark"

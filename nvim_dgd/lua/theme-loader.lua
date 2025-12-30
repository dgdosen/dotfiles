-- Auto-load theme based on ~/.dotfiles/.nvim-theme file
local theme_file = vim.fn.expand("~/.dotfiles/.nvim-theme")

-- Default theme if file doesn't exist
local default_theme = "gruvbox"

-- Read theme from file
local function load_theme()
  local file = io.open(theme_file, "r")
  if file then
    local theme = file:read("*line")
    file:close()

    if theme and theme ~= "" then
      -- Map theme names to nvim colorscheme names
      local theme_map = {
        ["gruvbox_dark"] = "gruvbox",
        ["gruvbox-dark"] = "gruvbox",
        ["gruvbox_light"] = "gruvbox",
        ["gruvbox-light"] = "gruvbox",
        ["catppuccin-mocha"] = "catppuccin-mocha",
        ["catppuccin-latte"] = "catppuccin-latte",
        ["everforest_dark"] = "everforest",
        ["everforest-dark"] = "everforest",
        ["everforest_light"] = "everforest",
        ["everforest-light"] = "everforest",
      }

      local colorscheme = theme_map[theme] or theme

      -- Set gruvbox background if needed
      if colorscheme == "gruvbox" then
        if string.match(theme, "light") then
          vim.opt.background = "light"
        else
          vim.opt.background = "dark"
        end
      elseif colorscheme == "everforest" then
        if string.match(theme, "light") then
          vim.opt.background = "light"
        else
          vim.opt.background = "dark"
        end
      end

      -- Apply colorscheme
      local ok, _ = pcall(vim.cmd.colorscheme, colorscheme)
      if not ok then
        vim.cmd.colorscheme(default_theme)
      end
      return
    end
  end

  -- Fallback to default
  vim.cmd.colorscheme(default_theme)
end

-- Load theme after plugins are loaded
vim.api.nvim_create_autocmd("VimEnter", {
  callback = load_theme,
  nested = true,
})

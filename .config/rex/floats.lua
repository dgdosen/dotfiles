-- Floating panes: overlays on the current tab that close when their program
-- exits. Pattern from github.com/smnatale/dotfiles rex/.config/rex/floats.lua.
-- All are in the command palette too; keys at the bottom (prefix mode is
-- defined in prefix.lua).

-- the focused pane's directory (its foreground program's cwd)
local function focused_cwd(ctx)
  local proc = rex.block.call("com.superlogical.terminal", "process", { block_id = ctx.block_id })
  return proc and proc.foreground and proc.foreground.cwd
end

local MAX_COLS = 140  -- floats never get wider than this many columns

-- a block's rect { x, y, w, h } (window fractions) in a layout tree
local function rect_of(node, id)
  if node.block_id == id then return node.rect end
  local s = node.split
  return s and (rect_of(s.before, id) or rect_of(s.after, id))
end

-- bounds covering `frac` of the window, but at most `max_cols` wide, centered.
-- Rex only takes fractions, so the window's width in columns is worked out
-- from the focused pane: its columns / its share of the window's width.
local function capped_bounds(ctx, frac, max_cols)
  local w = frac
  local size = rex.block.call("com.superlogical.terminal", "size", { block_id = ctx.block_id })
  local view = rex.session.view {}
  for _, win in ipairs(size and view and view.windows or {}) do
    for _, layer in ipairs(win.layers) do
      local r = layer.kind == "tiled" and rect_of(layer.layout, ctx.block_id)
      if r then w = math.min(frac, max_cols * r[3] / size.columns) end
    end
  end
  return { (1 - w) / 2, (1 - frac) / 2, w, frac }
end

-- a palette action that runs `command` (argv, or nil for a shell) in a float
-- covering `frac` of the window (default 0.9), capped at `max_cols` columns
local function float(name, title, command, frac, max_cols)
  rex.action {
    name  = name,
    title = title,
    run   = function(ctx)
      local _, err = rex.session.new_layer {
        bounds = capped_bounds(ctx, frac or 0.9, max_cols or MAX_COLS),
        layout = rex.layout.block {
          flavor  = "com.superlogical.terminal.shell",
          options = { command = command, cwd = focused_cwd(ctx) },
        },
        focus  = true,
      }
      if err ~= nil then error(err, 0) end
    end,
  }
end

-- lazygit-style session cards (~/.bin/rex-sessions); quits after switching
float("sessions_float", "Session Cards", { os.getenv("HOME") .. "/.bin/rex-sessions" }, 0.8)
float("lazygit_float", "Lazygit", { "lazygit" })
float("scratch_float", "Scratch Terminal")

rex.action {
  name  = "open_in_finder",
  title = "Open in Finder",
  run   = function(ctx) rex.exec { "open", focused_cwd(ctx) or os.getenv("HOME") } end,
}

rex.bind("prefix/shift+s", "sessions_float")  -- prefix s stays the native picker
rex.bind("prefix/g", "lazygit_float")
rex.bind("prefix/t", "scratch_float")

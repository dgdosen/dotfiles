-- Rex config (symlinked: ~/.config/rex -> ~/.dotfiles/.config/rex)
-- Check:  rex config check     Reload: rex config reload (or prefix r)
-- Inspect resolved keys: rex keymap
--
-- Rex does NOT watch this file: after editing, press cmd+shift+r (below)
-- or run `rex config reload`.

-- reload this config without needing the prefix
rex.bind("cmd+shift+r", "client.config.reload")

-- Modules (files next to this one; Rex's require finds them). Both only ADD
-- bindings; Rex's native shortcuts keep working regardless.
--   prefix.lua  ctrl+a prefix layer (comment out to give ctrl+a back to programs)
--   floats.lua  floating panes: session cards, lazygit, scratch shell, Finder
--   sessions/   rexs session scripts (not Lua config; run via ~/.bin/rexs)
require("prefix")
require("floats")

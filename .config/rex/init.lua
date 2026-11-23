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

-- rex-navigator (github.com/wassimk/rex-navigator.nvim): ctrl+h/j/k/l moves
-- between Rex panes, EXCEPT when nvim/vim is the focused program; then the key
-- passes through and Neovim moves between its own splits (nvim-tree, dadbod
-- UI drawers, etc.), handing back to Rex only at the edge. Its Neovim half is
-- in nvim_dgd/lua/plugins/text.lua. This steals ctrl+h/j/k/l from the shell
-- (backspace, clear-screen, kill-line); accepted 2026-11-21.
-- The Rex half is loaded straight from lazy.nvim's install dir (instead of the
-- README's symlink) so no absolute path lands in the repo; pcall keeps this
-- config working on a machine where lazy hasn't installed the plugin yet.
package.path = os.getenv("HOME") .. "/.local/share/nvim/lazy/rex-navigator.nvim/rex/?.lua;" .. package.path
local ok_nav, rex_nav = pcall(require, "rex-navigator")
if ok_nav then rex_nav.setup() end

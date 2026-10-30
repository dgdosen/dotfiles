-- Rex config (symlinked: ~/.config/rex -> ~/.dotfiles/.config/rex)
-- Check:  rex config check     Reload: rex config reload (or prefix r)
-- Inspect resolved keys: rex keymap
--
-- Rex does NOT watch this file: after editing, press cmd+shift+r (below)
-- or run `rex config reload`.

-- ACTIVE: reload this config without needing the prefix
rex.bind("cmd+shift+r", "client.config.reload")

-- KEYMAP switch (edit, then cmd+shift+r):
--   "native" = Rex's built-in shortcuts only; this file binds nothing extra.
--   "tmux"   = also turn on the ctrl+a prefix bindings (mirrors .tmux.conf).
-- The tmux bindings are additive: the native shortcuts keep working either
-- way. No Rex default appears to use ctrl+a (the only ctrl keys in the app
-- binary are ctrl+shift+pageup/pagedown; checked 2026-10-29). What "tmux"
-- takes away is ctrl+a from programs in the pane: shell beginning-of-line,
-- Neovim's increment-number, and a nested tmux's prefix. Press ctrl+a twice
-- to send one through.
local KEYMAP = "tmux"

-- ---------------------------------------------------------------------------
-- NATIVE: Rex's built-in shortcuts, for comparison. Reference only; nothing is
-- bound here. They ship inside the app, and neither `rex keymap` nor the docs
-- list them, so read them off the command palette or the app's menus and fill
-- in the ?s. Same order as the tmux section below.
--
-- copy/paste:  ⌘ cmd   ⌃ ctrl   ⌥ opt   ⇧ shift   ⎋ esc   ↩ return   ⇥ tab
--              ⌫ backspace   ← ↑ → ↓
--
--   action                   native           tmux (prefix = ctrl+a)
--   pane.split.right         ⌘D               prefix %
--   pane.split.down          ⇧⌘D              prefix "
--   pane.split.left          ⇧⌘←              prefix ctrl+%  (tmux: split-window -hb, unbound)
--   pane.split.up            ⇧⌘↑              prefix ctrl+"  (tmux: split-window -vb, unbound)
--   pane.focus.left/down/    ⌥⌘ ← ↓ ↑ →       prefix h / j / k / l
--     up/right
--   pane.zoom                ⌘⇧↩              prefix z
--   pane.close               ⌘W               prefix x
--   pane.balance             ?                prefix =
--   pane.resize              ?                prefix R, then h/j/k/l, escape exits
--   client.tab.new           ⌘T               prefix c
--   client.tab.next          ⌃⇥               prefix n  (shift+right, opt-in)
--   client.tab.previous      ⌃⇧⇥              prefix p  (shift+left, opt-in)
--   client.tab.rename        ?                prefix ,
--   client.tab.goto          ⌘1..9 (all)      prefix 1..9  (this session only)
--   session.switch           ⌘R               prefix s
--   session.rename           ?                prefix $
--   client.config.reload     ⇧⌘R (this file)  prefix r
--
-- Keys found in the app binary but not yet matched to actions (unverified):
--   cmd+[ / cmd+], cmd+shift+arrows, cmd+alt+shift+arrows,
--   ctrl+shift+pageup / pagedown
-- ---------------------------------------------------------------------------

-- ---------------------------------------------------------------------------
-- TMUX: ctrl+a enters the one-shot "prefix" mode, the next key runs its
-- binding and the mode exits. All of these passed `rex config check`.
-- ---------------------------------------------------------------------------
if KEYMAP == "tmux" then
  rex.bind("ctrl+a", "client.mode.enter", { name = "prefix", once = true })

  -- ctrl+a ctrl+a passes a literal ctrl+a through (shell line-start, nested tmux)
  rex.bind("prefix/ctrl+a", "pane.send_key", { key = "ctrl+a" })

  -- splits (tmux: % and "). Rex wants shifted symbols spelled out: % = shift+5, " = shift+' ($ = shift+4)
  rex.bind("prefix/shift+5", "pane.split.right")
  rex.bind("prefix/shift+'", "pane.split.down")
  -- opposite direction: ctrl+% and ctrl+" (tmux has split-window -b for
  -- these but binds no key by default)
  rex.bind("prefix/ctrl+shift+5", "pane.split.left")
  rex.bind("prefix/ctrl+shift+'", "pane.split.up")

  -- pane focus, vim directions
  rex.bind("prefix/h", "pane.focus.left")
  rex.bind("prefix/j", "pane.focus.down")
  rex.bind("prefix/k", "pane.focus.up")
  rex.bind("prefix/l", "pane.focus.right")

  -- pane management
  rex.bind("prefix/z", "pane.zoom")
  rex.bind("prefix/x", "pane.close")
  rex.bind("prefix/=", "pane.balance")

  -- resize: prefix R enters a sticky "resize" mode; hjkl resize, escape exits
  rex.bind("prefix/shift+r", "client.mode.enter", { name = "resize" })
  rex.bind("resize/h", "pane.resize", { direction = "left" })
  rex.bind("resize/j", "pane.resize", { direction = "down" })
  rex.bind("resize/k", "pane.resize", { direction = "up" })
  rex.bind("resize/l", "pane.resize", { direction = "right" })
  rex.bind("resize/escape", "client.mode.exit")

  -- tabs (tmux windows)
  rex.bind("prefix/c", "client.tab.new")
  rex.bind("prefix/n", "client.tab.next")
  rex.bind("prefix/p", "client.tab.previous")
  rex.bind("prefix/,", "client.tab.rename")
  -- prefix 1..9 jumps to that tab of the CURRENT session, like tmux
  -- select-window (counts from 1, like base-index 1 in .tmux.conf).
  -- Not client.tab.goto: like native cmd+1..9 it counts tabs across every
  -- session in the sidebar. Not session.focus_window either: that moves the
  -- server's active window but the app keeps showing the same tab. So look
  -- the tab up in this session's window list (session.view returns them in
  -- tab order) and have the app show it with its session.select action.
  -- A number past the last tab does nothing.
  rex.action {
    name  = "session_tab_goto",
    title = "Go to Tab in This Session",
    args  = { index = "integer" },
    run   = function(ctx, args)
      local view, err = rex.session.view {}
      if err ~= nil then error(err, 0) end
      local w = view.windows[args.index]
      if w == nil then return end
      rex.client.queue("session.select", {
        session_id = ctx.session_id,
        window_id  = w.window_id,
      })
    end,
  }
  for i = 1, 9 do
    rex.bind("prefix/" .. i, "session_tab_goto", { index = i })
  end
  -- left commented even in tmux mode: these steal shift+arrows from the
  -- shell and Neovim (word/selection movement), unlike the prefix bindings
  -- rex.bind("shift+left", "client.tab.previous")
  -- rex.bind("shift+right", "client.tab.next")

  -- sessions
  rex.bind("prefix/s", "session.switch")
  rex.bind("prefix/shift+4", "session.rename") -- tmux: $

  -- config
  rex.bind("prefix/r", "client.config.reload")
end

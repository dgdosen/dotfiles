-- Rex config (symlinked: ~/.config/rex -> ~/.dotfiles/.config/rex)
-- Check:  rex config check     Reload: rex config reload (or prefix r)
-- Inspect resolved keys: rex keymap
--
-- tmux-style prefix: ctrl+a enters the one-shot "prefix" mode, the next
-- key runs its binding and the mode exits. Mirrors .tmux.conf.
--
-- Everything below is commented out on purpose: uncomment a binding once
-- it's actually wanted. All of them passed `rex config check` (2026-10-27).
-- The prefix/* lines only fire if the ctrl+a prefix binding is enabled too.
--
-- Rex does NOT watch this file: after editing, press cmd+shift+r (below)
-- or run `rex config reload`.

-- ACTIVE: reload this config without needing the prefix
rex.bind("cmd+shift+r", "client.config.reload")

-- rex.bind("ctrl+a", "client.mode.enter", { name = "prefix", once = true })

-- ctrl+a ctrl+a passes a literal ctrl+a through (shell line-start, nested tmux)
-- rex.bind("prefix/ctrl+a", "pane.send_key", { key = "ctrl+a" })

-- splits (tmux: | and -). Rex wants shifted symbols spelled out: | = shift+\ ($ = shift+4)
-- rex.bind("prefix/shift+\\", "pane.split.right")
-- rex.bind("prefix/-", "pane.split.down")

-- pane focus, vim directions
-- rex.bind("prefix/h", "pane.focus.left")
-- rex.bind("prefix/j", "pane.focus.down")
-- rex.bind("prefix/k", "pane.focus.up")
-- rex.bind("prefix/l", "pane.focus.right")

-- pane management
-- rex.bind("prefix/z", "pane.zoom")
-- rex.bind("prefix/x", "pane.close")
-- rex.bind("prefix/=", "pane.balance")

-- resize: prefix R enters a sticky "resize" mode; hjkl resize, escape exits
-- rex.bind("prefix/shift+r", "client.mode.enter", { name = "resize" })
-- rex.bind("resize/h", "pane.resize", { direction = "left" })
-- rex.bind("resize/j", "pane.resize", { direction = "down" })
-- rex.bind("resize/k", "pane.resize", { direction = "up" })
-- rex.bind("resize/l", "pane.resize", { direction = "right" })
-- rex.bind("resize/escape", "client.mode.exit")

-- tabs (tmux windows)
-- rex.bind("prefix/c", "client.tab.new")
-- rex.bind("prefix/n", "client.tab.next")
-- rex.bind("prefix/p", "client.tab.previous")
-- rex.bind("prefix/,", "client.tab.rename")
-- rex.bind("shift+left", "client.tab.previous")
-- rex.bind("shift+right", "client.tab.next")

-- sessions
-- rex.bind("prefix/s", "session.switch")
-- rex.bind("prefix/shift+4", "session.rename") -- tmux: $

-- config
-- rex.bind("prefix/r", "client.config.reload")

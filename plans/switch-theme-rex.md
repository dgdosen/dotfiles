# Plan: make `switch-theme` live-update panes under Rex

Status: idea, not started (written 2026-10-29). Current choice: stay on
`kanagawa-dark` everywhere, Rex on dark (`Workspace.appearance = dark`).

## Problem

`.bin/switch-theme` swaps the theme files for Alacritty, Kitty, Ghostty,
Neovim, tmux, lazygit, p10k and Claude Code. Panes that are already open
get the new theme only through tmux:

- Neovim: `tmux list-panes -a` → panes whose command is `nvim` →
  `tmux send-keys` `Escape`, `:set background=…`, `:colorscheme …`
- p10k: panes whose command is `zsh` → `tmux send-keys " source ~/.p10k.zsh"`

Since moving from tmux to Rex (2026-10-27) that path does nothing, so open
shells and Neovim keep the old colors until restarted. Running
`source ~/.p10k.zsh` by hand fixes a shell.

Requirement: sessions/tabs/panes stay open for days, so "pick the theme when
a shell or nvim starts" is not enough. Open panes must update.

## Proposed change

Add a Rex path next to the tmux path in `switch-theme` (keep tmux for when
it's used again). Rex equivalents, all checked against the CLI/API:

| tmux                               | Rex                                                   |
|------------------------------------|-------------------------------------------------------|
| `tmux list-panes -a`               | `rex block ls -A --json` (every block, every session) |
| `#{pane_current_command}`          | `com.superlogical.terminal.process` → `foreground.name` |
| `tmux send-keys -t <pane> …`       | `rex send -b <block> …` / `rex send-key -b <block> …` |

Loop over terminal blocks, read each one's foreground process, then:

- `nvim` → `rex send-key escape`, then send `:set background=light|dark` and
  `:colorscheme <name>` + Enter (same mapping as the tmux branch)
- `zsh` (idle at a prompt) → send ` source ~/.p10k.zsh` + Enter

Gate on `command -v rex` and a reachable server, like the tmux branch gates
on `tmux list-sessions`.

## Caveats

- Keystrokes go to whatever is running. Filtering on the foreground program
  limits this to `nvim` and idle `zsh`, but nvim in a prompt/command-line
  mode could still get stray text (same risk as the tmux version).
- Rex's own colors don't change. Those are an app setting (day/night theme
  IDs in `defaults read com.superlogical.rex`), not a file. There is a
  per-block `terminal.set_theme` API, but it only applies to the block's
  owner (the app), is per-pane, and would fight Rex's own theme, so don't
  use it. Pick the matching Rex theme by hand.

## Remote sessions

The Rex app is often attached to sessions on other machines' Rex servers
(`rex hosts`: dg-mbp-m3p, dg-mm-m4, dg-ms-m5m over Tailscale), sometimes
several at once. The local-only loop above misses those panes in two ways:

1. **Wrong server.** `rex block ls -A` lists blocks on the local server only.
   Remote panes are reached with `rex -S <host> …` per host.
2. **Wrong machine's files.** A remote pane's zsh/nvim run on that machine
   and read its theme state, which is per-machine and gitignored
   (`.p10k-theme`, `.nvim-theme`, `.tmux-theme`, `.claude-theme`). Sending
   ` source ~/.p10k.zsh` to a remote pane just reloads the remote's *old*
   theme. The remote's files have to change first.

Options:

- **(a) Run `switch-theme` on each host (preferred).** Each machine updates
  its own files and then its own Rex server's panes with the local loop
  above. The local run fans out, e.g. `switch-theme X --all-hosts`, over SSH
  (`ssh <host> ~/.dotfiles/.bin/switch-theme X`) or possibly
  `rex -S <host> run -- …`, which runs a command in a new block on that
  machine (untested: it opens a block, so check it closes itself). Skip
  hosts that don't answer. Needs a guard so the remote run doesn't fan out
  again.
- **(b) Push explicit settings, don't touch remote files.** Send
  ` source ~/.dotfiles/.p10k-themes/<theme>.zsh` and nvim `:colorscheme`
  straight to remote panes. Open panes update, but new shells on that
  machine revert to its stored theme. Simpler, but inconsistent.
- Either way, a plain `ssh` inside a *local* pane shows up with foreground
  `ssh`, not zsh/nvim, so it's skipped. That's fine; it's covered when its
  host has its own Rex server.

Also note: `.config/ghostty/current-theme.conf` and
`.config/lazygit/config.yml` are *tracked*, so switching on one machine
shows as a dotfiles change that, once committed, carries to the other
machines, unlike the ignored per-machine files. Worth
deciding whether the theme should be per-machine or shared, and making all
of these files consistent with that choice.

## Related / optional

- **Auto day/night.** Rex can follow macOS appearance by itself. To make
  everything follow it without a background watcher:
  - p10k: zsh `precmd` hook that checks appearance (only when
    `~/Library/Preferences/.GlobalPreferences.plist` mtime changes, via
    `zstat`) and re-sources the light/dark p10k theme.
  - Neovim 0.12: may get background-change notifications from the terminal
    (Ghostty sends them; Rex embeds Ghostty's terminal). Untested: open nvim,
    `:set background?`, flip macOS appearance, check again. If it works, an
    `OptionSet background` autocmd swaps the colorscheme; if not, a timer.
  - Rex's day/night theme pair would need to be themes that have a
    `switch-theme` equivalent. Night was the built-in `oxblood-library`,
    which has none.
  - Dropped for now as too much machinery.
- **Rex theme names.** Imported Ghostty themes show as "Imported Theme N".
  They live in `Workspace.customThemes` (JSON blob in the
  `com.superlogical.rex` defaults); each records its source file
  (`source.ghosttyFile.fileName`), so they can be renamed, but only while
  the Rex app is quit (it overwrites prefs). The unnamed "Imported Theme"
  (`ghosttyMigration`) is kanagawa-dark (bg `#1f1f28`).

# AGENTS

Purpose
- This file guides agentic tooling in this dotfiles repo.
- Prefer existing patterns and keep changes minimal and local.
- Treat this repo as configuration, not an app with a build pipeline.

Scope
- Primary languages: shell (zsh/bash), Lua (Neovim), Ruby config, JSON.
- Most files are config or scripts intended to be sourced or symlinked.

Cursor and Copilot Rules
- No .cursor rules found in .cursor/rules/.
- No .cursorrules file found.
- No .github/copilot-instructions.md found.

Repository Map (high level)
- nvim_dgd/ is the active Neovim config.
- .nvim/, .nvim_sink/, .nvim_lua_kickstart/ are legacy or alternate configs.
- .zsh_customizations/ contains zsh functions, aliases, and utilities.
- setup/ contains bootstrap and symlink helpers.
- daily/ contains cron-style maintenance scripts.
- apps/ contains macOS app bundles and installers.
- .config/ holds app configs (alacritty, karabiner, etc.).

Build, Lint, Test
- There is no unified build system in this repo.
- There is no test suite defined at the root.
- Run scripts directly with their shebangs when needed.

Common maintenance commands
- Link dotfiles: `setup/dot_setup.sh`
- Codespaces bootstrap: `bootstrap.sh`
- Install app wrappers: `apps/install_apps.sh`
- Nightly maintenance: `daily/nightly_update.sh`

Neovim maintenance helpers
- Zsh function `nvimup` is defined in `.zsh_customizations/environment_aliases.sh`.
- If not in a zsh session, run headless directly:
  - `nvim --headless -c "Lazy! sync" +qa`
  - `nvim --headless -c "TSUpdate" +qa`
  - `nvim --headless -c "MasonUpdateAll" +qa`

Submodules
- Zsh helpers `gsm` and `gsp` are in `.zsh_customizations/git_aliases.sh`.
- Equivalent commands:
  - `git submodule foreach git checkout master`
  - `git submodule foreach git pull origin master`

Linting and formatting
- Prettier config is in `.prettierrc`.
- Ruby style config is in `.rubocop.yml` (rubocop required to run).
- There are no dedicated lint scripts; run tools manually when needed.

Single test or single file checks
- No tests exist at repo root; there is no single test runner.
- For Ruby checks on a single file: `rubocop path/to/file.rb`.
- For Prettier on a single file: `prettier --write path/to/file`.

Formatting and whitespace
- Neovim config uses 2-space indentation in Lua.
- Lua config in `nvim_dgd/` sets expandtab with 2 spaces.
- Markdown files are set to 80-character textwidth in Neovim.
- Trailing whitespace is trimmed on save in Neovim config.

JavaScript, JSON, YAML
- Prettier uses single quotes.
- Prettier enforces trailing commas where valid.
- Arrow functions always include parens.

Ruby
- `.rubocop.yml` is present; many cops are disabled.
- Enforced: double quotes for strings in Ruby.
- Enforced: trailing commas for multi-line arrays, hashes, and args.
- Line length target is 80 characters.

Lua (Neovim)
- Use `require('module')` at the top of files.
- Keep module setup in `nvim_dgd/lua/` organized by area.
- Prefer `vim.keymap.set` and `vim.api.nvim_create_autocmd` for keymaps and autocommands.
- Use single quotes for strings unless interpolation is needed.

Shell (zsh and bash)
- Zsh scripts often use `#!/usr/bin/env zsh`.
- Bash scripts use `#!/bin/bash`.
- Quote paths and variables, especially when working with user directories.
- Use `local` in functions for temporary variables.
- Prefer `[[ ... ]]` in zsh over `[ ... ]` when possible.
- Preserve the caller's CWD when a function `cd`s (save and restore).
- Prefer explicit `mkdir -p` and path checks before linking or deleting.
- Use `echo` for simple status messages; avoid noisy debug output.

Line endings and encoding
- Default to ASCII; only add Unicode when the file already uses it.
- Keep LF line endings; avoid mixed newlines.

Types and typing
- No static typing system is enforced in this repo.
- Avoid adding new type checkers or build-time tooling without a clear need.

File organization
- Keep zsh functions in `.zsh_customizations/` rather than `.zshrc`.
- Keep maintenance scripts in `daily/` and setup helpers in `setup/`.
- Prefer editing files in this repo over generated or symlinked targets.

Neovim patterns
- Prefer `vim.opt`/`vim.o` and `vim.g` in option files.
- Autocmds should use `vim.api.nvim_create_autocmd` with named groups.
- Keep plugin specs and config under `nvim_dgd/lua/plugins/`.

Naming conventions
- Function names are typically lowercase with underscores.
- Keep aliases short and action-oriented.
- File names are lowercase with dashes or underscores.

Error handling and safety
- Many scripts are simple and do not use `set -euo pipefail`.
- When adding new scripts, use explicit checks and clear error messages.
- Avoid `rm -rf` unless necessary and scoped to a known path.

Imports and dependencies
- Keep Lua `require` statements grouped near the top.
- Avoid introducing new dependencies without documenting them.

Comments
- Comments are used sparingly; add them only for non-obvious logic.
- Prefer descriptive function and variable names over verbose comments.

Secrets and local data
- This repo includes local environment settings in `.zshrc`.
- Avoid adding new secrets; prefer user-local files or env vars.
- Do not copy private keys or credentials into tracked files.

Theme notes (from CLAUDE.md)
- Theme switching is coordinated across Alacritty, Kitty, Neovim, Tmux, and Powerlevel10k.
- P10k themes use truecolor hex values for catppuccin and gruvbox variants.
- Lazygit config is expected at `.config/lazygit/config.yml` with four themes.

When changing files
- Keep symlink targets aligned with `setup/dot_setup.sh`.
- Prefer editing the source in this repo over generated or linked paths.
- If you touch Neovim config, keep `nvim_dgd/` as the primary target.

What not to assume
- Do not assume Node, Python, or Ruby tooling is installed.
- Do not assume a test runner exists.
- Do not modify unrelated machine-local settings.

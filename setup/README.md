# New Mac Setup

## 1. Install Homebrew

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 2. Clone dotfiles

```
git clone git@github.com:dgdosen/dotfiles.git ~/.dotfiles
```

## 3. Install everything via Brewfile

Sign into the Mac App Store first, then:

```
brew bundle --file=~/.dotfiles/.brew/Brewfile
```

This installs CLI tools, casks, VS Code extensions, Mac App Store apps, and cargo packages.

## 4. Run symlink setup

```
sh ~/.dotfiles/setup/dot_setup.sh
```

Creates all symlinks for zsh, tmux, nvim, alacritty, lazygit, git, karabiner, etc.

## 5. Clone project repos

```
sh ~/.dotfiles/setup/git_setup.sh
```

Clones project_b, sessuru, and exercism repos into `~/dev/`.

## 6. Set up launchd agents

```
sh ~/.dotfiles/setup/launchd_setup.sh
```

Review the script first - comment out agents that should only run on a specific machine (e.g., project_b database agents).

## 7. Post-setup

- **Neovim**: Open nvim and lazy.nvim will auto-install plugins
- **Tmux**: Run `prefix + I` to install TPM plugins
- **Shell**: Restart terminal for zsh/p10k to take effect
- **Ruby**: `rbenv install <version>`
- **Node**: `nodenv install <version>`
- **Claude notify**: `mkdir -p ~/.local/bin && ln -sfnv ~/.dotfiles/.zsh_customizations/claude_notify.sh ~/.local/bin/claude_notify`

## Decisions per machine

- Which launchd agents to run (some may only belong on one machine)
- Whether to set up the Dropbox symlink (`dropboxm`)
- Whether to link `~/.local/share/nvim/sqlua` database connections

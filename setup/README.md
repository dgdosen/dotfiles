# New Mac Setup

Assumes the macOS user is `dgdosen` — launchd plists and some scripts hardcode
`/Users/dgdosen`.

## 0. Set the host name

The Brewfile is picked by `LocalHostName`, so set it first (System Settings →
General → Sharing → Local hostname), or:

```
sudo scutil --set LocalHostName dg-ms-m5m   # whatever this machine is called
```

## 1. Install Homebrew

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## 2. Authenticate to GitHub and clone dotfiles

The clone uses SSH, so a key has to be on GitHub first. `gh auth login` can
generate and upload one (pick SSH when it asks for the git protocol):

```
brew install gh
gh auth login
git clone git@github.com:dgdosen/dotfiles.git ~/.dotfiles
```

## 3. Initialize git submodules

```
cd ~/.dotfiles
git submodule update --init --recursive
```

Only powerlevel10k is a submodule. tmux plugins (TPM) are not in the repo;
`.tmux.conf` clones TPM and installs its plugins on the first tmux start.

## 4. Install Oh My Zsh

`.zshrc` sources `~/.oh-my-zsh/oh-my-zsh.sh`, which isn't in this repo. Install
it without letting it replace `.zshrc` or switch shells:

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
```

## 5. Install Rust/Cargo

```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

## 6. Install everything via Brewfile

Sign into the Mac App Store first, then run the host-aware bundle. It uses a
per-machine file (`Brewfile-<LocalHostName>`) if one exists, otherwise the shared
`Brewfile`:

```
host=$(scutil --get LocalHostName)
file=~/.dotfiles/.brew/Brewfile-$host
[ -f "$file" ] || file=~/.dotfiles/.brew/Brewfile
brew bundle --file="$file"
```

This installs CLI tools, casks, VS Code extensions, Mac App Store apps, and uv tools.

Per-machine files: `Brewfile-dg-mba-m5` (MacBook Air), `Brewfile-dg-ms-m5m`
(seeded from dg-mba-m5), `Brewfile-bighead`, `Brewfile-hendricks`,
`Brewfile-manistee`. The generic `Brewfile` is the shared
fallback for any host without its own file.

## 7. Create machine-specific config

```
cp ~/.dotfiles/.machine.env.template ~/.machine.env
```

Edit `~/.machine.env` to set machine-specific values (Dropbox paths, machine name, etc.). This file is shell-agnostic and gitignored.

## 8. Run symlink setup

```
sh ~/.dotfiles/setup/dot_setup.sh
```

Creates all symlinks for zsh, tmux, nvim, alacritty, lazygit, git, karabiner, etc.

## 9. Clone project repos

```
sh ~/.dotfiles/setup/git_setup.sh
```

Clones project_b, sessuru, and exercism repos into `~/dev/`.

## 10. Set up launchd agents

```
sh ~/.dotfiles/setup/launchd_setup.sh
```

Review the script first and comment out agents that should only run on a specific machine.

Do **not** create `~/.cron_support/dotfiles_primary` here unless this machine is
taking over as the one that commits nightly submodule bumps (currently
dg-mba-m5). Without it, the dotupdate job just pulls.

## 11. Post-setup

- **Neovim**: Open nvim and lazy.nvim will auto-install plugins
- **Tmux**: first start clones TPM + installs plugins; `prefix + I` re-runs the install
- **Shell**: Restart terminal for zsh/p10k to take effect
- **Ruby**: `rbenv install <version>`
- **Node**: `nodenv install <version>`
- **Alacritty**: Build from source: `cd ~/dev/alacritty && cargo build --release`
- **Claude notify**: `mkdir -p ~/.local/bin && ln -sfnv ~/.dotfiles/.zsh_customizations/claude_notify.sh ~/.local/bin/claude_notify`

## Decisions per machine

- Edit `~/.machine.env` for machine-specific paths (Dropbox, etc.)
- Which launchd agents to run (some may only belong on one machine)
- Whether to link `~/.local/share/nvim/sqlua` database connections

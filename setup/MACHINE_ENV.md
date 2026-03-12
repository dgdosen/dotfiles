# Migrating to .machine.env

## What is it?

`~/.machine.env` is a shell-agnostic, per-machine config file that stores values that vary between machines (Dropbox paths, machine name, which launchd agents to run, etc.). It is gitignored and must be created on each machine.

## Setup on a new machine

```
cp ~/.dotfiles/.machine.env.template ~/.machine.env
```

Edit `~/.machine.env` and set values appropriate for this machine.

## Setup on an existing machine

If you're already running dotfiles and just need to add `.machine.env`:

1. Copy the template:
   ```
   cp ~/.dotfiles/.machine.env.template ~/.machine.env
   ```

2. Edit `~/.machine.env` and set your values:
   - `MACHINE_NAME` - a name for this machine
   - `DROPBOX_PERSONAL` - path to personal Dropbox
   - `DROPBOX_BUSINESS` - path to business Dropbox
   - `DROPBOXM_TARGET` - target for the `~/dropboxm` symlink
   - `LAUNCHD_AGENTS` - which agents to run on this machine

3. Pull the latest dotfiles (`.zshrc` now sources `~/.machine.env`)

4. Restart your shell

## Dropbox paths by OS version

Older macOS (Dropbox in home directory):
```
export DROPBOX_PERSONAL="$HOME/Dropbox (Personal)"
export DROPBOX_BUSINESS="$HOME/makerboarding Dropbox/Daniel Dosen"
```

Newer macOS (Dropbox in CloudStorage):
```
export DROPBOX_PERSONAL="$HOME/Library/CloudStorage/Dropbox-Personal"
export DROPBOX_BUSINESS="$HOME/Library/CloudStorage/Dropbox-makerboarding"
```

## Known machine configs

### lincoln (primary workstation)
```
export MACHINE_NAME="lincoln"
export DROPBOX_PERSONAL="$HOME/Dropbox (Personal)"
export DROPBOX_BUSINESS="$HOME/makerboarding Dropbox/Daniel Dosen"
export DROPBOXM_TARGET="$DROPBOX_BUSINESS"
export LAUNCHD_AGENTS="backup brewupdate dotupdate fetch logrotate db dw_db drf_watch quantified_status"
```

## Notes

- `.zshrc` has fallback Dropbox detection if `.machine.env` is missing, so nothing breaks if you haven't migrated yet
- The file uses plain `export KEY=value` syntax, so it works with zsh, bash, or any POSIX shell
- Keep secrets out of this file - it's for paths and machine identity only

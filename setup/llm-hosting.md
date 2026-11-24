# Local LLM Hosting (Mac Studio only)

dg-ms-m5m (M5 Max, 128 GB) runs an always-on local LLM and serves it on the
tailnet. Nothing here belongs on other machines. Engine notes, model choices and
benchmarks live in `~/dev/ds4/CLAUDE.md`; this file covers the machine setup.

## Stack

| Port | Service | launchd label | Script |
|---|---|---|---|
| 8000 | oMLX (Qwen3.8 Flash Next 4bit-mtp) | `com.agidevelopment.omlx_serve` | `daily/omlx_serve.sh` |
| 8081 | Open WebUI | `com.agidevelopment.openwebui_serve` | `daily/openwebui_serve.sh` |
| 8082 | Workbench tools for Open WebUI | `com.agidevelopment.workbench_serve` | `daily/workbench_serve.sh` |
| — | GPU wired limit at boot (LaunchDaemon) | `com.agidevelopment.wired_limit` | — |

`com.agidevelopment.ds4_serve` is the old ds4 server (disabled 2026-10-17). Run
only one of ds4/oMLX. Logs go to `~/log/<name>.{out,err}`.

Tailnet (`setup/tailscale_serve.sh`, run once): `:8443` → raw API on 8000 (no
auth), `:8444` → Open WebUI (per-user logins).

## GPU wired limit

macOS caps how much unified memory the GPU can wire. The default (107.5 GB here)
is too low for the model, and the setting resets on every reboot:

```
sudo sysctl iogpu.wired_limit_mb=122880   # 120 GB; check with: sysctl iogpu.wired_limit_mb
```

oMLX reads it once at startup. Running without it costs ~10% decode speed
(74 vs 84 tok/s, 2026-10-31) and nothing else warns you, so a LaunchDaemon sets
it at boot. LaunchDaemons run as root and must be root-owned copies, not
symlinks, so re-run the install after editing the plist:

```
sudo install -o root -g wheel -m 644 ~/.dotfiles/.launchd/com.agidevelopment.wired_limit.plist /Library/LaunchDaemons/
sudo launchctl bootstrap system /Library/LaunchDaemons/com.agidevelopment.wired_limit.plist
```

(On an edit, `sudo launchctl bootout system/com.agidevelopment.wired_limit`
first.) Errors land in `/var/log/wired_limit.log`. If the limit was raised
after oMLX started, restart oMLX to pick it up.

## Install on a fresh machine

1. Wired-limit daemon (above).
2. `brew install jundot/omlx/omlx`; the model goes in `~/.omlx/models/`, and its
   settings/profiles in `~/.omlx/model_settings.json` and `model_profiles.json`.
3. `uv tool install --python 3.11 open-webui`; workbench needs `bun` and
   `~/.config/workbench/token`.
4. Agents: `launchd_setup.sh` (LLM section) or `launchctl load -w` each plist
   symlinked into `~/Library/LaunchAgents/`.
5. `sh ~/.dotfiles/setup/tailscale_serve.sh`.

## Upgrading oMLX

Unload the agent before `brew upgrade omlx`: the running server keeps the old
version until restarted, and `brew cleanup` deletes the old Cellar from under it.

```
launchctl unload ~/Library/LaunchAgents/com.agidevelopment.omlx_serve.plist
brew upgrade omlx
launchctl load ~/Library/LaunchAgents/com.agidevelopment.omlx_serve.plist
grep 'Cellar/omlx' ~/log/omlx_serve.err | tail -1   # confirm the new version
```

The process is titled `omlx-server`, so `pkill -f "omlx serve"` misses it.

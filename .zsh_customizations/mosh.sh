# mosh firewall helper
#
# WHY THIS EXISTS
# ---------------
# macOS's application firewall keys its allow/block rules on the *resolved*
# binary path. Homebrew installs each mosh version into a fresh dir:
#     /opt/homebrew/Cellar/mosh/<version>/bin/mosh-server
# so every `brew upgrade mosh` produces a brand-new path the firewall treats as
# an unknown app and BLOCKS by default. The ssh handshake still works (TCP 22),
# but mosh's UDP traffic gets dropped -> connections just hang. Classic symptom:
# "mosh won't activate" even though ssh + keys are fine.
#
# Symlinks don't help: the firewall canonicalizes /opt/homebrew/bin/mosh-server
# down to the versioned Cellar path, so you can't pre-allow a stable path. Each
# upgrade also leaves a stale firewall entry pointing at the now-deleted old
# version (harmless clutter).
#
# mosh_firewall_sync() re-allows the CURRENT mosh-server/-client binaries and
# prunes stale entries for versions no longer on disk. It's called at the end of
# brewup() (see environment_aliases.sh).
#
# It is careful about sudo:
#   * It only escalates when a change is actually needed (state reads need no
#     sudo), so normal `brewup` runs with mosh already in sync won't prompt.
#   * It is TTY-aware: interactively it uses plain `sudo` (prompts once);
#     unattended (the nightly launchd brewup) it uses `sudo -n` and skips
#     silently instead of hanging forever on a password prompt with no terminal.
#
# Manual fallback if you ever want to do it by hand:
#     alias firepower='sudo /usr/libexec/ApplicationFirewall/socketfilterfw'
#     firepower --add       "$(readlink -f "$(command -v mosh-server)")"
#     firepower --unblockapp "$(readlink -f "$(command -v mosh-server)")"

# mosh keepalive wrapper
# ----------------------
# WHY THIS EXISTS
# mosh rides a single UDP flow and, when the session is idle, sends only a
# sparse heartbeat. That trickle is not enough to keep a laptop *remote* awake:
# once idle, the remote either sleeps (on battery: pmset sleep=1, womp=0 so it
# won't even wake for UDP) or its Wi-Fi radio drops to power-save and starts
# dropping the inbound UDP -> the session freezes "after a while."
#
# The classic tell: the session stays alive as long as you *also* have an ssh
# connection open to the same host, because ssh's TCP keepalives hold the remote
# awake. Close the ssh session and mosh dies with it.
#
# Fix: have mosh launch its server under `caffeinate -dis`, so mosh-server
# itself holds a power assertion (d=display, i=idle, s=system) for exactly the
# life of the session and releases it on exit. The remote never goes idle, so
# neither system sleep nor Wi-Fi power-save can starve the UDP flow. caffeinate
# lives at /usr/bin/caffeinate (always present) and resolves mosh-server via the
# same PATH the default `mosh` invocation already uses.
#
# Caveat: a laptop remote with the lid physically closed on battery and no
# external power/display will still clamshell-sleep — nothing but power fixes
# that.
mosh() {
  # Respect an explicit --server the caller passed; only inject our default.
  local a
  for a in "$@"; do
    [[ $a == --server=* || $a == --server ]] && { command mosh "$@"; return }
  done
  command mosh --server="caffeinate -dis mosh-server" "$@"
}

mosh_firewall_sync() {
  local fw=/usr/libexec/ApplicationFirewall/socketfilterfw
  [[ -x "$fw" ]] || return 0                                  # macOS only
  command -v mosh-server >/dev/null 2>&1 || return 0          # mosh installed?

  # Firewall off -> nothing to allow.
  "$fw" --getglobalstate 2>/dev/null | grep -q enabled || return 0

  # Resolve current binaries (follow homebrew symlinks to real Cellar paths).
  local server client
  server=$(readlink -f "$(command -v mosh-server)" 2>/dev/null)
  client=$(readlink -f "$(command -v mosh-client)" 2>/dev/null)

  local listing
  listing=$("$fw" --listapps 2>/dev/null)

  # --- Decide what needs doing, WITHOUT sudo (listapps reads are unprivileged) ---

  # Stale: firewall entries for mosh Cellar binaries that no longer exist on disk.
  local -a to_remove=()
  local path
  while IFS= read -r path; do
    [[ -n "$path" && ! -e "$path" ]] && to_remove+=("$path")
  done < <(print -r -- "$listing" \
             | grep -oE '/[^ ]*/Cellar/mosh/[^ ]*/bin/mosh-(server|client)')

  # Allowed? entry for $1 exists in $listing and its status line says "Allow".
  # NB: awk's `exit` runs the END block first, so we set a flag in the match and
  # decide the exit code once in END (an `exit 0` mid-rule would otherwise be
  # overridden by an `exit 1` in END).
  _mosh_fw_allowed() {
    print -r -- "$listing" \
      | awk -v b="$1" 'index($0,b){getline; if ($0 ~ /Allow/) f=1} END{exit f?0:1}'
  }

  local needs_allow=0
  [[ -n "$server" ]] && ! _mosh_fw_allowed "$server" && needs_allow=1
  [[ -n "$client" ]] && ! _mosh_fw_allowed "$client" && needs_allow=1

  (( ${#to_remove} == 0 && needs_allow == 0 )) && return 0    # already in sync

  # --- Something to do: choose sudo mode (TTY-aware so cron never hangs) ---
  local -a SUDO
  if [[ -t 0 ]]; then
    SUDO=(sudo)
    echo "🔧 mosh: syncing firewall rules (may prompt for your password)…"
  else
    SUDO=(sudo -n)                                            # unattended
  fi

  # Confirm we can sudo; in -n mode this fails fast rather than hanging.
  if ! "${SUDO[@]}" -v 2>/dev/null; then
    [[ -t 0 ]] && echo "⚠️  mosh: firewall sync skipped (sudo unavailable)."
    return 0
  fi

  local p
  for p in "${to_remove[@]}"; do
    echo "  🗑️  mosh: removing stale firewall entry -> $p"
    "${SUDO[@]}" "$fw" --remove "$p" >/dev/null 2>&1
  done
  if (( needs_allow )); then
    for p in "$server" "$client"; do
      [[ -n "$p" ]] || continue
      "${SUDO[@]}" "$fw" --add       "$p" >/dev/null 2>&1
      "${SUDO[@]}" "$fw" --unblockapp "$p" >/dev/null 2>&1
    done
    echo "  ✅ mosh: allowed current binaries through firewall"
  fi
}

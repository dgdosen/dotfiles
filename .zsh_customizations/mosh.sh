# mosh firewall helper
#
# WHY THIS EXISTS
# ---------------
# macOS's application firewall blocks mosh's UDP traffic whenever mosh-server
# is not explicitly allowed. Homebrew installs each version into a fresh dir:
#     /opt/homebrew/Cellar/mosh/<version>/bin/mosh-server
# and exposes a stable symlink at /opt/homebrew/bin/mosh-server. Empirically
# (recent macOS: Sequoia / Tahoe) the firewall does NOT reliably canonicalize
# that symlink to the Cellar path — allowing only the Cellar path leaves the
# ssh handshake working (TCP 22) while mosh's UDP is silently dropped:
# "nothing received from server on UDP port…". Turning the firewall off with
# `socketfilterfw --setglobalstate off` makes it connect immediately, which is
# how we confirmed the diagnosis.
#
# Fix: allow BOTH the stable symlink AND the resolved Cellar path. Each brew
# upgrade also leaves a stale firewall entry pointing at the now-deleted old
# Cellar path (harmless clutter, pruned below).
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
#
# PER-MACHINE SETUP (one-time, per Mac): grant NOPASSWD sudo for the firewall
# binary so the nightly launchd brewup can actually run the sync. Without this,
# the unattended path takes the `sudo -n` branch below, fails silently, and the
# newly-upgraded mosh-server is left blocked -> next mosh attempt triggers the
# macOS "Allow incoming connections?" dialog.
#
# Install with:
#     sudo visudo -f /etc/sudoers.d/mosh-firewall
# and add exactly this one line (replace <user> with your login):
#     <user> ALL=(root) NOPASSWD: /usr/libexec/ApplicationFirewall/socketfilterfw
#
# Scope is intentionally narrow: passwordless sudo is granted for that one
# Apple-signed binary only; it can modify the app firewall allowlist and
# nothing else. Not tracked in dotfiles (sudoers.d is host-local).

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
  # Use absolute paths for grep/awk: the nightly launchd brewup runs with a
  # minimal PATH that may not include /usr/bin, and both live there on macOS.
  "$fw" --getglobalstate 2>/dev/null | /usr/bin/grep -q enabled || return 0

  # Collect both the stable symlink (as PATH resolves it) AND the resolved
  # Cellar path — the firewall doesn't reliably follow the symlink, so we
  # allow both. Deduped in case PATH already points straight at the Cellar.
  local server_link client_link server_real client_real
  server_link=$(command -v mosh-server 2>/dev/null)
  client_link=$(command -v mosh-client 2>/dev/null)
  server_real=$(readlink -f "$server_link" 2>/dev/null)
  client_real=$(readlink -f "$client_link" 2>/dev/null)
  local -aU binaries=()
  [[ -n "$server_link" ]] && binaries+=("$server_link")
  [[ -n "$server_real" && "$server_real" != "$server_link" ]] && binaries+=("$server_real")
  [[ -n "$client_link" ]] && binaries+=("$client_link")
  [[ -n "$client_real" && "$client_real" != "$client_link" ]] && binaries+=("$client_real")

  local listing
  listing=$("$fw" --listapps 2>/dev/null)

  # --- Decide what needs doing, WITHOUT sudo (listapps reads are unprivileged) ---

  # Stale: firewall entries for mosh Cellar binaries that no longer exist on disk.
  local -a to_remove=()
  local path
  while IFS= read -r path; do
    [[ -n "$path" && ! -e "$path" ]] && to_remove+=("$path")
  done < <(print -r -- "$listing" \
             | /usr/bin/grep -oE '/[^ ]*/Cellar/mosh/[^ ]*/bin/mosh-(server|client)')

  # Allowed? entry for $1 exists in $listing and its status line says "Allow".
  # NB: awk's `exit` runs the END block first, so we set a flag in the match and
  # decide the exit code once in END (an `exit 0` mid-rule would otherwise be
  # overridden by an `exit 1` in END).
  _mosh_fw_allowed() {
    print -r -- "$listing" \
      | /usr/bin/awk -v b="$1" 'index($0,b){getline; if ($0 ~ /Allow/) f=1} END{exit f?0:1}'
  }

  local -a to_allow=()
  local b
  for b in "${binaries[@]}"; do
    _mosh_fw_allowed "$b" || to_allow+=("$b")
  done

  (( ${#to_remove} == 0 && ${#to_allow} == 0 )) && return 0   # already in sync

  # --- Something to do: choose sudo mode ---
  # Probe with the actual firewall binary (a read-only subcommand), not `sudo
  # -v`. The per-machine NOPASSWD rule is scoped to socketfilterfw; `sudo -v`
  # asks for general sudo credentials that rule doesn't grant, so it would
  # spuriously prompt (or fail unattended) even when NOPASSWD is set up.
  local -a SUDO
  if sudo -n "$fw" --getglobalstate >/dev/null 2>&1; then
    SUDO=(sudo -n)                                            # NOPASSWD works
  elif [[ -t 0 ]]; then
    SUDO=(sudo)                                               # will prompt
    echo "🔧 mosh: syncing firewall rules (may prompt for your password)…"
  else
    return 0                                                  # unattended, no NOPASSWD
  fi

  local p
  for p in "${to_remove[@]}"; do
    echo "  🗑️  mosh: removing stale firewall entry -> $p"
    "${SUDO[@]}" "$fw" --remove "$p" >/dev/null 2>&1
  done
  if (( ${#to_allow} )); then
    for p in "${to_allow[@]}"; do
      echo "  ➕ mosh: allowing $p"
      "${SUDO[@]}" "$fw" --add       "$p" >/dev/null 2>&1
      "${SUDO[@]}" "$fw" --unblockapp "$p" >/dev/null 2>&1
    done
    echo "  ✅ mosh: allowed current binaries through firewall"
  fi
}

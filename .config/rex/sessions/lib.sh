# Shared helpers for Rex session scripts (smug replacements).
# Sourced by the per-session scripts in this folder; run them via `rexs NAME`.
#
# Panes start as login shells and commands are typed into them (like smug),
# so ctrl+c on e.g. `rails s` leaves you at a prompt instead of closing the pane.
#
#   session NAME           switch to NAME if it already exists (and exit), else start building it
#   tab LABEL DIR [CMD]    new tab; its first pane is stored in $main
#   split FROM DIR PCT [CMD]
#                          split pane FROM toward DIR (right/left/above/below), new
#                          pane gets PCT% of the space; new pane id stored in $pane
#   finish [PANE]          focus PANE (default: first tab's main pane) and show the session

set -euo pipefail

_rex_session=""
_rex_first=""
_rex_cwd=""

# Rex app on this Mac (local unix connection), used to bring the session on screen
_rex_local_app() {
  rex client ls --json | jq -r \
    '.clients[] | select(.info.kind == "app" and .principal.transport == "unix" and .connection_state == "connected") | .client_id' | tail -1
}

# Switching the app's view needs Rex Settings > Rex Server > Remote Control on;
# without it the session is still built, just not brought to the front.
_rex_show() {
  local client
  client=$(_rex_local_app)
  if [[ -z "$client" ]] || ! rex -C "$client" do session.select session_id="$1" >/dev/null 2>&1; then
    echo "rex session '$_rex_name' is ready; select it in Rex's session list"
    echo "(to auto-switch: Rex Settings > Rex Server > Remote Control)"
  fi
}

_rex_type() { # _rex_type PANE CMD: type CMD + enter into PANE
  [[ -n "${2:-}" ]] && rex send -s "$_rex_session" -b "$1" "$2"$'\r'
  return 0
}

session() {
  _rex_name="$1"
  local existing
  existing=$(rex ls --json | jq -r --arg n "$1" '.sessions[] | select(.label == $n) | .session_id' | head -1)
  if [[ -n "$existing" ]]; then
    echo "rex session '$1' already exists, not rebuilding it"
    _rex_show "$existing"
    exit 0
  fi
}

tab() {
  local label="$1" dir="$2" cmd="${3:-}" out
  _rex_cwd="$dir"
  if [[ -z "$_rex_session" ]]; then
    out=$(rex new "$_rex_name" -c "$dir" --window "$label" --json)
    _rex_session=$(jq -r .session_id <<<"$out")
    main=$(jq -r '.initial_windows[0].block_ids[0]' <<<"$out")
    _rex_first="$main"
  else
    out=$(rex window new -s "$_rex_session" "$label" -c "$dir" --focus=false --json)
    main=$(jq -r '.block_ids[0]' <<<"$out")
  fi
  _rex_type "$main" "$cmd"
}

split() {
  local from="$1" dir="$2" pct="$3" cmd="${4:-}"
  pane=$(rex split -s "$_rex_session" -b "$from" --split="$dir" --ratio "$pct" \
    -c "$_rex_cwd" --focus=false --json | jq -r '.block_ids[0]')
  _rex_type "$pane" "$cmd"
}

finish() {
  rex focus -s "$_rex_session" "${1:-$_rex_first}" >/dev/null
  _rex_show "$_rex_session"
}

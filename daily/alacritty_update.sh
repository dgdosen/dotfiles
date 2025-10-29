#!/usr/local/bin/zsh
set -euo pipefail

# Config
REPO="$HOME/dev/alacritty"
INSTALL_DIR="$HOME/Applications"     # change to /Applications if you prefer (then use sudo on copy)
TRACK="release"                      # "release" for latest tag, or "master" to follow the master branch
DO_RUST_UPDATE="auto"               # "auto" = do nothing unless build fails; "always" = rustup update stable first
DEFAULT_BRANCH="master"             # Alacritty uses "master" as default branch

# Helpers
notify() {
  /usr/bin/osascript -e "display notification \"$1\" with title \"Alacritty Update\""
}

ensure_tools() {
  command -v git >/dev/null || { echo "git not found"; exit 1; }
  command -v cargo >/dev/null || { echo "cargo (Rust) not found"; exit 1; }
  command -v rustup >/dev/null || { echo "rustup not found"; exit 1; }
  command -v make >/dev/null || { echo "make not found"; exit 1; }
}

current_app_version() {
  local app="$INSTALL_DIR/Alacritty.app/Contents/Info.plist"
  if [[ -f "$app" ]]; then
    /usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$app" 2>/dev/null || true
  fi
}

latest_release_tag() {
  git tag --list --sort=-version:refname 'v*' | head -n1
}

build_and_install() {
  # macOS app bundle build
  make app
  local src="target/release/osx/Alacritty.app"
  [[ -d "$src" ]] || { echo "Build succeeded but app bundle not found at $src"; exit 1; }
  mkdir -p "$INSTALL_DIR"
  rm -rf "$INSTALL_DIR/Alacritty.app"
  cp -R "$src" "$INSTALL_DIR/"

  # Symlink the binary to /usr/local/bin for CLI access
  local bin_path="$INSTALL_DIR/Alacritty.app/Contents/MacOS/alacritty"
  if [[ -f "$bin_path" ]]; then
    sudo ln -sf "$bin_path" /usr/local/bin/alacritty
    echo "Symlinked alacritty to /usr/local/bin/alacritty"
  fi
  touch ~/.cron_support/alacrity_update.txt

}

maybe_update_rust() {
  if [[ "$DO_RUST_UPDATE" == "always" ]]; then
    rustup update stable
  fi
}

main() {
  ensure_tools
  mkdir -p "$INSTALL_DIR"

  if [[ ! -d "$REPO/.git" ]]; then
    echo "Repo not found at $REPO"
    exit 1
  fi

  cd "$REPO"

  echo "Fetching..."
  git fetch --tags origin
  git fetch origin "$DEFAULT_BRANCH"

  local target_ref=""
  if [[ "$TRACK" == "release" ]]; then
    target_ref="$(latest_release_tag)"
    [[ -n "$target_ref" ]] || { echo "No tags found"; exit 1; }
  else
    target_ref="origin/$DEFAULT_BRANCH"
  fi

  # Determine currently installed version (for release mode)
  local installed_ver
  installed_ver="$(current_app_version || true)"

  # Determine target version string
  local target_ver="$target_ref"
  if [[ "$TRACK" != "release" ]]; then
    target_ver="$(git rev-parse --short "$target_ref")"
  fi

  if [[ "$TRACK" == "release" && -n "$installed_ver" && "$installed_ver" == "${target_ref#v}" ]]; then
    echo "Alacritty is up to date (installed $installed_ver, latest ${target_ref})."
    exit 0
  fi

  echo "Checking out $target_ref..."
  git checkout --detach "$target_ref"

  maybe_update_rust

  echo "Building..."
  if ! build_and_install; then
    if [[ "$DO_RUST_UPDATE" == "auto" ]]; then
      echo "Build failed; trying rustup update stable and rebuilding..."
      rustup update stable
      build_and_install
    else
      exit 1
    fi
  fi

  # Restore previous branch (optional)
  git checkout -

  local new_ver
  new_ver="$(current_app_version || echo "$target_ver")"
  echo "Installed Alacritty $new_ver to $INSTALL_DIR/Alacritty.app"
  notify "Updated to $new_ver"
}

main

#!/bin/bash
#
# SwiftBar/xbar plugin for worktree-census. The "5m" in the filename tells
# SwiftBar to refresh every 5 minutes. It just runs the compiled viewer binary,
# which reads the iCloud snapshot folder and prints the menu.
#
# <xbar.title>Worktree Census</xbar.title>
# <xbar.desc>Surfaces hidden WIP (uncommitted/unpushed work) across machines, aged oldest-first.</xbar.desc>
# <xbar.author>quantifiedflow</xbar.author>
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>

# Path to the compiled viewer. Override with WORKTREE_CENSUS_VIEWER if you
# install it elsewhere. Build with: go build -o "$BIN" ./cmd/viewer
BIN="${WORKTREE_CENSUS_VIEWER:-$HOME/.local/bin/worktree-census-viewer}"

if [ ! -x "$BIN" ]; then
  echo "🗂 ⚠"
  echo "---"
  echo "viewer binary not found | color=red"
  echo "Expected at: $BIN"
  echo "Build it: go build -o $BIN ./cmd/viewer | color=gray"
  exit 0
fi

exec "$BIN"

#!/usr/bin/env zsh
# Install and start launchd agents on this machine.
#
# Uses launchctl directly (no lunchy dependency). What `lunchy install` did was
# symlink the plist into ~/Library/LaunchAgents/ and then `launchctl load -w` it;
# `install_agent` below does the same, and `start_agent` triggers an immediate
# run without waiting for the calendar interval.
#
# Safe to re-run: `ln -sf` overwrites the symlink, and `launchctl load` on an
# already-loaded job is a no-op (prints a harmless "already loaded" warning).

set -u

LAUNCHAGENTS_DIR="$HOME/Library/LaunchAgents"
PLIST_DIR="$HOME/.dotfiles/.launchd"
mkdir -p "$LAUNCHAGENTS_DIR"

install_agent() {
  local label="$1"
  local src="$PLIST_DIR/${label}.plist"
  local dst="$LAUNCHAGENTS_DIR/${label}.plist"
  ln -sf "$src" "$dst"
  launchctl load -w "$dst"
}

start_agent() {
  launchctl start "$1"
}

# General/System
install_agent com.agidevelopment.backup
install_agent com.agidevelopment.brewupdate
install_agent com.agidevelopment.dotupdate
install_agent com.agidevelopment.fetch
install_agent com.agidevelopment.logrotate
install_agent com.agidevelopment.touch

# Quantified Flow
install_agent com.quantifiedflow.quantified_status

# Claude morning kickoff (opens 5-hour usage window at 05:00)
install_agent com.agidevelopment.claude_morning

start_agent com.agidevelopment.backup
start_agent com.agidevelopment.brewupdate
start_agent com.agidevelopment.dotupdate
start_agent com.agidevelopment.fetch
start_agent com.agidevelopment.logrotate
start_agent com.agidevelopment.touch

start_agent com.quantifiedflow.quantified_status

start_agent com.agidevelopment.claude_morning

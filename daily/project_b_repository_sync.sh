#!/bin/bash

# Canonical share anchor: ~/project_b_share symlink (was a hardcoded
# "makerboarding Dropbox/Daniel Dosen/..." base that differs per machine).
DROPBOX_BASE="$HOME/project_b_share/repositories"

# Add repos here as needed
rsync -av --delete \
  --exclude '.git' \
  --exclude '.env' \
  --exclude '.dist' \
  --exclude 'node_modules' \
  --exclude 'log' \
  --exclude 'tmp' \
  --exclude '.claude' \
  /Users/dgdosen/dev/project_b_ai_handicapping/ \
  "$DROPBOX_BASE/project_b_ai_handicapping/"

rsync -av --delete \
  --exclude '.git' \
  --exclude '.env' \
  --exclude '.dist' \
  --exclude 'node_modules' \
  --exclude 'log' \
  --exclude 'tmp' \
  --exclude '.claude' \
  /Users/dgdosen/dev/project_b_api/ \
  "$DROPBOX_BASE/project_b/"

rsync -av --delete \
  --exclude '.git' \
  --exclude '.env' \
  --exclude '.dist' \
  --exclude 'node_modules' \
  --exclude 'log' \
  --exclude 'tmp' \
  --exclude '.claude' \
  /Users/dgdosen/dev/project_b_data_2023/ \
  "$DROPBOX_BASE/project_b_data_2023/"

rsync -av --delete \
  --exclude '.git' \
  --exclude '.env' \
  --exclude '.dist' \
  --exclude 'node_modules' \
  --exclude 'log' \
  --exclude 'tmp' \
  --exclude '.claude' \
  /Users/dgdosen/dev/project_b_data/ \
  "$DROPBOX_BASE/project_b_data/"



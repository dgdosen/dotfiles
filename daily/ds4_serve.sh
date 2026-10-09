#!/usr/bin/env zsh
# Always-on local LLM: Qwen3.8 Flash Next Q4 on ds4-server (127.0.0.1:8000).
# Run by com.agidevelopment.ds4_serve. To use another model, stop the agent first:
#   launchctl unload ~/Library/LaunchAgents/com.agidevelopment.ds4_serve.plist

DS4_DIR="$HOME/dev/ds4"
MODEL="$DS4_DIR/gguf/Qwen3.8-Flash-Next-Q4.gguf"

cd "$DS4_DIR" || exit 1
mkdir -p "$HOME/.ds4/kvcache"

exec ./ds4-server -m "$MODEL" \
  --ctx 262144 \
  --mtp \
  --kv-disk-dir "$HOME/.ds4/kvcache" \
  --kv-disk-space-mb 16384

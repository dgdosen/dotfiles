#!/usr/bin/env zsh
# Always-on local LLM: Qwen3.8 Flash Next 4bit on oMLX (127.0.0.1:8000).
# Run by com.agidevelopment.omlx_serve. Replaces com.agidevelopment.ds4_serve
# (switched 2026-10-17); run only one of the two. Model settings, alias
# (qwen3.8-flash-next) and :chat/:reasoner profiles live in ~/.omlx/.
# To use another model, stop the agent first:
#   launchctl unload ~/Library/LaunchAgents/com.agidevelopment.omlx_serve.plist

exec /opt/homebrew/bin/omlx serve \
  --host 127.0.0.1 \
  --port 8000 \
  --paged-ssd-cache-max-size 64GB

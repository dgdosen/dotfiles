#!/usr/bin/env zsh
# Always-on local LLM on ds4-server (127.0.0.1:8000), run by com.agidevelopment.ds4_serve.
# Run only one of this agent and com.agidevelopment.omlx_serve. To stop:
#   launchctl unload ~/Library/LaunchAgents/com.agidevelopment.ds4_serve.plist
#
# 2026-11-11: trial of DeepSeek V4.1 Flash 1017 Q2 (341 GiB file, 152 GiB main
# weights > 128 GB RAM, so --ssd-streaming; expert cache sized automatically).
# Model IDs: deepseek-v4.1-flash, plus deepseek-chat (thinking off) and
# deepseek-reasoner (thinking on). V4.1 requires --power 100 (the default).
# Previous Qwen setup is kept below; swap the MODEL/KV_DIR/ARGS blocks to go back.

DS4_DIR="$HOME/dev/ds4"

# --- DeepSeek V4.1 Flash Q2 (SSD streaming) ---
MODEL="$DS4_DIR/gguf/DeepSeek-V4.1-Flash-1017-IQ2_XXS-Q2_K-imatrix.gguf"
KV_DIR="$HOME/.ds4/kvcache-v41"
ARGS=(--ssd-streaming --ctx 32768)

# --- Qwen3.8 Flash Next Q4 (resident) ---
# MODEL="$DS4_DIR/gguf/Qwen3.8-Flash-Next-Q4.gguf"
# KV_DIR="$HOME/.ds4/kvcache"
# ARGS=(--ctx 262144 --mtp)

cd "$DS4_DIR" || exit 1
mkdir -p "$KV_DIR"

exec ./ds4-server -m "$MODEL" \
  "${ARGS[@]}" \
  --kv-disk-dir "$KV_DIR" \
  --kv-disk-space-mb 16384

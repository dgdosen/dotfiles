#!/usr/bin/env zsh
# ChatGPT-style web UI (Open WebUI) for the local LLM, on 127.0.0.1:8081.
# Run by com.agidevelopment.openwebui_serve. Mac Studio only.
# Talks to oMLX (com.agidevelopment.omlx_serve) at 127.0.0.1:8000; shared on
# the tailnet at https://dg-ms-m5m.hornbill-nessie.ts.net:8444 (see
# ~/.dotfiles/setup/tailscale_serve.sh). Users, chats and uploads live in
# DATA_DIR. First account created is admin; later sign-ups wait as "pending"
# until approved in Admin Panel > Users.
# Install/upgrade: uv tool install --python 3.11 open-webui / uv tool upgrade open-webui

export DATA_DIR=$HOME/.open-webui
export WEBUI_URL=https://dg-ms-m5m.hornbill-nessie.ts.net:8444
export OPENAI_API_BASE_URL=http://127.0.0.1:8000/v1
export OPENAI_API_KEY=local
export ENABLE_OLLAMA_API=false
export DEFAULT_USER_ROLE=pending
export SCARF_NO_ANALYTICS=true DO_NOT_TRACK=true ANONYMIZED_TELEMETRY=false

mkdir -p "$DATA_DIR"
cd "$DATA_DIR"   # .webui_secret_key is written to the cwd; keep it with the data

exec $HOME/.local/bin/open-webui serve --host 127.0.0.1 --port 8081

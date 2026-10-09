#!/usr/bin/env zsh
# Share local services over the tailnet with `tailscale serve`. Mac Studio only.
#
# Run once per machine: Tailscale stores the serve config in its own state and
# restores it after reboots, so this is not a login/launchd job. Safe to re-run.
#
#   tailscale serve status            # show what this machine shares
#   tailscale serve --https=8443 off  # stop sharing the LLM
#
# Services:
#   :8443  ds4 LLM (com.agidevelopment.ds4_serve on 127.0.0.1:8000)
#          https://dg-ms-m5m.hornbill-nessie.ts.net:8443/v1

set -eu

TS=/Applications/Tailscale.app/Contents/MacOS/Tailscale
command -v tailscale >/dev/null 2>&1 && TS=tailscale

"$TS" serve --bg --https=8443 http://127.0.0.1:8000
"$TS" serve status

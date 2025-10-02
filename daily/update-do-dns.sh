#!/usr/bin/env bash
set -euo pipefail

# load secrets
source "$HOME/.do-dns.env"

LOG_DIR="$HOME/Library/Logs"
LOG_FILE="$LOG_DIR/update-dodns.out.log"
CACHE_RECORD_ID="$HOME/.do-dns.record_id"
CACHE_IP="$HOME/.do-dns.last_ip"

mkdir -p "$LOG_DIR"

# absolute curl; auto-detect jq in common locations
CURL="/usr/bin/curl"
JQ="$(command -v jq || true)"
if [[ -z "${JQ:-}" ]]; then
  for p in /opt/homebrew/bin/jq /usr/local/bin/jq; do
    [[ -x "$p" ]] && JQ="$p" && break
  done
fi
if [[ -z "${JQ:-}" ]]; then
  echo "$(date -u) ERROR: jq not found; install with 'brew install jq'" | tee -a "$LOG_FILE"
  exit 1
fi

# get current public ip
IP="$($CURL -s ifconfig.me)"
if [[ -z "$IP" ]]; then
  echo "$(date -u) ERROR: could not determine public IP" | tee -a "$LOG_FILE"
  exit 1
fi

# skip update if IP unchanged
if [[ -f "$CACHE_IP" ]] && [[ "$(cat "$CACHE_IP")" == "$IP" ]]; then
  echo "$(date -u) No change ($IP)" >> "$LOG_FILE"
  exit 0
fi

# get or cache the record id
if [[ -f "$CACHE_RECORD_ID" ]]; then
  RECORD_ID="$(cat "$CACHE_RECORD_ID")"
else
  RECORD_ID="$($CURL -s -X GET \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $DO_TOKEN" \
    "https://api.digitalocean.com/v2/domains/$DO_DOMAIN/records" \
    | "$JQ" -r ".domain_records[] | select(.type==\"A\" and .name==\"$DO_RECORD_NAME\") | .id")"
  if [[ -z "${RECORD_ID:-}" || "$RECORD_ID" == "null" ]]; then
    echo "$(date -u) ERROR: A record $DO_RECORD_NAME.$DO_DOMAIN not found. Create it once in DO first." | tee -a "$LOG_FILE"
    exit 1
  fi
  echo "$RECORD_ID" > "$CACHE_RECORD_ID"
fi

# update the A record if needed
RESP="$($CURL -s -X PUT \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $DO_TOKEN" \
  -d "{\"data\":\"$IP\"}" \
  "https://api.digitalocean.com/v2/domains/$DO_DOMAIN/records/$RECORD_ID")"

# quick sanity: ensure response carries the IP we set
SET_IP="$(echo "$RESP" | "$JQ" -r '.domain_record.data // empty')"
if [[ "$SET_IP" == "$IP" ]]; then
  echo "$IP" > "$CACHE_IP"
  echo "$(date -u) Updated $DO_RECORD_NAME.$DO_DOMAIN → $IP" >> "$LOG_FILE"
  exit 0
else
  echo "$(date -u) ERROR: update failed; response: $RESP" | tee -a "$LOG_FILE"
  exit 1
fi

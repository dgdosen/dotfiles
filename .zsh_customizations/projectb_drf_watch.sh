#!/bin/bash
# Script to log files arriving in the DRF dropoff folder
# NOTE: this shouldn't be needed - use this to debug any DRF issues.

WATCH_DIR="/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/dropoff_drf_zips/to_be_processed"
LOG_FILE="/Users/dgdosen/log/projectb_drf.log"

# Process all files in the queue directory
for file in "$WATCH_DIR"/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        timestamp=$(date "+%Y-%m-%d %H:%M:%S")
        echo "$timestamp - File added: $filename" >> "$LOG_FILE"
    fi
done

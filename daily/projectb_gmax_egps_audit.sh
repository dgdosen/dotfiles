#!/usr/bin/env zsh
source ~/.zshrc

# Lock file to prevent multiple instances
LOCKFILE="$HOME/.cron_support/projectb_gmax_egps_audit.lock"

# Check if another instance is running
if [ -f "$LOCKFILE" ]; then
    OLD_PID=$(cat "$LOCKFILE" 2>/dev/null)
    if [ -n "$OLD_PID" ] && kill -0 "$OLD_PID" 2>/dev/null; then
        echo "Another instance is already running (PID $OLD_PID). Exiting."
        exit 0
    else
        echo "Removing stale lock file (PID $OLD_PID no longer running)."
        rm -f "$LOCKFILE"
    fi
fi

# Create lock file with current PID
echo $$ > "$LOCKFILE"

# Ensure lock file is removed on exit (normal or error)
trap "rm -f $LOCKFILE" EXIT INT TERM

echo "=================================================="
echo "Project B GMAX/EGPS Audit Processing"
echo "Started: $(date)"
echo "=================================================="

cd $HOME/dev/project_b_equibase_scrape_cli
echo ""
echo "[EGPS] Starting EGPS audit processing..."

echo "[EGPS] Run 1/3: Processing new files..."
yarn dev -d "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/egps/to_be_processed" -p "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/egps/to_be_reprocessed"
echo "[EGPS] ✓ Run 1 completed at $(date '+%H:%M:%S')"

echo "[EGPS] Run 2/3: Processing new files..."
yarn dev -d "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/egps/to_be_processed" -p "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/egps/to_be_reprocessed"
echo "[EGPS] ✓ Run 2 completed at $(date '+%H:%M:%S')"

echo "[EGPS] Run 3/3: Processing new files..."
yarn dev -d "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/egps/to_be_processed" -p "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/egps/to_be_reprocessed"
echo "[EGPS] ✓ Run 3 completed at $(date '+%H:%M:%S')"

echo "[EGPS] Final: Moving reprocessed files to processed..."
yarn dev -d "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/egps/to_be_reprocessed" -p "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/egps/processed" -r
echo "[EGPS] ✓ All EGPS processing completed"

echo ""
echo "--------------------------------------------------"
cd $HOME/dev/project_b_gmax_scrape_cli
echo "[GMAX] Starting GMAX audit processing..."

echo "[GMAX] Run 1/3: Processing new files..."
yarn dev -d "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/gmax/to_be_processed" -p "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/gmax/to_be_reprocessed"
echo "[GMAX] ✓ Run 1 completed at $(date '+%H:%M:%S')"

echo "[GMAX] Run 2/3: Processing new files..."
yarn dev -d "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/gmax/to_be_processed" -p "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/gmax/to_be_reprocessed"
echo "[GMAX] ✓ Run 2 completed at $(date '+%H:%M:%S')"

echo "[GMAX] Run 3/3: Processing new files..."
yarn dev -d "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/gmax/to_be_processed" -p "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/gmax/to_be_reprocessed"
echo "[GMAX] ✓ Run 3 completed at $(date '+%H:%M:%S')"

echo "[GMAX] Final: Moving reprocessed files to processed..."
yarn dev -d "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/gmax/to_be_reprocessed" -p "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/gmax/processed" -r
echo "[GMAX] ✓ All GMAX processing completed"

echo ""
echo "=================================================="
echo "All audit processing completed: $(date)"
echo "=================================================="

touch ~/.cron_support/cron_projectb_gmax_egps_audit.txt

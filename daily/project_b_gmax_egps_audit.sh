#!/usr/bin/env zsh
source ~/.zshrc

# Lock file to prevent multiple instances
LOCKFILE="$HOME/.cron_support/project_b_gmax_egps_audit.lock"

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

# CLIs are invoked with `bun src/index.ts` (host has bun at /opt/homebrew/bin).
# This is exactly what each repo's `dev` script runs — `"dev": "bun src/index.ts"` —
# so behavior is unchanged. Was `yarn dev`, but yarn is a node program gated by
# nodenv, and these repos pin a node version that isn't installed, so `yarn dev`
# died at the shim before bun ever started. Calling bun directly skips yarn+nodenv.

cd $HOME/dev/project_b_equibase_scrape_cli
echo ""
echo "[EGPS] Starting EGPS audit processing..."

echo "[EGPS] Run 1/3: Processing new files..."
bun src/index.ts -d "$HOME/project_b_share/documents/audits/egps/to_be_processed" -p "$HOME/project_b_share/documents/audits/egps/to_be_reprocessed"
echo "[EGPS] ✓ Run 1 completed at $(date '+%H:%M:%S')"

echo "[EGPS] Run 2/3: Processing new files..."
bun src/index.ts -d "$HOME/project_b_share/documents/audits/egps/to_be_processed" -p "$HOME/project_b_share/documents/audits/egps/to_be_reprocessed"
echo "[EGPS] ✓ Run 2 completed at $(date '+%H:%M:%S')"

echo "[EGPS] Run 3/3: Processing new files..."
bun src/index.ts -d "$HOME/project_b_share/documents/audits/egps/to_be_processed" -p "$HOME/project_b_share/documents/audits/egps/to_be_reprocessed"
echo "[EGPS] ✓ Run 3 completed at $(date '+%H:%M:%S')"

echo "[EGPS] Final: Moving reprocessed files to processed..."
bun src/index.ts -d "$HOME/project_b_share/documents/audits/egps/to_be_reprocessed" -p "$HOME/project_b_share/documents/audits/egps/processed" -r
echo "[EGPS] ✓ All EGPS processing completed"

echo ""
echo "--------------------------------------------------"
cd $HOME/dev/project_b_gmax_scrape_cli
echo "[GMAX] Starting GMAX audit processing..."

echo "[GMAX] Run 1/3: Processing new files..."
bun src/index.ts -d "$HOME/project_b_share/documents/audits/gmax/to_be_processed" -p "$HOME/project_b_share/documents/audits/gmax/to_be_reprocessed"
echo "[GMAX] ✓ Run 1 completed at $(date '+%H:%M:%S')"

echo "[GMAX] Run 2/3: Processing new files..."
bun src/index.ts -d "$HOME/project_b_share/documents/audits/gmax/to_be_processed" -p "$HOME/project_b_share/documents/audits/gmax/to_be_reprocessed"
echo "[GMAX] ✓ Run 2 completed at $(date '+%H:%M:%S')"

echo "[GMAX] Run 3/3: Processing new files..."
bun src/index.ts -d "$HOME/project_b_share/documents/audits/gmax/to_be_processed" -p "$HOME/project_b_share/documents/audits/gmax/to_be_reprocessed"
echo "[GMAX] ✓ Run 3 completed at $(date '+%H:%M:%S')"

echo "[GMAX] Final: Moving reprocessed files to processed..."
bun src/index.ts -d "$HOME/project_b_share/documents/audits/gmax/to_be_reprocessed" -p "$HOME/project_b_share/documents/audits/gmax/processed" -r
echo "[GMAX] ✓ All GMAX processing completed"

echo ""
echo "=================================================="
echo "All audit processing completed: $(date)"
echo "=================================================="

touch ~/.cron_support/cron_project_b_gmax_egps_audit.txt

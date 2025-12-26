#!/usr/bin/env zsh
source ~/.zshrc

# Lock file to prevent multiple instances
LOCKFILE="$HOME/.cron_support/projectb_gmax_egps_audit.lock"

# Check if another instance is running
if [ -f "$LOCKFILE" ]; then
    echo "Another instance is already running. Exiting."
    exit 0
fi

# Create lock file with current PID
echo $$ > "$LOCKFILE"

# Ensure lock file is removed on exit (normal or error)
trap "rm -f $LOCKFILE" EXIT INT TERM

cd $HOME/dev/project_b_equibase_scrape_cli
# Add your commands here sequentially
# first runs of egps audits
yarn dev -d "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/egps/to_be_processed" -p "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/egps/to_be_reprocessed"

yarn dev -d "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/egps/to_be_processed" -p "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/egps/to_be_reprocessed"

yarn dev -d "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/egps/to_be_processed" -p "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/egps/to_be_reprocessed"

yarn dev -d "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/egps/to_be_reprocessed" -p "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/egps/processed" -r

touch ~/.cron_support/cron_projectb_gmax_egps_audit.txt

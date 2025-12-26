#!/usr/bin/env zsh
source ~/.zshrc

cd $HOME/dev/project_b_equibase_scrape_cli
# Add your commands here sequentially
# first runs of egps audits
yarn dev -d "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/egps/to_be_processed" -p "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/egps/to_be_reprocessed"

yarn dev -d "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/egps/to_be_processed" -p "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/egps/to_be_reprocessed"

yarn dev -d "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/egps/to_be_processed" -p "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/egps/to_be_reprocessed"

yarn dev -d "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/egps/to_be_reprocessed" -p "/Users/dgdosen/dropboxm/joined_shares/project_b_share/documents/audits/egps/processed" -r

touch ~/.cron_support/cron_projectb_gmax_egps_audit.txt

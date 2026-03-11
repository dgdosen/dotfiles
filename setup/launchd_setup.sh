# Install and start launchd agents via lunchy
# Matches agents currently running on primary machine

# General/System
lunchy install ~/.dotfiles/.launchd/com.agidevelopment.backup.plist
lunchy install ~/.dotfiles/.launchd/com.agidevelopment.brewupdate.plist
lunchy install ~/.dotfiles/.launchd/com.agidevelopment.dotupdate.plist
lunchy install ~/.dotfiles/.launchd/com.agidevelopment.fetch.plist
lunchy install ~/.dotfiles/.launchd/com.agidevelopment.logrotate.plist
lunchy install ~/.dotfiles/.launchd/com.agidevelopment.touch.plist

# Project B
lunchy install ~/.dotfiles/.launchd/com.makerboarding.project_b_db.plist
lunchy install ~/.dotfiles/.launchd/com.makerboarding.project_b_dw_db.plist
lunchy install ~/.dotfiles/.launchd/com.agidevelopment.projectb_drf_watch.plist

# Quantified Flow
lunchy install ~/.dotfiles/.launchd/com.quantifiedflow.quantified_status.plist

lunchy start com.agidevelopment.backup
lunchy start com.agidevelopment.brewupdate
lunchy start com.agidevelopment.dotupdate
lunchy start com.agidevelopment.fetch
lunchy start com.agidevelopment.logrotate
lunchy start com.agidevelopment.touch

lunchy start com.makerboarding.project_b_db
lunchy start com.makerboarding.project_b_dw_db
lunchy start com.agidevelopment.projectb_drf_watch

lunchy start com.quantifiedflow.quantified_status

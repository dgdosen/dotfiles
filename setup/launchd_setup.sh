lunchy install ~/.dotfiles/.launchd/com.agidevelopment.backup.plist
lunchy install ~/.dotfiles/.launchd/com.agidevelopment.beardailyupdate.plist
lunchy install ~/.dotfiles/.launchd/com.agidevelopment.bearweeklycreate.plist
lunchy install ~/.dotfiles/.launchd/com.agidevelopment.brewupdate.plist
lunchy install ~/.dotfiles/.launchd/com.agidevelopment.dotupdate.plist
lunchy install ~/.dotfiles/.launchd/com.agidevelopment.logrotate.plist
lunchy install ~/.dotfiles/.launchd/com.agidevelopment.fetch.plist
lunchy install ~/.dotfiles/.launchd/com.agidevelopment.touch.plist

lunchy install ~/.dotfiles/.launchd/com.makerboarding.projectb_db.plist
lunchy install ~/.dotfiles/.launchd/com.makerboarding.projectb_dw_db.plist

lunchy start com.agidevelopment.backup
lunchy start com.agidevelopment.beardailyupdate
lunchy start com.agidevelopment.bearweeklycreate
lunchy start com.agidevelopment.brewupdate
lunchy start com.agidevelopment.dotupdate
lunchy start com.agidevelopment.logrotate
lunchy start com.agidevelopment.fetch
lunchy start com.agidevelopment.touch

lunchy start com.makerboarding.projectb_db
lunchy start com.makerboarding.projectb_dw_db


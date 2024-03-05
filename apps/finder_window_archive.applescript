set paths to {"/Users/dgdosen/Downloads", "/Users/dgdosen/Desktop"}

tell application "Finder"
	activate
	set finderWindow to make new Finder window
	set toolbar visible of finderWindow to true
	set target of finderWindow to POSIX file (item 1 of paths) as alias -- Set the first tab to the first path
end tell

-- Open additional paths as new tabs
tell application "System Events" to tell process "Finder"
	repeat with i from 2 to count of paths
		keystroke "t" using command down -- Simulate Cmd+T to open a new tab
		delay 0.5 -- Wait for the new tab to open
		tell application "Finder"
			set target of finderWindow to POSIX file (item i of paths) as alias
		end tell
		delay 0.5 -- Wait for the tab to change to the new target
	end repeat
end tell


set paths to {"/Users/dgdosen/makerboarding Dropbox/Daniel Dosen/joined_shares/project_b_share/archive/egps_scrape", "/Users/dgdosen/makerboarding Dropbox/Daniel Dosen/joined_shares/project_b_share/archive/gmax_scrape", "/Users/dgdosen/makerboarding Dropbox/Daniel Dosen/joined_shares/project_b_share/documents/audits"}
set xOffset to 40 -- Horizontal offset for each new window
set yOffset to 40 -- Vertical offset for each new window
set initialPosition to {25, 25} -- Initial position of the first window
set windowWidth to 800 -- Desired width of the window
set windowHeight to 600 -- Desired height of the window

tell application "Finder"
	activate
	-- Explicitly create a new Finder window without setting a target
	make new Finder window
	set finderWindow to front window
	-- Set the initial position of the first window
	set position of finderWindow to initialPosition

	-- Now set the target of the newly created window to the first path
	set target of finderWindow to POSIX file (item 1 of paths) as alias

	-- Loop through the rest of the paths
	repeat with i from 2 to the count of paths
		set thePath to item i of paths
		-- Convert each path to a format Finder can use (alias)
		set thePathAlias to POSIX file thePath as alias
		-- Attempt to open each path in a new Finder window and offset its position
		set newWindow to make new Finder window to thePathAlias
		-- Calculate new window position
		set newPosition to {(item 1 of initialPosition) + (xOffset * (i - 1)), (item 2 of initialPosition) + (yOffset * (i - 1))}
		set position of newWindow to newPosition
	end repeat
end tell

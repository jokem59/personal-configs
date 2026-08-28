-- HelixOpener — receives files from Finder (double-click / "Open With") and
-- opens them in terminal Helix. This AppleScript exists only to catch the
-- Finder "open documents" Apple Event (a plain shell script can't); the real
-- logic lives in open-in-helix.sh.
--
-- Compiled to ~/Applications/HelixOpener.app by SetupDevEnv.sh (setup_helix).
-- Source tracked in personal-configs.
on open theFiles
	set opener to "/Users/joekim/dev/personal-configs/helix/open-in-helix.sh"
	set argList to ""
	repeat with f in theFiles
		set argList to argList & " " & quoted form of (POSIX path of f)
	end repeat
	do shell script "/bin/sh " & quoted form of opener & argList
end open

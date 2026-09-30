-- EmacsOpener — the Finder file-open handler for the Emacs daemon. Set as the
-- default handler for code/text files (see set-emacs-defaults.sh), it hands
-- double-clicked / "Open With" files to open-in-emacs.sh, which opens them in the
-- shared daemon via emacsclient -- the same daemon Opt+3 attaches to.
--
-- This is NOT the Dock icon: the real /Applications/Emacs.app is pinned instead,
-- and init-ui.el keeps the daemon owning a GUI frame so clicking that tile
-- activates the daemon rather than spawning a standalone Emacs. The `on run' /
-- `on reopen' handlers below are just a harmless fallback: if this applet is ever
-- launched with no document, focus a daemon frame rather than doing nothing.
--
-- This AppleScript exists only to catch Finder/Launch Services Apple Events (a
-- plain shell script can't); the real logic lives in open-in-emacs.sh.
--
--   on open   -- double-click / "Open With" a file -> open that file in a frame
--   on run    -- launched with no document          -> focus a frame
--   on reopen -- re-activated with no document       -> focus a frame
--
-- Compiled to ~/Applications/EmacsOpener.app by SetupDevEnv.sh (setup_emacs).
-- Source tracked in personal-configs.
property opener : "/Users/joekim/dev/personal-configs/emacs/open-in-emacs.sh"

-- No document: just focus/create (or cycle) a daemon frame. Runs open-in-emacs.sh
-- with no args -- it focuses via my/focus-or-make-frame and skips the file visit.
on run
	do shell script "/bin/sh " & quoted form of opener
end run

-- Clicking a stay-open app's Dock icon sends `reopen` rather than `run`; handle
-- it the same way so a click always brings the daemon forward.
on reopen
	do shell script "/bin/sh " & quoted form of opener
end reopen

on open theFiles
	set argList to ""
	repeat with f in theFiles
		set argList to argList & " " & quoted form of (POSIX path of f)
	end repeat
	do shell script "/bin/sh " & quoted form of opener & argList
end open

#!/bin/sh
# open-in-emacs.sh — focus the running Emacs daemon (and optionally open files).
#
# Reuses the shared Emacs daemon via emacsclient: focus an existing graphical
# frame (cycling through them on repeat calls, creating one only if none exists),
# optionally visit any file arguments in that frame, then raise Emacs to the
# front. This is the same daemon the Karabiner Opt+3 binding attaches to.
#
# Invoked by EmacsOpener.app (the Finder file-open handler, not the Dock icon):
# with file arguments when you double-click / "Open With" a file, and with NO
# arguments on a bare launch (a harmless focus-the-daemon fallback). Launch
# Services gives GUI apps a minimal PATH, so every binary is absolute.
#
# Why not `emacsclient -r`/`-c`: launched from Launch Services there's no tty or
# display associated with the client, so `-r` ("reuse-frame") decides there's no
# "current frame" for this client and spawns a *new* window-system frame every
# time (`-c` always does). Plain `-n` with no frame flag instead visits the
# file(s) in the daemon's already-selected frame — reusing it. We first ensure a
# graphical frame exists (and focus it) via `my/focus-or-make-frame`, the same
# reuse-or-create helper the Opt+3 binding uses, so the no-frame case still works.

EMACSCLIENT=/opt/homebrew/bin/emacsclient
LOG=/tmp/open-in-emacs.log

log() { printf '%s  %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >>"$LOG" 2>/dev/null; }

log "open: $*"

# Ensure a graphical frame exists and is focused: reuse an existing one, else
# make one. `-a ""` starts the daemon if it isn't already running.
"$EMACSCLIENT" -n -a "" -e '(my/focus-or-make-frame)' >>"$LOG" 2>&1

# Visit the file(s) in that frame. Plain `-n` (no -c/-r) reuses the selected
# frame instead of spawning a new one. Absolute POSIX paths come from
# EmacsOpener.app, so the process cwd (Launch Services sets it to /) is moot.
# Skip this entirely on a bare Dock/Spotlight launch (no file args): `emacsclient
# -n` with nothing to visit just errors.
[ "$#" -gt 0 ] && "$EMACSCLIENT" -n "$@" >>"$LOG" 2>&1

# Raise Emacs to the front — the same activate the Opt+3 binding uses. Target the
# daemon by bundle id (`org.gnu.Emacs`) rather than by name, so it can't be
# confused with this applet even if the applet also presents as "Emacs".
/usr/bin/osascript -e 'tell application id "org.gnu.Emacs" to activate' >>"$LOG" 2>&1

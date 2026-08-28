#!/bin/sh
# open-in-helix.sh — open file(s) in terminal Helix.
#
# Preference order:
#   1. If a tmux server is running, open the file as a NEW WINDOW in the
#      session a client is attached to (so it appears where you're looking),
#      then raise Alacritty.
#   2. Otherwise, launch a fresh Alacritty running Helix on the file.
#
# Invoked by HelixOpener.app when you double-click / "Open With" a file.
# Launch Services gives GUI apps a minimal PATH, so every binary is absolute.

TMUX_BIN=/opt/homebrew/bin/tmux
HX=/opt/homebrew/bin/hx
LOG=/tmp/open-in-helix.log

log() { printf '%s  %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >>"$LOG" 2>/dev/null; }

for f in "$@"; do
  [ -e "$f" ] || { log "skip (missing): $f"; continue; }
  dir=$(dirname "$f")
  if "$TMUX_BIN" info >/dev/null 2>&1; then
    # Prefer the session an attached client is viewing; else the first session.
    sess=$("$TMUX_BIN" list-clients -F '#{client_session}' 2>/dev/null | head -1)
    [ -z "$sess" ] && sess=$("$TMUX_BIN" list-sessions -F '#{session_name}' 2>/dev/null | head -1)
    if [ -n "$sess" ]; then
      log "tmux new-window in '$sess' -> $f"
      "$TMUX_BIN" new-window -t "$sess" -c "$dir" "$HX" "$f"
      /usr/bin/open -a Alacritty      # raise the terminal
      continue
    fi
    log "tmux server up but no session found; falling back"
  fi
  log "fresh Alacritty -> $f"
  /usr/bin/open -na Alacritty --args -e "$HX" "$f"
done

#!/bin/bash
# Open the link under the copy-mode cursor of tmux pane $1.
# Prefers an OSC 8 hyperlink at the cursor; otherwise finds a URL in the
# cursor's line that spans the cursor column. Bound to Enter in copy mode.

set -u

pane=$1
read -r x link < <(tmux display -p -t "$pane" '#{copy_cursor_x} #{copy_cursor_hyperlink}')
line=$(tmux display -p -t "$pane" '#{copy_cursor_line}')

if [ -z "${link-}" ]; then
  # Walk each URL match and keep the one whose span covers column x.
  rest=$line
  offset=0
  re='(https?|file)://[^][:space:]<>"'\''`()[]+'
  while [[ $rest =~ $re ]]; do
    match=${BASH_REMATCH[0]}
    prefix=${rest%%"$match"*}
    start=$((offset + ${#prefix}))
    end=$((start + ${#match}))
    if [ "$x" -ge "$start" ] && [ "$x" -lt "$end" ]; then
      link=${match%[.,;:!?\']}
      break
    fi
    offset=$end
    rest=${rest:$((${#prefix} + ${#match}))}
  done
fi

if [ -z "${link-}" ]; then
  tmux display-message -t "$pane" "No link under cursor"
  exit 0
fi

tmux send-keys -t "$pane" -X cancel
if type open &>/dev/null; then
  open "$link"
else
  xdg-open "$link" &>/dev/null &
fi

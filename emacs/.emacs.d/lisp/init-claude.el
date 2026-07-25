;; Run declawd (the Claude Code wrapper) inside Emacs via the eat terminal.
;;
;; eat is pure elisp with no native module, unlike vterm. The vterm-based
;; `claude-code' package can't be used here: building vterm's C module needs
;; libvterm/glibtool, which aren't installable in this environment. eat gives
;; us a fully-featured terminal with none of that build friction.

(defvar declawd-program "/Applications/declawd.app/Contents/MacOS/declawd"
  "Path to the declawd executable (the Claude Code wrapper).")

(defvar declawd-switches '("--yolo" "--model" "claude-opus-4-8[1m]")
  "Command-line switches passed to declawd.")

(defun declawd--command ()
  "Build the shell command string that launches declawd.
eat runs the program via `sh -c', so each token is shell-quoted;
this keeps e.g. the [1m] in the model name from being treated as
a shell glob."
  (mapconcat #'shell-quote-argument
             (cons declawd-program declawd-switches)
             " "))

(use-package eat
  :commands (eat)
  :init
  (defun declawd (&optional arg)
    "Run declawd in an eat terminal buffer.
Reuses the existing *declawd* session if one is live; with a
prefix ARG, start a fresh session instead."
    (interactive "P")
    (require 'eat)
    (let ((eat-buffer-name "*declawd*"))
      (eat (declawd--command) (and arg t))))
  :bind
  ("C-c c" . declawd))

(provide 'init-claude)

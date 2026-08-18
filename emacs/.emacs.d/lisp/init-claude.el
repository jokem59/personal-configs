;; Run declawd (the Claude Code wrapper) inside Emacs via the eat terminal,
;; falling back to the plain `claude' CLI when declawd isn't installed.
;;
;; eat is pure elisp with no native module, unlike vterm. The vterm-based
;; `claude-code' package can't be used here: building vterm's C module needs
;; libvterm/glibtool, which aren't installable in this environment. eat gives
;; us a fully-featured terminal with none of that build friction.

(defvar declawd-program "/Applications/declawd.app/Contents/MacOS/declawd"
  "Path to the declawd executable (the Claude Code wrapper).")

(defvar declawd-switches '("--yolo" "--model" "claude-opus-4-8[1m]")
  "Command-line switches passed to declawd.")

(defvar declawd-fallback-program "claude"
  "Program to run when `declawd-program' doesn't exist.")

(defvar declawd-fallback-switches '()
  "Command-line switches passed to `declawd-fallback-program'.")

(defun declawd--command ()
  "Build the shell command string that launches declawd or its fallback.
eat runs the program via `sh -c', so each token is shell-quoted;
this keeps e.g. the [1m] in the model name from being treated as
a shell glob."
  (if (file-exists-p declawd-program)
      (mapconcat #'shell-quote-argument
                 (cons declawd-program declawd-switches)
                 " ")
    (mapconcat #'shell-quote-argument
               (cons declawd-fallback-program declawd-fallback-switches)
               " ")))

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
  (defun my/eat-new ()
    "Always start a new eat session.
Plain `eat' reuses the existing *eat* buffer; this always creates a
fresh session instead. Switch back to existing terminals with `C-x b'."
    (interactive)
    (eat nil t))                        ; nil = default shell, t = force new
  :bind
  (("C-c c" . declawd)
   ("C-c t" . my/eat-new)))

;; Make `C-c C-e' a single toggle between emacs-mode (read-only; scroll/search/
;; yank like a normal buffer -- eat's "copy mode") and semi-char terminal input.
;; Out of the box `C-c C-e' only *enters* emacs-mode; the return trip is
;; `C-c C-j'. `eat-emacs-mode' sets `buffer-read-only' t and `eat-semi-char-mode'
;; sets it nil, which is a reliable way to tell which state we're in.
(defvar-local my/eat--saved-cursor-type nil
  "`cursor-type' saved on entering emacs-mode, restored on leaving.")

(defun my/eat-toggle-emacs-mode ()
  "Toggle eat between emacs-mode (copy/scroll) and semi-char terminal input."
  (interactive)
  (if buffer-read-only
      (progn
        (eat-semi-char-mode)
        ;; Hand the cursor back to eat (it tracks the program's cursor state).
        (setq-local cursor-type my/eat--saved-cursor-type))
    (setq-local my/eat--saved-cursor-type cursor-type)
    (eat-emacs-mode)
    ;; eat leaves `cursor-type' at whatever the program last requested. A TUI
    ;; like Claude Code hides its cursor (`cursor-type' nil), so point would be
    ;; invisible in copy mode even though it moves -- force it visible.
    (setq-local cursor-type 'box)))

(with-eval-after-load 'eat
  ;; Route `C-c C-e' through our toggle in BOTH directions so the cursor fix
  ;; runs on entry as well as exit:
  ;;   - `eat-mode-map' is live during emacs-mode -> handles the return trip.
  ;;   - `eat-semi-char-mode-map' is more specific and normally binds `C-c C-e'
  ;;     straight to `eat-emacs-mode' (eat.el), which would enter copy mode
  ;;     WITHOUT forcing the cursor visible. Override it here.
  (define-key eat-mode-map (kbd "C-c C-e") #'my/eat-toggle-emacs-mode)
  (define-key eat-semi-char-mode-map (kbd "C-c C-e") #'my/eat-toggle-emacs-mode))

(provide 'init-claude)

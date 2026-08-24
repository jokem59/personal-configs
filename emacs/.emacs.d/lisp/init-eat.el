;; eat terminal configuration: input-mode ergonomics (bare C-c = SIGINT, C-/
;; undo, C-' copy-mode toggle), copy-mode cursor visibility, steady-scroll and
;; glyph fixes for animated TUIs, clickable links, and a launcher for declawd
;; (the Claude Code wrapper, falling back to the plain `claude' CLI when
;; declawd isn't installed) that runs inside eat.
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
        (setq-local cursor-type my/eat--saved-cursor-type)
        ;; Copy mode may have scrolled the window far from the prompt. Re-sync
        ;; the display so the terminal cursor (the prompt) is back in view --
        ;; this is what eat itself runs on new output (see `eat--adjust-*').
        (when eat-terminal
          (funcall (or eat--synchronize-scroll-function
                       #'eat--synchronize-scroll)
                   (eat--synchronize-scroll-windows 'force-selected))))
    (setq-local my/eat--saved-cursor-type cursor-type)
    (eat-emacs-mode)
    ;; eat leaves `cursor-type' at whatever the program last requested. A TUI
    ;; like Claude Code hides its cursor (`cursor-type' nil), so point would be
    ;; invisible in copy mode even though it moves -- force it visible.
    (setq-local cursor-type 'box)))

(with-eval-after-load 'eat
  ;; Make a bare `C-c' send SIGINT in semi-char mode, like a real terminal,
  ;; instead of eat's default `C-c C-c'. This turns `C-c' from a prefix key
  ;; into a self-insert of ETX (^C), so eat's other `C-c ...' commands
  ;; (`eat-kill-process', `eat-char-mode', ...) are no longer reachable via
  ;; `C-c' -- use `M-x' for those on the rare occasion they're needed.
  (define-key eat-semi-char-mode-map (kbd "C-c")
              (lambda () (interactive) (eat-input-char ?\C-c 1)))

  ;; In GUI Emacs `C-/' is its own key event, not the 0x1F (^_) control byte a
  ;; TTY sends, so eat never forwards it and it falls through to Emacs `undo'
  ;; (meaningless on terminal output -- it just jostles point). Forward it as
  ;; ^_ so it reaches the shell's undo, exactly like the already-working `C-_'.
  (define-key eat-semi-char-mode-map (kbd "C-/")
              (lambda () (interactive) (eat-input-char ?\C-_ 1)))

  ;; With `C-c' repurposed, the copy-mode toggle moves to `C-''. Bind it in
  ;; BOTH maps so the same key works in both directions (and so the cursor fix
  ;; in `my/eat-toggle-emacs-mode' runs on entry as well as exit):
  ;;   - `eat-semi-char-mode-map' (semi-char input) -> enter emacs/copy mode.
  ;;   - `eat-mode-map' (live during emacs-mode)     -> return to semi-char.
  ;; `C-'' has no ASCII control code, so it can never be sent to the terminal
  ;; program -- stealing it here costs nothing.
  (define-key eat-semi-char-mode-map (kbd "C-'") #'my/eat-toggle-emacs-mode)
  (define-key eat-mode-map           (kbd "C-'") #'my/eat-toggle-emacs-mode))

;; Stop the eat window from bouncing a line up/down while a program animates
;; (e.g. Claude Code's "thinking" spinner). eat re-runs its scroll sync on
;; every output chunk and `recenter's the window to the terminal cursor; when
;; the program's cursor row wobbles by a line each tick, that recenter makes
;; the whole view jump. Swap in a gentler sync (buffer-local) that only
;; recenters when the cursor has actually scrolled out of view -- otherwise it
;; just moves point, leaving the scroll position steady. Mirrors
;; `eat--synchronize-scroll' but guards the `recenter' with a visibility check.
(defun my/eat-synchronize-scroll-lazy (windows)
  "Sync WINDOWS to the terminal cursor, recentering only when it's off-screen."
  (dolist (window windows)
    (if (eq window 'buffer)
        (goto-char (eat-term-display-cursor eat-terminal))
      (set-window-point window (eat-term-display-cursor eat-terminal))
      (unless (pos-visible-in-window-p
               (eat-term-display-cursor eat-terminal) window)
        (with-selected-window window
          (recenter
           (- (how-many "\n" (eat-term-display-beginning eat-terminal)
                        (eat-term-display-cursor eat-terminal))
              (cdr (eat-term-size eat-terminal))
              (max 0 (- (floor (window-screen-lines))
                        (cdr (eat-term-size eat-terminal)))))))))))

(add-hook 'eat-mode-hook
          (lambda ()
            (setq eat--synchronize-scroll-function
                  #'my/eat-synchronize-scroll-lazy)))

;; Claude Code's tool-call marker `⏺' (U+23FA) isn't in Roboto Mono, so Emacs
;; draws it from STIX Two Math, whose taller metrics inflate that screen line
;; and make it wobble on cursor blink / redisplay. Remap it (DISPLAY only --
;; buffer text is unchanged, so yanks still yield `⏺') to `•' (U+2022), which
;; Roboto Mono renders at the normal line height.
(add-hook 'eat-mode-hook
          (lambda ()
            (unless buffer-display-table
              (setq buffer-display-table (make-display-table)))
            (aset buffer-display-table ?⏺ (vector ?•))))

;; Drop inter-line padding in terminals. The frame-wide `line-spacing' (set in
;; init-ui.el for prose/code) adds a pixel *below* every rendered line. eat
;; sizes the child to `(floor (window-screen-lines))' -- the rows that fit above
;; the mode line -- but that trailing pixel on the bottom-most row has nowhere to
;; go, so the final terminal row's descent + spacing is clipped by the mode line
;; and its glyphs bleed into the mode-line row (the "last line is covered by the
;; status bar" symptom). Terminal grids don't want inter-line padding anyway;
;; zero it out buffer-locally so the last row sits flush above the mode line.
(add-hook 'eat-mode-hook (lambda () (setq-local line-spacing nil)))

;; Clickable links in the terminal. eat 0.9.4 doesn't handle OSC 8 hyperlinks,
;; so we detect plain-text URLs/emails with `goto-address-mode'. It registers
;; with jit-lock, so URLs in fresh output get fontified as they scroll into
;; view -- no manual re-scan needed. Activate a link with a mouse click; or in
;; copy mode (`C-'') with `C-c RET' on the URL. (In semi-char mode `C-c' is
;; SIGINT, so keyboard activation there isn't available -- use the mouse.)
(add-hook 'eat-mode-hook #'goto-address-mode)

(provide 'init-eat)

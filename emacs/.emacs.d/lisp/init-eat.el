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

;; The mode line's small "RO" tag is easy to miss, so while read-only
;; (emacs/copy) mode is active, recolor the whole mode line to the same
;; beige/yellow -- a full-width status bar that's hard to overlook. Buffer-local
;; face remaps, so they touch only this terminal's mode line and revert on
;; returning to input. The beige is the mode line's RO tag (the `warning' face,
;; read live so it tracks the theme); the text is darkened to the frame
;; background so it stays legible on the light bar. The "RO" tag itself is
;; `warning'-colored, so it goes beige-on-beige and effectively vanishes -- fine,
;; since the whole bar turning beige is now the signal.
(defun my/eat--ro-modeline-color ()
  "Beige/yellow used for a read-only eat mode line (matches the RO tag)."
  (or (face-foreground 'warning nil t) "#d7af5f"))

(defvar-local my/eat--ro-modeline-cookies nil
  "Face-remap cookies for the read-only mode line, removed on leaving copy mode.")

(defun my/eat--ro-modeline-on ()
  "Recolor the mode line beige to flag read-only/copy mode."
  (let ((bg (my/eat--ro-modeline-color))
        (fg (or (face-background 'default nil t) "#1e1e1e")))
    (setq my/eat--ro-modeline-cookies
          (list (face-remap-add-relative 'mode-line-active
                                         :background bg :foreground fg)
                (face-remap-add-relative 'mode-line
                                         :background bg :foreground fg)))))

(defun my/eat--ro-modeline-off ()
  "Restore the mode line's normal color."
  (mapc #'face-remap-remove-relative my/eat--ro-modeline-cookies)
  (setq my/eat--ro-modeline-cookies nil))

(defun my/eat-toggle-emacs-mode ()
  "Toggle eat between emacs-mode (copy/scroll) and semi-char terminal input."
  (interactive)
  (if buffer-read-only
      (progn
        (eat-semi-char-mode)
        (my/eat--ro-modeline-off)        ; leaving copy mode: restore the bar
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
    (my/eat--ro-modeline-on)             ; entering copy mode: light up the bar
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
  (define-key eat-mode-map           (kbd "C-'") #'my/eat-toggle-emacs-mode)

  ;; In emacs/copy mode, also accept a bare `q' to jump back to semi-char input
  ;; (vi-style). Bound only in `eat-mode-map', so it fires solely in emacs-mode:
  ;; during semi-char/char input `eat-semi-char-mode-map' binds `q' to
  ;; `eat-self-input' and shadows this, so typing `q' at the shell still works.
  (define-key eat-mode-map           (kbd "q")   #'my/eat-toggle-emacs-mode))

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

;; Clickable links in the terminal. eat 0.9.4 doesn't implement OSC 8
;; hyperlinks, and long links are the catch: eat hard-wraps a line at the
;; terminal width by inserting an actual newline, so a URL that overflows is
;; split across buffer lines and a single-line matcher (`goto-address-mode')
;; catches only -- and mangles -- the first fragment.
;;
;; eat tags *those* wrap newlines with an `eat--t-wrap-line' text property (a
;; genuine line break has none), which lets us stitch a wrapped link back
;; together: for each logical line we build a string with eat's wrap newlines
;; removed, match URLs/emails against that, then map each match back onto the
;; buffer span (wrap newline and all) and lay a clickable overlay over it. We
;; use overlays rather than text properties so the link `face' layers over
;; eat's own color faces instead of clobbering them -- this is how goto-address
;; works too. Runs via jit-lock, so links in fresh output are picked up as they
;; scroll into view. Activate with a mouse-2 click, or in copy mode (`C-'')
;; with `C-c RET' on the link.
(require 'goto-addr)

(defun my/eat-open-link (&optional event)
  "Open the eat link at point, or at EVENT's position for a mouse click."
  (interactive (list last-nonmenu-event))
  (let* ((pos (if (consp event) (posn-point (event-end event)) (point)))
         (url (and pos (get-char-property pos 'my/eat-url))))
    (if url (browse-url url) (message "No link at point"))))

(defvar my/eat-link-keymap
  (let ((map (make-sparse-keymap)))
    (define-key map [mouse-2]       #'my/eat-open-link)
    (define-key map (kbd "C-c RET") #'my/eat-open-link)
    map)
  "Keymap active over a linkified URL/email in an eat buffer.")

(defun my/eat--hard-line-beginning (pos)
  "Start of POS's logical line, treating eat soft-wrap newlines as non-breaks."
  (save-excursion
    (goto-char pos)
    (catch 'done
      (while (search-backward "\n" nil t)
        (unless (get-text-property (point) 'eat--t-wrap-line)
          (throw 'done (1+ (point)))))
      (point-min))))

(defun my/eat--hard-line-end (pos)
  "End of POS's logical line, treating eat soft-wrap newlines as non-breaks."
  (save-excursion
    (goto-char pos)
    (catch 'done
      (while (search-forward "\n" nil t)
        (unless (get-text-property (1- (point)) 'eat--t-wrap-line)
          (throw 'done (point))))
      (point-max))))

(defun my/eat--unlinkify (beg end)
  "Delete our link overlays overlapping BEG..END, so they can be re-derived."
  (dolist (ov (overlays-in beg end))
    (when (overlay-get ov 'my/eat-link)
      (delete-overlay ov))))

(defun my/eat--apply-link (beg end target face mouse-face)
  "Overlay a clickable link to TARGET on the buffer span BEG..END."
  (let ((ov (make-overlay beg end)))
    (overlay-put ov 'my/eat-link t)
    (overlay-put ov 'my/eat-url target)
    (overlay-put ov 'evaporate t)
    (overlay-put ov 'face face)
    (overlay-put ov 'mouse-face mouse-face)
    (overlay-put ov 'help-echo (concat "Link: " target))
    ;; `follow-link' t lets a plain left-click (mouse-1) open the link: with
    ;; `mouse-1-click-follows-link' on (the default), Emacs translates a quick
    ;; mouse-1 on this overlay into the mouse-2 binding below. Without it only
    ;; a middle-click worked, which is easy to miss on a trackpad.
    (overlay-put ov 'follow-link t)
    (overlay-put ov 'keymap my/eat-link-keymap)))

(defun my/eat--linkify-region (start end)
  "Linkify URLs/emails in START..END, stitching eat's wrap-split lines.
Registered with jit-lock, so START..END is whatever chunk needs refontifying;
we widen it to whole logical lines (soft wraps don't count) before scanning."
  (let ((lbeg (my/eat--hard-line-beginning start))
        (lend (my/eat--hard-line-end end))
        (chars nil)
        (positions nil))
    (my/eat--unlinkify lbeg lend)
    ;; Logical text with eat's soft-wrap newlines dropped, plus a map from each
    ;; logical-string index back to its originating buffer position.
    (save-excursion
      (goto-char lbeg)
      (while (< (point) lend)
        (let ((ch (char-after)))
          (unless (and (eq ch ?\n)
                       (get-text-property (point) 'eat--t-wrap-line))
            (push ch chars)
            (push (point) positions)))
        (forward-char 1)))
    (when chars
      (let ((logstr (apply #'string (nreverse chars)))
            (posvec (vconcat (nreverse positions)))
            (case-fold-search t))
        (dolist (spec
                 (list (list goto-address-url-regexp #'identity
                             goto-address-url-face goto-address-url-mouse-face)
                       (list goto-address-mail-regexp
                             (lambda (m) (concat "mailto:" m))
                             goto-address-mail-face goto-address-mail-mouse-face)))
          (let ((re (nth 0 spec)) (mk (nth 1 spec))
                (face (nth 2 spec)) (mouse-face (nth 3 spec))
                (pos 0))
            (while (and (< pos (length logstr))
                        (string-match re logstr pos))
              (let ((ms (match-beginning 0))
                    (me (match-end 0)))
                ;; ms..me are logical indices; map to buffer positions. The span
                ;; [bstart,bend) is contiguous in the buffer, so it re-includes
                ;; any soft-wrap newline we dropped in the middle of the match.
                (my/eat--apply-link (aref posvec ms)
                                    (1+ (aref posvec (1- me)))
                                    (funcall mk (match-string 0 logstr))
                                    face mouse-face)
                (setq pos me)))))))))

(defun my/eat--setup-linkify ()
  "Enable wrap-aware URL/email linkification in this eat buffer."
  (jit-lock-register #'my/eat--linkify-region))

(add-hook 'eat-mode-hook #'my/eat--setup-linkify)

(provide 'init-eat)

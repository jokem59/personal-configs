;; eat terminal configuration: input-mode ergonomics (bare C-c = SIGINT, C-/
;; undo, copy-mode toggle), copy-mode cursor visibility, steady-scroll and
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
  ;; One-keystroke "terminal in a new split": split in the given direction,
  ;; move focus into the fresh pane (like the `C-x |' / `C-x -' wrappers in
  ;; init-keybindings.el), then start a new eat session there. Saves the
  ;; split -> C-c t dance. Bound to terminal-prefix analogs of the split
  ;; glyphs: `C-c |' / `C-c \' side-by-side, `C-c -' stacked.
  (defun my/eat-new-split-right ()
    "Split side by side and start a fresh eat session in the new (right) pane."
    (interactive)
    (select-window (split-window-right))
    (my/eat-new))
  (defun my/eat-new-split-below ()
    "Split stacked and start a fresh eat session in the new (below) pane."
    (interactive)
    (select-window (split-window-below))
    (my/eat-new))
  :bind
  (("C-c c" . declawd)
   ("C-c t" . my/eat-new)
   ;; Also on `C-x t' (shadowing the tab-bar prefix, which this config doesn't
   ;; use): reachable from *inside* a live eat terminal, where `C-c t' can't be
   ;; -- bare `C-c' is remapped to send SIGINT in semi-char mode, so it never
   ;; arrives as a prefix. `C-x' passes through semi-char mode untouched, so
   ;; `C-x t' opens a fresh terminal without first switching to emacs/RO mode.
   ("C-x t" . my/eat-new)
   ("C-c |" . my/eat-new-split-right)
   ("C-c \\" . my/eat-new-split-right)
   ("C-c -" . my/eat-new-split-below)))

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
(defun my/eat--recenter-bottom (window)
  "Recenter WINDOW so the terminal's display region sits flush at the bottom.
Same placement `eat--synchronize-scroll' computes: count the cursor's line
within the terminal grid, then offset by the grid height (and any slack rows
below it) so the grid's bottom row lands on the window's last usable line."
  (with-selected-window window
    (recenter
     (- (how-many "\n" (eat-term-display-beginning eat-terminal)
                  (eat-term-display-cursor eat-terminal))
        (cdr (eat-term-size eat-terminal))
        (max 0 (- (floor (window-screen-lines))
                  (cdr (eat-term-size eat-terminal))))))))

(defun my/eat-synchronize-scroll-lazy (windows)
  "Sync WINDOWS to the terminal cursor, recentering only when it's off-screen."
  (dolist (window windows)
    (if (eq window 'buffer)
        (goto-char (eat-term-display-cursor eat-terminal))
      (set-window-point window (eat-term-display-cursor eat-terminal))
      (unless (pos-visible-in-window-p
               (eat-term-display-cursor eat-terminal) window)
        (my/eat--recenter-bottom window)))))

(add-hook 'eat-mode-hook
          (lambda ()
            (setq eat--synchronize-scroll-function
                  #'my/eat-synchronize-scroll-lazy)))

;; Keep a live terminal pinned to the bottom. eat only auto-scrolls windows
;; whose point *already* tracks the terminal cursor (see `eat--process-output-
;; queue': it snapshots `eat--synchronize-scroll-windows' -- which excludes any
;; window whose point has drifted off the cursor -- before running the sync
;; function above). So once a window drifts (a stray point move, a redisplay
;; that left point behind, returning from copy mode), it's silently dropped from
;; the sync set and stops following new output -- you fall behind the bottom
;; while, e.g., Claude streams. `eat-update-hook' runs at the tail of every
;; output batch; use it to snap *every* window on this buffer back onto the
;; cursor and pin the bottom -- but only while the terminal is LIVE (semi-char
;; input; `buffer-read-only' nil). In copy/emacs mode (read-only) we do
;; nothing, leaving the user free to scroll and read. The same off-screen guard
;; as the lazy sync keeps a within-view cursor wobble from recentering, so this
;; follows output without reintroducing the animation bounce.
(defun my/eat--follow-bottom ()
  "While the eat terminal is live (not in copy mode), keep its windows at bottom.
Runs from `eat-update-hook' after each output batch; see the comment above."
  (when (and eat-terminal (not buffer-read-only))
    (let ((cursor (eat-term-display-cursor eat-terminal)))
      (dolist (window (get-buffer-window-list nil nil t))
        (unless (= (window-point window) cursor)
          (set-window-point window cursor))
        (unless (pos-visible-in-window-p cursor window)
          (my/eat--recenter-bottom window))))))

(add-hook 'eat-mode-hook
          (lambda ()
            (add-hook 'eat-update-hook #'my/eat--follow-bottom nil t)))

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
;; scroll into view. Activate with a mouse-2 click, or in copy mode with
;; `C-c RET' on the link.
(require 'goto-addr)

;; Rejoin links split across table cells (on demand). When a TUI (e.g. Claude
;; Code) draws a table, a long URL wraps *inside* a narrow cell across table
;; ROWS. Unlike eat's own soft-wrapping, those are real newlines with no
;; `eat--t-wrap-line' tag, and on each buffer line the fragment sits between `│'
;; column borders with unrelated columns beside it -- so the jit-lock linkifier
;; only ever sees (and highlights) the first fragment. Reconstructing that needs
;; column-aware stitching, which is too brittle/expensive to run on every
;; redraw, so we do it lazily: when you actually open a link whose highlighted
;; fragment butts against a cell edge, walk down that one cell column, collect
;; the URL fragments, and open the rejoined URL.
(defconst my/eat--table-sep ?│
  "Vertical-bar character used as a column separator in rendered tables.")

(defun my/eat--nth-sep-pos (bol n)
  "Buffer position of the Nth `my/eat--table-sep' on the line starting at BOL.
Returns nil if the line has fewer than N separators."
  (when (> n 0)
    (save-excursion
      (goto-char bol)
      (let ((eol (line-end-position)) (i 0) (hit nil))
        (while (and (< i n)
                    (search-forward (char-to-string my/eat--table-sep) eol t))
          (setq i (1+ i) hit (1- (point))))
        (and (= i n) hit)))))

(defun my/eat--count-seps (beg end)
  "Count `my/eat--table-sep' separators between BEG and END."
  (save-excursion
    (goto-char beg)
    (let ((n 0))
      (while (search-forward (char-to-string my/eat--table-sep) end t)
        (setq n (1+ n)))
      n)))

(defun my/eat--cell-truncated-p (pos)
  "Non-nil if POS sits at a table cell's right edge (only spaces, then a `│')."
  (save-excursion
    (goto-char pos)
    (let ((eol (line-end-position)))
      (skip-chars-forward " " eol)
      (and (< (point) eol) (eq (char-after) my/eat--table-sep)))))

(defun my/eat--url-char-p (ch)
  "Non-nil if CH could be part of a URL (so a cell's continuation isn't a border)."
  (and ch (or (and (>= ch ?A) (<= ch ?Z))
              (and (>= ch ?a) (<= ch ?z))
              (and (>= ch ?0) (<= ch ?9))
              (memq ch '(?/ ?. ?_ ?~ ?: ?% ?# ?? ?= ?& ?+ ?@ ?- ?, ?\; ?! ?* ?' ?\( ?\))))))

(defun my/eat--reconstruct-url-at (pos)
  "Return the URL beginning at POS, rejoining a link split across table cells.
POS is the URL's first character (e.g. a link overlay's start). When a fragment
fills its `│'-delimited cell to the right edge, the URL continues at that same
cell's left edge on the next row; walk down collecting fragments until one ends
short of the edge. Returns the trimmed URL string, or nil if nothing collected."
  (save-excursion
    (goto-char pos)
    ;; Which cell POS is in: the number of separators to its left on the line.
    (let ((cellidx (my/eat--count-seps (line-beginning-position) pos))
          (parts nil)
          (start pos)
          (go t))
      (while go
        (setq go nil)
        (let* ((lbol (line-beginning-position))
               (rsep (my/eat--nth-sep-pos lbol (1+ cellidx)))
               (redge (or rsep (line-end-position)))
               (rbeg (progn (goto-char start)
                            (skip-chars-forward " \t" redge) (point)))
               (rend (progn (skip-chars-forward "^ \t\n" redge) (point))))
          (when (> rend rbeg)
            (push (buffer-substring-no-properties rbeg rend) parts))
          ;; Fragment fills the cell (≤1 trailing pad space before the `│')? Then
          ;; the URL was cut here and continues in this cell on the next row.
          (when (and rsep (> rend rbeg) (<= (- redge rend) 1))
            (let ((nbol (save-excursion (goto-char lbol) (forward-line 1)
                                        (and (not (eobp)) (point)))))
              (when nbol
                (let ((nl (my/eat--nth-sep-pos nbol cellidx))
                      (nr (my/eat--nth-sep-pos nbol (1+ cellidx))))
                  (when nr
                    (let ((cbeg (if nl (1+ nl) nbol)))
                      (goto-char cbeg)
                      (skip-chars-forward " \t" nr)
                      ;; Continue only into text that looks like a URL tail (not
                      ;; a horizontal border row or an empty cell).
                      (when (and (< (point) nr)
                                 (my/eat--url-char-p (char-after)))
                        (setq start (point) go t))))))))))
      (when parts
        (let ((url (apply #'concat (nreverse parts))))
          (substring url 0 (my/eat--trim-url-end url 0 (length url))))))))

(defun my/eat-open-link (&optional event)
  "Open the eat link at point, or at EVENT's position for a mouse click.
If the link's highlighted fragment butts against a `│' table-cell edge, rejoin
the fragments down that cell first (see `my/eat--reconstruct-url-at'), so a URL
split across table rows still opens correctly."
  (interactive (list last-nonmenu-event))
  (let* ((pos (if (consp event) (posn-point (event-end event)) (point)))
         (ov (and pos (seq-find (lambda (o) (overlay-get o 'my/eat-url))
                                (overlays-at pos))))
         (url (and ov (overlay-get ov 'my/eat-url))))
    (cond
     ((and ov (my/eat--cell-truncated-p (overlay-end ov)))
      (browse-url (or (my/eat--reconstruct-url-at (overlay-start ov)) url)))
     (url (browse-url url))
     (t (message "No link at point")))))

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

(defun my/eat--unbalanced-close-p (str beg end open close)
  "Non-nil if STR[BEG..END) closes more CLOSE chars than it OPENs.
Used to tell a wrapping paren -- `(url)', 0 opens / 1 close -- from a paren
that's genuinely part of the URL -- `url_(x)', 1 open / 1 close."
  (let ((o 0) (c 0) (i beg))
    (while (< i end)
      (let ((ch (aref str i)))
        (cond ((eq ch open)  (setq o (1+ o)))
              ((eq ch close) (setq c (1+ c)))))
      (setq i (1+ i)))
    (> c o)))

(defun my/eat--trim-url-end (str beg end)
  "Return END shrunk to drop trailing punctuation of the URL STR[BEG..END).
`goto-address-url-regexp' greedily swallows trailing sentence punctuation and
a wrapping `)'/`]', so `(https://x/p/287)' matches with the stray paren and the
link 404s. Trim trailing .,;:!?'\" plus any closing paren/bracket with no opener
inside the match -- but keep balanced ones so `.../Foo_(bar)' survives intact."
  (let ((e end))
    (while (and (> e beg)
                (let ((c (aref str (1- e))))
                  (cond
                   ((memq c '(?. ?, ?\; ?: ?! ?? ?' ?\")) t)
                   ((eq c ?\)) (my/eat--unbalanced-close-p str beg e ?\( ?\)))
                   ((eq c ?\]) (my/eat--unbalanced-close-p str beg e ?\[ ?\]))
                   (t nil))))
      (setq e (1- e)))
    e))

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
        ;; Each spec's last element is a `trim' flag: URLs get trailing
        ;; punctuation/wrapping-paren trimming (see `my/eat--trim-url-end');
        ;; emails don't (their regexp is already tight, and the paren logic
        ;; doesn't apply).
        (dolist (spec
                 (list (list goto-address-url-regexp #'identity
                             goto-address-url-face goto-address-url-mouse-face t)
                       (list goto-address-mail-regexp
                             (lambda (m) (concat "mailto:" m))
                             goto-address-mail-face goto-address-mail-mouse-face nil)))
          (let ((re (nth 0 spec)) (mk (nth 1 spec))
                (face (nth 2 spec)) (mouse-face (nth 3 spec)) (trim (nth 4 spec))
                (pos 0))
            (while (and (< pos (length logstr))
                        (string-match re logstr pos))
              (let* ((ms (match-beginning 0))
                     (me0 (match-end 0))
                     ;; Trim from the raw match end, but keep scanning past the
                     ;; full match (`me0') so a trimmed tail isn't re-examined.
                     (me (if trim (my/eat--trim-url-end logstr ms me0) me0)))
                ;; ms..me are logical indices; map to buffer positions. The span
                ;; [bstart,bend) is contiguous in the buffer, so it re-includes
                ;; any soft-wrap newline we dropped in the middle of the match.
                (when (> me ms)
                  (my/eat--apply-link (aref posvec ms)
                                      (1+ (aref posvec (1- me)))
                                      (funcall mk (substring logstr ms me))
                                      face mouse-face))
                (setq pos me0)))))))))

(defun my/eat--setup-linkify ()
  "Enable wrap-aware URL/email linkification in this eat buffer."
  (jit-lock-register #'my/eat--linkify-region))

(add-hook 'eat-mode-hook #'my/eat--setup-linkify)

;; "Do what I mean" copy. eat hard-wraps a line at the terminal width by
;; inserting a real newline (tagged `eat--t-wrap-line'; a genuine line break has
;; none -- the same distinction the linkifier above relies on). So copying a
;; command that only *looks* multi-line -- it wrapped -- yanks it with embedded
;; newlines and the paste runs as several broken commands. Install a
;; buffer-local `filter-buffer-substring-function' that drops those soft-wrap
;; newlines from copied text (`M-w', mouse copy, clipetty -- anything that goes
;; through `filter-buffer-substring'), rejoining the wrapped line. Real newlines
;; carry no `eat--t-wrap-line', so genuine multi-line output copies verbatim.
(defun my/eat--dewrap (string)
  "Return STRING with eat soft-wrap newlines (`eat--t-wrap-line') removed."
  (if (not (string-search "\n" string))
      string
    (let ((chars nil))
      (dotimes (i (length string))
        (unless (and (eq (aref string i) ?\n)
                     (get-text-property i 'eat--t-wrap-line string))
          (push (aref string i) chars)))
      (apply #'string (nreverse chars)))))

(defun my/eat--filter-buffer-substring (beg end &optional delete)
  "Like the default buffer-substring filter, but strip eat soft-wrap newlines.
Lets a visually wrapped single line be copied (and pasted) as one line."
  (my/eat--dewrap
   (funcall (or (default-value 'filter-buffer-substring-function)
                #'buffer-substring--filter)
            beg end delete)))

(add-hook 'eat-mode-hook
          (lambda ()
            (setq-local filter-buffer-substring-function
                        #'my/eat--filter-buffer-substring)))

(provide 'init-eat)

;; Disable auto complete
(setq auto-complete-mode nil)

;; Start emacs in fullscreen
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Don't show the Welcome screen
(setq inhibit-startup-screen t)

(setq-default indent-tabs-mode nil)

(column-number-mode 1)
(setq column-number-mode t)
(setq line-number-mode t)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; Disable tool bar and scroll bar immediately if running in GUI mode
(when (display-graphic-p)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))

;; Ensure they are disabled when creating a new graphical frame (e.g., via emacsclient -c)
(add-hook 'after-make-frame-functions
          (lambda (frame)
            (when (display-graphic-p frame)
              (with-selected-frame frame
                (tool-bar-mode -1)
                (scroll-bar-mode -1)))))

(menu-bar-mode 0)
;; Mode-line clock: 24-hour time, prefixed with the weekday + date, and no
;; system load-average number.
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(setq display-time-default-load-average nil)
(display-time)

;; Show trailing whitespace only where you actually edit -- code and prose.
;; The default stays nil, so terminals (eat), special/UI buffers, the
;; minibuffer, which-key popups, the echo area, etc. are all clean without
;; per-buffer opt-outs.
(dolist (hook '(prog-mode-hook text-mode-hook))
  (add-hook hook (lambda () (setq show-trailing-whitespace t))))

;; These settings hide the truncation glyhphs on terminal and gui repsectively
;; When resizing windows, they can refresh many times which is visually distracting
;; Replace truncation glyphs on terminal "$" with space
(set-display-table-slot standard-display-table 'truncation ?\ )
;; Remove truncation glyphs for GUI
(push '(truncation nil nil) ;; no truncation indicators
      ;; '(truncation nil right-arrow) ;; right indicator only
      ;; '(truncation left-arrow nil) ;; left indicator only
      ;; '(truncation left-arrow right-arrow) ;; default
      fringe-indicator-alist)

;; Line numbers
(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Show file name in title bar
(setq frame-title-format "%b")

;; Use short yes/no prompt, y/n
(if (version< emacs-version "29.1")
    (message "Current version doesn't support setopt")
  (setopt use-short-answers t))

;;
;; all-the-icons
;;
(use-package all-the-icons
  :if (display-graphic-p))

(use-package all-the-icons-completion
  :after (marginalia all-the-icons)
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init
  (all-the-icons-completion-mode))

;; Have isearch show number of matches (requires Emacs 27.1+)
(setq isearch-lazy-count t)

;; Theme
(add-hook 'after-init-hook (lambda () (load-theme 'doom-dark+)))

;; Visible separators between side-by-side (vertical) splits. Stacked splits
;; are already separated by the mode line; vertical splits only get the thin,
;; near-invisible `vertical-border'. Turn on right-edge window dividers and
;; color them like the mode line so both split kinds read consistently.
(setq window-divider-default-places 'right-only
      window-divider-default-right-width 2)
(window-divider-mode 1)
;; The theme loads on `after-init-hook'; adjust these theme-dependent faces
;; afterward (append so this runs after the theme-loading hook).
(defvar my/mode-line-inactive-bg "#3a2f42"
  "Background for the inactive mode line -- a dark, muted version of the
active bar's purple so unselected windows' bars stay visible against the
near-black buffer background instead of blending in.")
(add-hook 'after-init-hook
          (lambda ()
            ;; Dividers track the (themed) active mode-line color.
            (let ((c (face-background 'mode-line nil t)))
              (dolist (f '(window-divider
                           window-divider-first-pixel
                           window-divider-last-pixel))
                (set-face-foreground f c)))
            ;; The theme's inactive mode line (#1d1d1d) is nearly the buffer
            ;; background (#1e1e1e), so unselected windows' bars vanish. Give
            ;; them a distinct bar (also covers solaire-mode's variant).
            (set-face-background 'mode-line-inactive my/mode-line-inactive-bg)
            (when (facep 'solaire-mode-line-inactive-face)
              (set-face-background 'solaire-mode-line-inactive-face
                                   my/mode-line-inactive-bg)))
          t)

;; Solaire-mode is an aesthetic plugin designed to visually distinguish "real" buffers vs "unreal" buffers
(require 'solaire-mode)

;; Enable solaire-mode anywhere it can be enabled
;; Helps with showing buffers like a more transluscent background
(solaire-global-mode +1)
;; To enable solaire-mode unconditionally for certain modes:
(add-hook 'ediff-prepare-buffer-hook #'solaire-mode)

;; ...if you use auto-revert-mode, this prevents solaire-mode from turning
;; itself off every time Emacs reverts the file
(add-hook 'after-revert-hook #'turn-on-solaire-mode)

(cond
 ((string-equal system-type "windows-nt")
  (progn
    (solaire-mode-swap-bg)
    (add-hook 'minibuffer-setup-hook #'solaire-mode-in-minibuffer))))
 ;; ((string-equal system-type "gnu/linux")
 ;;  (progn
 ;;    (solaire-mode-swap-bg)
 ;;    (add-hook 'minibuffer-setup-hook #'solaire-mode-in-minibuffer))))

(setq electric-pair-mode nil) ; disable auto matching of braces
(setq visible-bell t)
(setq ring-bell-function 'ignore)

;;
;; Prefer vertical window splits to horizontal
;;
(defun split-window-sensibly-prefer-horizontal (&optional window)
"Based on split-window-sensibly, but designed to prefer a horizontal split,
i.e. windows tiled side-by-side."
  (let ((window (or window (selected-window))))
    (or (and (window-splittable-p window t)
         ;; Split window horizontally
         (with-selected-window window
           (split-window-right)))
    (and (window-splittable-p window)
         ;; Split window vertically
         (with-selected-window window
           (split-window-below)))
    (and
         ;; If WINDOW is the only usable window on its frame (it is
         ;; the only one or, not being the only one, all the other
         ;; ones are dedicated) and is not the minibuffer window, try
         ;; to split it horizontally disregarding the value of
         ;; `split-height-threshold'.
         (let ((frame (window-frame window)))
           (or
            (eq window (frame-root-window frame))
            (catch 'done
              (walk-window-tree (lambda (w)
                                  (unless (or (eq w window)
                                              (window-dedicated-p w))
                                    (throw 'done nil)))
                                frame)
              t)))
     (not (window-minibuffer-p window))
     (let ((split-width-threshold 0))
       (when (window-splittable-p window t)
         (with-selected-window window
           (split-window-right))))))))

;;
;; Have sane minimums to determine a vertical vs horizontal split
;;
(setq
   split-height-threshold 4
   split-width-threshold 40
   split-window-preferred-function 'split-window-sensibly-prefer-horizontal)

;;
;; Theme
;;
(set-face-attribute 'default nil :family "Roboto Mono" :weight 'normal :height 130)
(setq-default line-spacing 1)

(if (string-equal system-type "darwin")
    (set-face-attribute 'default nil :height 155))

;; Roboto Mono has no glyphs for box-drawing or block-element characters, so
;; Emacs falls back to an unrelated font for them. That fallback's glyph
;; width rarely matches Roboto Mono's cell width, which breaks the fixed
;; character grid that terminal emulators like eat rely on (e.g. Claude
;; Code's splash screen renders with ragged/misaligned borders). The
;; Nerd-Font-patched "Mono" variant redraws these glyphs to fit exactly
;; within Roboto Mono's own monospace cell, so route those ranges to it.
(when (member "RobotoMono Nerd Font Mono" (font-family-list))
  (set-fontset-font t '(#x2500 . #x257F) "RobotoMono Nerd Font Mono") ; box drawing
  (set-fontset-font t '(#x2580 . #x259F) "RobotoMono Nerd Font Mono")) ; block elements

;; When navigating back to home (~), make the previous part of CWD invsible
(setq file-name-shadow-properties '(invisible t intangible t))

;;
;; Modeline
;;
(setq-default mode-line-format
              '("%e"
                mode-line-front-space
                my/modeline-encoding
                " "
                my/modeline-modified
                mode-line-client
                mode-line-frame-identification
                mode-line-buffer-identification
                "   "
                mode-line-position
                (vc-mode vc-mode)
                "  "
                my/modeline-major-mode
                ;; Push the clock (in `mode-line-misc-info') to the right edge.
                mode-line-format-right-align
                mode-line-misc-info))
                ;;mode-line-end-spaces))

;; Readable replacements for the cryptic left-edge status cluster (`U:**-').
;; Always visible: coding system, end-of-line style, and save state spelled out,
;; e.g. "UTF-8 LF saved" / "UTF-8 CRLF ●" / "latin-1 LF RO".

;; Save state: `RO' when read-only, a red dot for a file with unsaved changes,
;; else "saved". Non-file buffers (scratch, eat, *Messages*) show no state word
;; -- "saved" is meaningless there and a permanent red dot would just be noise.
(defvar-local my/modeline-modified
  '(:eval
    (cond
     (buffer-read-only
      (propertize "RO" 'face 'warning 'help-echo "Read-only buffer"))
     ((and (buffer-modified-p) (buffer-file-name))
      (propertize "●" 'face 'error 'help-echo "Unsaved changes"))
     ((buffer-file-name)
      (propertize "saved" 'help-echo "No unsaved changes"))
     (t "")))
  "Readable modified / read-only indicator (replaces `mode-line-modified').")
(put 'my/modeline-modified 'risky-local-variable t)

;; Coding system + EOL in words: "UTF-8 LF", "UTF-8 CRLF", "latin-1 LF", ...
;; (`mode-line-mule-info' abbreviates all of this down to a cryptic "U:").
(defun my/modeline--encoding ()
  "Readable coding-system + end-of-line style, e.g. \"UTF-8 LF\"."
  (let* ((cs   (or buffer-file-coding-system 'utf-8-unix))
         (base (coding-system-base cs))
         (eol  (coding-system-eol-type cs))
         (name (if (memq base '(utf-8 utf-8-unix prefer-utf-8 undecided))
                   "UTF-8"
                 (replace-regexp-in-string "\\`iso-" "" (symbol-name base))))
         (eol-str (pcase eol (1 "CRLF") (2 "CR") (_ "LF"))))
    (concat name " " eol-str)))

(defvar-local my/modeline-encoding
  '(:eval (my/modeline--encoding))
  "Readable coding/EOL indicator (replaces `mode-line-mule-info').")
(put 'my/modeline-encoding 'risky-local-variable t)


(defvar-local my/modeline-buffer-name
  '(:eval
    (format " %s "
            (propertize (buffer-name) 'face 'my-modeline-red-background)))
  "Mode line constuct to display the buffer name.")


(defun my/modeline--major-mode-name ()
  "Return capitalized 'major-mode' as a string."
  (capitalize (symbol-name major-mode)))

(defvar-local my/modeline-major-mode
  '(:eval
    (list
     (propertize "⚡" 'face 'bold)
     (propertize (my/modeline--major-mode-name) 'face 'bold)))
  "Mode line construct to display the major mode.")

;; Necessary variably property to use locally
(put 'my/modeline-major-mode 'risky-local-variable t)

;; Pulsar, pulse curor on actions
(require 'pulsar)

;; Check the default value of `pulsar-pulse-functions'.  That is where
;; you add more commands that should cause a pulse after they are
;; invoked

(setq pulsar-pulse t)
(setq pulsar-delay 0.055)
(setq pulsar-iterations 10)
(setq pulsar-face 'pulsar-magenta)
(setq pulsar-highlight-face 'pulsar-yellow)

;; Custom hooks to add pulese
(add-hook 'my-previous-window-hook #'pulsar-pulse-line)

(pulsar-global-mode 1)

;; Flash the whole active window when Emacs regains focus from another app, so
;; it's obvious where you've landed on switch-back. `after-focus-change-function'
;; fires on both focus-in and focus-out (and can fire spuriously), so only act
;; on an actual unfocused -> focused transition.
(require 'pulse)

(defface my/focus-flash
  '((t :inherit pulsar-magenta))
  "Face used to flash the active window when Emacs regains focus.")

(defun my/flash-active-window ()
  "Briefly flash and fade the visible region of the selected window.
Uses `pulse.el' so it fades out like a pulsar pulse, but covers the whole
window instead of a single line."
  (let ((win (selected-window)))
    (with-selected-window win
      (pulse-momentary-highlight-region (window-start) (window-end nil t)
                                        'my/focus-flash))))

(defvar my/emacs-had-focus t
  "Non-nil if any Emacs frame had focus at the previous focus-change event.")

(defun my/pulse-on-focus-gain ()
  "Flash the active window when an Emacs frame gains focus."
  (let ((focused (and (seq-some #'frame-focus-state (frame-list)) t)))
    (when (and focused (not my/emacs-had-focus))
      (my/flash-active-window))
    (setq my/emacs-had-focus focused)))

(add-function :after after-focus-change-function #'my/pulse-on-focus-gain)

;; Return back to the position in the file you last visited
(save-place-mode 1)

(provide 'init-ui)

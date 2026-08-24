;; Keybindings
;; Ensure default undo behavior
(global-set-key (kbd "C-/") 'undo)
(global-set-key [C-backspace] 'backward-kill-word)
;; Prevent M-backspace from sending to kill ring; useful in terminal emacs where C-backspace is unavailable
(global-set-key [M-backspace] 'backward-kill-word)
(global-unset-key (kbd "M-DEL"))
(global-set-key (kbd "M-DEL") 'backward-kill-word)
(global-set-key (kbd "C-;") 'consult-yank-from-kill-ring)

(global-set-key (kbd "C-<f5>") 'mlinum-mode)
;; Bind goto-line under M-g M-g so the M-g prefix map stays intact
;; (M-g n / M-g p navigate flymake/eglot diagnostics via next-error).
(global-set-key (kbd "M-g M-g") 'goto-line)
(global-set-key "\M-l" 'copy-current-line-position-to-clipboard)
(global-set-key (kbd "C-x C-e") 'eval-and-replace)
(global-set-key '[f9] 'c-beginning-of-defun)
(global-set-key '[f10] 'c-end-of-defun)
(global-set-key '[f11] 'copy-region-as-kill)
(global-set-key '[f12] 'my-copy-c-function)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key [C-tab] 'toggle-fold)
(global-set-key (kbd "C-.") 'hs-show-all)

;; When using emacs in terminal, override default copy with clipetty
(unless (display-graphic-p)
  (global-set-key "\M-w" 'clipetty-kill-ring-save))

;; MacOS Specific
(setq mac-command-modifier 'meta)

;; Expand-region
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "C--") 'er/contract-region)

;; Append-line-to-scratch
(global-set-key (kbd "M-]") 'append-line-to-scratch)

;; General navigation commands
(global-set-key (kbd "C-s") 'consult-line)
(global-set-key (kbd "C-M-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-M-r") 'isearch-backward-regexp)
(global-set-key (kbd "M-x") 'execute-extended-command)
(global-set-key (kbd "C-x C-f") 'find-file)

(use-package consult-ls-git
  :ensure t
  :bind
  (("C-c g" . #'consult-ls-git)))

;; Other commands
(global-set-key (kbd "C-x C-i") 'consult-imenu)
(global-set-key (kbd "C-c f") #'deadgrep)

;; Window movements
(defvar my-previous-window-hook nil
  "Hook for moving to previous window")

(defun my-previous-window ()
  (interactive)
  (other-window -1)
  (run-hooks 'my-previous-window-hook))
(global-set-key (kbd "C-x p") 'my-previous-window)

;; tmux-style split glyphs (mirrors ~/.tmux.conf.local `bind |' / `bind -').
;; The glyph looks like the resulting divider:
;;   C-x |  -> side-by-side panes (vertical divider)   [split-window-right]
;;   C-x -  -> stacked panes      (horizontal divider)  [split-window-below]
;; NOTE: `C-x -' shadows the rarely-used `shrink-window-if-larger-than-buffer'.
(global-set-key (kbd "C-x |") 'split-window-right)
(global-set-key (kbd "C-x -") 'split-window-below)

;; ace-window: the tmux `<prefix> q' analog -- overlay a number on each window
;; and press it to jump. Bound over `C-x o'. `aw-dispatch-always' t makes it
;; ALWAYS flash the labels (even with just 2 windows), just like tmux's
;; display-panes, rather than silently switching. Number labels mirror tmux's
;; pane numbers (swap `aw-keys' to home-row letters if you prefer).
(use-package ace-window
  :ensure t
  :bind (("C-x o" . ace-window))
  :config
  (setq aw-keys '(?1 ?2 ?3 ?4 ?5 ?6 ?7 ?8 ?9)
        aw-scope 'frame                 ; only this frame's windows
        aw-background t                 ; dim other windows while choosing
        aw-dispatch-always t)           ; always show the number labels
  ;; Big, bold corner number (also the terminal fallback below). No `:family'
  ;; is set, so it renders in your default Emacs font. Color inherits the
  ;; theme's `warning' face so it matches the active theme instead of
  ;; ace-window's hardcoded red -- swap the inherited face (e.g. `success',
  ;; `link', `font-lock-keyword-face') for a different accent.
  (set-face-attribute 'aw-leading-char-face nil
                      :inherit 'warning
                      :foreground 'unspecified
                      :weight 'bold
                      :height 5.0)

  ;; --- big, CENTERED per-window labels via posframe (tmux display-panes) ----
  ;; Swap ace-window's display/cleanup hooks for ones that float a large number
  ;; in a child frame centered in each window. GUI only; terminals fall back to
  ;; the corner overlay above. NOTE: do NOT pass `:position 0' to posframe --
  ;; position 0 is an invalid buffer position (they start at 1) and posframe
  ;; does `goto-char' on it -> "Args out of range: 0". Omitting it defaults to
  ;; point, which the window-center poshandler ignores anyway.
  (require 'posframe)

  (defface my/aw-posframe-face '((t :inherit warning :weight bold :height 6.0))
    "Face for the big centered ace-window number.")

  (defvar my/aw-posframe-buffers nil
    "Posframe buffers currently shown for an ace-window selection.")

  (defun my/aw-lead-overlay-posframe (path leaf)
    "Float PATH's number centered in LEAF's window via a posframe.
LEAF is (PT . WND).  Falls back to the corner overlay in a terminal."
    (if (not (display-graphic-p))
        (aw--lead-overlay path leaf)
      (let* ((wnd (cdr leaf))
             (label (string (avy--key-to-char (car (last path)))))
             (buf (format " *aw-posframe %s*" wnd)))
        (with-selected-window wnd
          (posframe-show
           buf
           :string (propertize (format " %s " label) 'face 'my/aw-posframe-face)
           :poshandler #'posframe-poshandler-window-center
           :internal-border-width 4
           :internal-border-color (face-foreground 'warning nil t)
           :background-color (face-background 'default nil t)))
        (push buf my/aw-posframe-buffers))))

  (defun my/aw-remove-posframes (&rest _)
    "Delete the ace-window selection posframes."
    (dolist (buf my/aw-posframe-buffers)
      (posframe-delete buf))
    (setq my/aw-posframe-buffers nil)
    (avy--remove-leading-chars))

  (setq aw--lead-overlay-fn #'my/aw-lead-overlay-posframe
        aw--remove-leading-chars-fn #'my/aw-remove-posframes))

;; which-key: popup listing available keys after a prefix (e.g. `C-c l',
;; `C-x', `M-g'). Built into Emacs 30 — no package needed. Uses the
;; traditional bottom-of-frame popup.
(setq which-key-idle-delay 0.4)   ; pause before the popup appears (default 1.0)
(which-key-mode 1)

(provide 'init-keybindings)

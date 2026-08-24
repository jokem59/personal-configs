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

;; Buffer handling. `consult-buffer' for switching -- live preview and
;; narrowable sources (open buffers, recent files, bookmarks, project buffers;
;; narrow with `b'/`f'/`p' SPC). `ibuffer' as a full buffer manager (mark,
;; bulk-kill, sort) in place of the plain buffer list.
(global-set-key (kbd "C-x b")   #'consult-buffer)
(global-set-key (kbd "C-x C-b") #'ibuffer)

;; Quick buffer rename. `rename-buffer' is only reachable via `M-x'; bind it and
;; prefill the current name so you edit rather than retype -- handy for giving
;; eat/declawd sessions (`*eat*<6>', `*declawd*') distinct names. The `unique'
;; arg auto-suffixes <2>, <3>... on a name clash instead of erroring.
;;
;; Bound under `C-x' (not `C-c'): init-eat.el makes bare `C-c' send SIGINT in
;; eat, so a `C-c'-prefixed key never reaches Emacs in a terminal buffer -- the
;; exact place we most want to rename. `C-x' is in `eat-semi-char-non-bound-keys',
;; so eat lets it fall through to Emacs (same reason `C-x b'/`C-x q' work in eat).
;; `C-x C-r' only shadows the rarely-used `find-file-read-only'.
(defun my/rename-buffer ()
  "Rename the current buffer, offering its current name for editing."
  (interactive)
  (rename-buffer (read-string "Rename buffer to: " (buffer-name)) 'unique))
(global-set-key (kbd "C-x C-r") #'my/rename-buffer)

;; Auto-group the ibuffer list by project (built-in project.el) so buffers
;; cluster by repo; buffers with no project fall into ibuffer's Default group.
(defun my/ibuffer-project-filter-groups ()
  "Return `ibuffer' filter groups, one per project root among live buffers."
  (let (roots)
    (dolist (buf (buffer-list))
      (when-let* ((root (with-current-buffer buf
                          (when-let ((p (project-current nil)))
                            (expand-file-name (project-root p))))))
        (unless (assoc root roots)
          (push (cons root (file-name-nondirectory (directory-file-name root)))
                roots))))
    (mapcar (lambda (r)
              (list (cdr r)
                    `(predicate . (when-let ((p (project-current nil)))
                                    (equal (expand-file-name (project-root p))
                                           ,(car r))))))
            (nreverse roots))))

(add-hook 'ibuffer-hook
          (lambda ()
            (setq ibuffer-filter-groups (my/ibuffer-project-filter-groups))
            (ibuffer-update nil t)))

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
;;   C-x | , C-x \  -> side-by-side panes (vertical divider)   [split-window-right]
;;   C-x -          -> stacked panes      (horizontal divider)  [split-window-below]
;; Like tmux, focus moves INTO the new pane after splitting -- the plain
;; `split-window-*' commands leave point in the original window, so wrap them
;; to select the window they return. `C-x \' is a Shift-free alias for `C-x |';
;; `C-x -' shadows the rarely-used `shrink-window-if-larger-than-buffer'.
(defun my/split-window-right-focus ()
  "Split side by side and move focus into the new (right) window."
  (interactive)
  (select-window (split-window-right)))
(defun my/split-window-below-focus ()
  "Split stacked and move focus into the new (below) window."
  (interactive)
  (select-window (split-window-below)))
(global-set-key (kbd "C-x |")  #'my/split-window-right-focus)
(global-set-key (kbd "C-x \\") #'my/split-window-right-focus)
(global-set-key (kbd "C-x -")  #'my/split-window-below-focus)

;; ace-window: the tmux `<prefix> q' analog -- overlay a number on each window
;; and press it to jump. Bound to `C-x q' (mirroring tmux's `prefix q'); plain
;; `C-x o' stays `other-window' for quick cycling. With `aw-dispatch-always'
;; nil, 2 windows switch directly and 3+ show the number labels (matching
;; tmux). Number labels mirror tmux's pane numbers (swap `aw-keys' to home-row
;; letters if you prefer).
(use-package ace-window
  :ensure t
  :bind (("C-x q" . ace-window))
  :config
  (setq aw-keys '(?1 ?2 ?3 ?4 ?5 ?6 ?7 ?8 ?9)
        aw-scope 'frame                 ; only this frame's windows
        aw-background t                 ; dim other windows while choosing
        aw-dispatch-always nil)         ; 2 windows: switch directly; 3+: show labels
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
;; `C-x', `M-g'). Built into Emacs 30 — no package needed. Show it in the
;; minibuffer (like consult/vertico) rather than a posframe or side window.
(setq which-key-idle-delay 0.4      ; pause before the popup appears (default 1.0)
      which-key-popup-type 'minibuffer)
(which-key-mode 1)

(provide 'init-keybindings)

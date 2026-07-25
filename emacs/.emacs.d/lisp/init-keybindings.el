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

;; which-key: helix-style popup listing available keys after a prefix
;; (e.g. `C-c l', `C-x', `M-g'). Built into Emacs 30 — no package needed.
(setq which-key-idle-delay 0.4)   ; pause before the popup appears (default 1.0)
(which-key-mode 1)

;; Show the which-key menu as a floating child-frame anchored just below point
;; (helix-style), in GUI frames only. Child frames aren't available in a
;; terminal, so there we fall back to the default bottom popup. Under the
;; daemon the initial frame is non-graphical, so decide per-frame via a hook.
(when (require 'which-key-posframe nil t)
  (setq which-key-posframe-poshandler #'posframe-poshandler-point-bottom-left-corner)
  (defun my/which-key-posframe-per-frame (&optional frame)
    (with-selected-frame (or frame (selected-frame))
      (which-key-posframe-mode (if (display-graphic-p) 1 -1))))
  (add-hook 'server-after-make-frame-hook #'my/which-key-posframe-per-frame)
  (add-hook 'after-make-frame-functions   #'my/which-key-posframe-per-frame)
  (my/which-key-posframe-per-frame))

(provide 'init-keybindings)

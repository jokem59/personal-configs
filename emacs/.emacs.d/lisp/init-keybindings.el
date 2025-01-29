;; Keybindings
;; Ensure default undo behavior
(global-set-key (kbd "C-/") 'undo)
(global-set-key [C-backspace] 'backward-delete-word)
;; Prevent M-backspace from sending to kill ring; useful in terminal emacs where C-backspace is unavailable
(global-set-key [M-backspace] 'backward-delete-word)
(global-unset-key (kbd "M-DEL"))
(global-set-key (kbd "M-DEL") 'backward-delete-word)
(global-set-key (kbd "C-<f5>") 'mlinum-mode)
(global-set-key "\M-g" 'goto-line)
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

(provide 'init-keybindings)

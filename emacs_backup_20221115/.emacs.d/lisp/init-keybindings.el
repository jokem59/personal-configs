;;
;; Keybindings
;;

(global-set-key [C-backspace] 'backward-delete-word)
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

;; MacOS Specific
(setq mac-command-modifier 'meta)

;; Movements

(global-set-key (kbd "C-;") 'avy-goto-line)
(global-set-key (kbd "C-:") 'avy-goto-char-timer)
;; Sets the timeout for avy-goto-char-timer
(setq avy-timeout-seconds 0.15)

(global-set-key (kbd "C-S-n")
                (lambda ()
                  (interactive)
                  (ignore-errors (next-line 5))))

(global-set-key (kbd "C-S-p")
                (lambda ()
                  (interactive)
                  (ignore-errors (previous-line 5))))

(global-set-key (kbd "C-S-f")
                (lambda ()
                  (interactive)
                  (ignore-errors (forward-char 5))))

(global-set-key (kbd "C-S-b")
                (lambda ()
                  (interactive)
                  (ignore-errors (backward-char 5))))

;; Expand-region
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "C--") 'er/contract-region)

;; Highlight-symbols
(global-set-key [(control f1)] 'hl-highlight-mode)
(global-set-key [(control f2)] 'hl-highlight-thingatpt-local)
(global-set-key [f2] 'hl-find-next-thing)
(global-set-key [(shift f2)] 'hl-find-prev-thing)
;(global-set-key [(meta f2)] 'highlight-symbol-query-replace)

;; Highlight2Clipboard
(global-set-key [(meta f8)]
                'copy-region-as-richtext-to-clipboard)

;; append-line-to-scratch
(global-set-key (kbd "M-]") 'append-line-to-scratch)

;; Ivy-based replacement for standard commands
(global-set-key (kbd "C-s") 'swiper)
(global-set-key (kbd "C-r") 'swiper-backward)
(define-key ivy-minibuffer-map (kbd "C-r") 'ivy-previous-line-or-history)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
;; Ivy-based interface to shell and system tools
(global-set-key (kbd "C-c g") 'counsel-git)
;; Other commands
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "C-x C-i") 'counsel-imenu)

(global-set-key (kbd "C-c f") #'deadgrep)

;; Window movements
(defun myprevious-window ()
  (interactive)
  (other-window -1))
(global-set-key (kbd "C-x p") 'myprevious-window)

(provide 'init-keybindings)

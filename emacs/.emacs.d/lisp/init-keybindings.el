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

;; Movements
;; Jump brackets Vi style
(defun zz/goto-match-paren (arg)
  "Go to the matching paren/bracket, otherwise (or if ARG is not nil) insert %.
  vi style of % jumping to matching brace."
  (interactive "p")
  (if (not (memq last-command '(set-mark
                                cua-set-mark
                                zz/goto-match-paren
                                down-list
                                up-list
                                end-of-defun
                                beginning-of-defun
                                backward-sexp
                                forward-sexp
                                backward-up-list
                                forward-paragraph
                                backward-paragraph
                                end-of-buffer
                                beginning-of-buffer
                                backward-word
                                forward-word
                                mwheel-scroll
                                backward-word
                                forward-word
                                mouse-start-secondary
                                mouse-yank-secondary
                                mouse-secondary-save-then-kill
                                move-end-of-line
                                move-beginning-of-line
                                backward-char
                                forward-char
                                scroll-up
                                scroll-down
                                scroll-left
                                scroll-right
                                mouse-set-point
                                next-buffer
                                previous-buffer
                                previous-line
                                next-line
                                back-to-indentation
                                )))
      (self-insert-command (or arg 1))
    (cond ((looking-at "\\s\(") (sp-forward-sexp) (backward-char 1))
          ((looking-at "\\s\)") (forward-char 1) (sp-backward-sexp))
          (t (self-insert-command (or arg 1))))))
(global-set-key (kbd "M-%") 'zz/goto-match-paren)

;; Viper-cmd sets foward/backwards word to be consistent with VIM/VSCode and other editors
(require `viper-cmd)
(global-set-key (kbd "M-f") 'viper-forward-word)
(global-set-key (kbd "M-b") 'viper-backward-word)

(global-set-key (kbd "C-;") 'avy-goto-line)
(global-set-key (kbd "C-'") 'avy-goto-char-timer)
;; Sets the timeout for avy-goto-char-timer
(setq avy-timeout-seconds 0.5)

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

;; Multiple-cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

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
; (global-set-key (kbd "C-s") 'swiper)
; (global-set-key (kbd "C-r") 'swiper)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
;; Ivy-based interface to shell and system tools
(global-set-key (kbd "C-c g") 'counsel-git)
;; Other commands
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "C-x C-i") 'counsel-imenu)

(global-set-key (kbd "C-c f") #'deadgrep)

(provide 'init-keybindings)

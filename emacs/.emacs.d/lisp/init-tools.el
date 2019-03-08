;; git-messenger
(require 'git-messenger)
(global-set-key (kbd "C-x v p") 'git-messenger:popup-message)

;; prog-fill
(require 'prog-fill)
(add-hook
 'prog-mode-hook
 (lambda () (local-set-key (kbd "M-q") #'prog-fill)))
(setq prog-fill-floating-open-paren-p 'nil)
(setq prog-fill-floating-close-paren-p 'nil)

;; Set-up origami
(require 'origami)
(global-origami-mode)

;; shell-pop

;; (custom-set-variables
;;  '(shell-pop-universal-key "C-t")
;;  '(shell-pop-window-size 30)
;;  '(shell-pop-full-span t)
;;  '(shell-pop-window-position "bottom"))

(setq explicit-shell-file-name "c:\\windows\\system32\\WindowsPowerShell\\v1.0\\powershell.exe")
(setq explicit-shell-file-name "C:/windows/system32/WindowsPowerShell/v1.0/powershell.exe")
(setq shell-pop-window-position "bottom")
(setq shell-pop-full-span t)
(setq shell-pop-window-size 30)
(setq shell-file-name "powershell")(setq explicit-powershell.exe-args '("-Command" "-" )) ;

(global-set-key (kbd "C-t") 'shell-pop)

(add-hook 'shell-mode-hook (lambda ()
                             (setq show-trailing-whitespace nil)))

(provide 'init-tools)

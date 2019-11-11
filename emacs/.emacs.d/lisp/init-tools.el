;; Enable Hide Show minor mode globally
(add-hook 'prog-mode-hook 'hs-minor-mode)

(setq explicit-shell-file-name "c:\\windows\\system32\\WindowsPowerShell\\v1.0\\powershell.exe")
(setq explicit-shell-file-name "C:/windows/system32/WindowsPowerShell/v1.0/powershell.exe")
(setq shell-pop-window-position "bottom")
(setq shell-pop-full-span t)
(setq shell-pop-window-size 30)
(setq shell-file-name "powershell")(setq explicit-powershell.exe-args '("-Command" "-" )) ;

(global-set-key (kbd "C-t") 'shell-pop)

(add-hook 'shell-mode-hook (lambda ()
                             (setq show-trailing-whitespace nil)))

;; EDiff config
(custom-set-variables
 '(ediff-split-window-function (quote split-window-horizontally))  ;; Split side by side
 '(ediff-window-setup-function (quote ediff-setup-windows-plain))) ;; Prevent popu

(provide 'init-tools)

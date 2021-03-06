       ;; (setq shell-file-name "powershell")))

(cond ((eq system-type 'windows-nt)
       ;; Windows-specific code goes here.
       (setq explicit-shell-file-name "c:\\windows\\system32\\WindowsPowerShell\\v1.0\\powershell.exe")
       (setq explicit-shell-file-name "C:/windows/system32/WindowsPowerShell/v1.0/powershell.exe")
       (setq explicit-powershell.exe-args '("-Command" "-" )))
       ((eq system-type 'gnu/linux)
       ;; Linux-specific code goes here.
       (setq explicit-shell-file-name "/bin/bash")
       ))

;; Enable Hide Show minor mode globally
(add-hook 'prog-mode-hook 'hs-minor-mode)

(setq shell-pop-window-position "bottom")
(setq shell-pop-full-span t)
(setq shell-pop-window-size 30)


(global-set-key (kbd "C-t") 'shell-pop)

(add-hook 'shell-mode-hook (lambda ()
                             (setq show-trailing-whitespace nil)))

;; Undo-tree
(global-undo-tree-mode)

;; EDiff config
(custom-set-variables
 '(ediff-split-window-function (quote split-window-horizontally))  ;; Split side by side
 '(ediff-window-setup-function (quote ediff-setup-windows-plain))) ;; Prevent popu

(provide 'init-tools)

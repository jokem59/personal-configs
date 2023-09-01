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

;; Undo-tree
(global-undo-tree-mode)

;; EDiff config
(custom-set-variables
 '(ediff-split-window-function (quote split-window-horizontally))  ;; Split side by side
 '(ediff-window-setup-function (quote ediff-setup-windows-plain))) ;; Prevent popu

;; Simple shell config to prevent Tramp/SSH from hanging
(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable to match
that used by the user's shell.

This is particularly useful under Mac OS X and macOS, where GUI
apps are not started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string
			  "[ \t\n]*$" "" (shell-command-to-string
					  "$SHELL --login -c 'echo $PATH'"
						    ))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(set-exec-path-from-shell-PATH)

;; dumb-jump setup
(add-hook 'xref-backend-functions #'dumb-jump-xref-activate)

;; Impatient mode to render markdown
(defun markdown-html (buffer)
  (princ (with-current-buffer buffer
           (format "<!DOCTYPE html><html><title>Impatient Markdown</title><xmp theme=\"united\" style=\"display:none;\"> %s  </xmp><script src=\"http://ndossougbe.github.io/strapdown/dist/strapdown.js\"></script></html>" (buffer-substring-no-properties (point-min) (point-max))))
         (current-buffer)))

(provide 'init-tools)

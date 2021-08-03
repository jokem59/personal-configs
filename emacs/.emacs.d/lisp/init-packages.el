(require 'package)

(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)
(setq package-enable-at-startup nil)

(defvar jokem/packages '(; misc / tools
                         use-package
                         org-roam
                         avy
                         git-gutter
                         ivy
                         ivy-rich
                         smex
                         counsel
                         golden-ratio
                         expand-region
                         deadgrep
                         smart-mode-line
                         smart-mode-line-atom-one-dark-theme
                         undo-tree
                         all-the-icons
                         lsp-mode

                         ; modes
                         log4j-mode
                         powershell
                         magit

                         ; language modes
                         csharp-mode
                         markdown-mode
                         yaml-mode
                         js3-mode
                         web-mode
                         tide
                         rust-mode

                         ; UI
                         doom-modeline
                         solaire-mode

                         ivy-posframe
                         ivy-rich

                        ; themes
                         gruvbox-theme
                         doom-themes
                         )
  "Default packages")

(require 'cl-lib)

(defun jokem/packages-installed-p ()
  (cl-loop for pkg in jokem/packages
        when (not (package-installed-p pkg)) do (cl-return nil)
        finally (return t)))

(unless (jokem/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg jokem/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

;; Update packages if available and not already marked for update
(when (not package-archive-contents)
    (package-refresh-contents))

(provide 'init-packages)

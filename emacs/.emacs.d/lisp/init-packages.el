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
                         undo-tree
                         dumb-jump
                         company
                         flycheck
                         org-tree-slide

                         ; modes
                         log4j-mode
                         powershell
                         magit
                         solaire-mode

                         ; language modes
                         csharp-mode
                         ;;markdown-mode
                         yaml-mode
                         js3-mode
                         web-mode
                         tide

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

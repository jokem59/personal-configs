(require 'package)

;; (add-to-list 'package-archives
;; 	     '("melpa" . "https://melpa.org/packages/") t)

;; Use these mirrors if there are issues getting to the official melpa source
(setq package-archives
      '(("melpa" . "https://raw.githubusercontent.com/d12frosted/elpa-mirror/master/melpa/")
        ("org"   . "https://raw.githubusercontent.com/d12frosted/elpa-mirror/master/org/")
        ("gnu"   . "https://raw.githubusercontent.com/d12frosted/elpa-mirror/master/gnu/")))

(package-initialize)
(setq package-enable-at-startup nil)

(defvar jokem/packages '(; misc / tools
                         use-package
                         all-the-icons
                         all-the-icons-completion
                         org-roam
                         smex
                         golden-ratio
                         expand-region
                         deadgrep
                         undo-tree
                         dumb-jump
                         company
                         flycheck
                         org-tree-slide
                         vertico
                         consult
                         consult-ls-git
                         marginalia
                         orderless
                         auto-complete
                         pulsar
                         git-gutter
                         clipetty

                         ; mail
                         mu4e-column-faces

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

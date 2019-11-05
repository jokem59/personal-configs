(require 'package)

(setq package-archives '(("org"   . "http://orgmode.org/elpa/")
                         ("gnu"   . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

(package-initialize)
(require 'package)
(setq package-enable-at-startup nil)

(defvar jokem/packages '(; misc / tools
                         avy
                         git-gutter
                         ivy
                         counsel
                         golden-ratio
                         expand-region

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

                        ; themes
			             gruvbox-theme
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

(provide 'init-packages)

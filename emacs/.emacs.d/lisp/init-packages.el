(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)

(defvar jokem/packages '(; misc / tools
                          use-package
                          auto-complete
                          autopair
                          gist
                          htmlize
                          restclient
                          multiple-cursors
                          expand-region
                          highlight-symbol
                          smex
                          highlight2clipboard
                          hl-anything
                          git-messenger
                          git-gutter
                          ivy
                          swiper
                          counsel
                          counsel-gtags
                          prog-fill
                          shell-pop
                          golden-ratio
                          flycheck
                          spaceline
                          anzu
                          deadgrep
                          avy

                          ; modes
                          company
                          log4j-mode
                          ggtags
                          projectile
                          rainbow-delimiters
                          flx-ido
                          ido-vertical-mode
                          powershell
                          magit

                          ; language modes
                          csharp-mode
                          fsharp-mode
                          markdown-mode
                          yaml-mode
                          js3-mode
                          web-mode
                          tide
                          rust-mode
                          flycheck-rust

                          ; themes
                          molokai-theme
                          monokai-theme
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

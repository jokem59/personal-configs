(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(make-directory "~/.saves" t)

(when window-system
  (server-start))

(require 'init-packages)
(require 'init-ui)
(require 'init-utils)
(require 'init-tools)
(require 'init-org)
(require 'init-magit)
(require 'init-language-base)
(require 'init-keybindings)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("f67e72c4702e4155d29f5b0d4d7854d31421af26fc71e6e27ddb377c8a80d348" "1436d643b98844555d56c59c74004eb158dc85fc55d2e7205f8d9b8c860e177f" "bc75dfb513af404a26260b3420d1f3e4131df752c19ab2984a7c85def9a2917e" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default)))
 '(ediff-split-window-function (quote split-window-horizontally))
 '(ediff-window-setup-function (quote ediff-setup-windows-plain))
 '(org-agenda-files (quote ("~/OneDrive/org/journal.org")))
 '(package-selected-packages
   (quote
    (undo-tree all-the-icons smex company smart-mode-line-atom-one-dark-theme smart-mode-line avy expand-region rust-mode tide web-mode js3-mode yaml-mode markdown-mode csharp-mode log4j-mode git-gutter gruvbox-theme doom-themes))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:background "gray20" :foreground nil))))
 '(mode-line-inactive ((t (:background "dim gray")))))

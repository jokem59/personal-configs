(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

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
    ("7b50dc95a32cadd584bda3f40577e135c392cd7fb286a468ba4236787d295f4b" "a22f40b63f9bc0a69ebc8ba4fbc6b452a4e3f84b80590ba0a92b4ff599e53ad0" "585942bb24cab2d4b2f74977ac3ba6ddbd888e3776b9d2f993c5704aa8bb4739" "bc75dfb513af404a26260b3420d1f3e4131df752c19ab2984a7c85def9a2917e" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default)))
 '(ediff-split-window-function (quote split-window-horizontally))
 '(ediff-window-setup-function (quote ediff-setup-windows-plain))
 '(nhexl-line-width 8)
 '(org-agenda-files (quote ("~/Sync/org/journal.org")))
 '(package-selected-packages
   (quote
    (nhexl-mode undo-tree all-the-icons smex company smart-mode-line-atom-one-dark-theme smart-mode-line avy expand-region rust-mode tide web-mode js3-mode yaml-mode markdown-mode csharp-mode log4j-mode git-gutter gruvbox-theme doom-themes)))
 '(quote (org-agenda-files (quote ("~/Sync/org/journal.org")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:background "gray20" :foreground nil))))
 '(mode-line-inactive ((t (:background "dim gray")))))

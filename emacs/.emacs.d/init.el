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
					;(require 'init-language-rust)
(require 'init-language-web)

(require 'init-keybindings)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#272822" "#F92672" "#A6E22E" "#E6DB74" "#66D9EF" "#FD5FF0" "#A1EFE4" "#F8F8F2"])
 '(compilation-message-face (quote default))
 '(custom-safe-themes
   (quote
    ("11e57648ab04915568e558b77541d0e94e69d09c9c54c06075938b6abc0189d8" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "bd7b7c5df1174796deefce5debc2d976b264585d51852c962362be83932873d9" "c7a9a68bd07e38620a5508fef62ec079d274475c8f92d75ed0c33c45fbe306bc" "fa11f855b5f606f84e50106a7360c72aac88fee5f6fb8084aa4329009b61c5a2" "c3d385d9214f5b613e85fcaa2f746e52d272dbcceaaeea480ad3244a815882e7" "49de25b465bc3c2498bcd4c1575fa0090bd56fc79cdb49b919b49eaea17ee1dd" "ac88f5baa9b100652e0cc1d5891e66283d43a2b263cef048c3bff102983c29df" "86f4407f65d848ccdbbbf7384de75ba320d26ccecd719d50239f2c36bec18628" "a99e7c91236b2aba4cd374080c73f390c55173c5a1b4ac662eeb3172b60a9814" "0e121ff9bef6937edad8dfcff7d88ac9219b5b4f1570fd1702e546a80dba0832" "60f04e478dedc16397353fb9f33f0d895ea3dab4f581307fbf0aa2f07e658a40" default)))
 '(fci-rule-color "#3C3D37")
 '(flymake-proc-allowed-file-name-masks
   (quote
    (("\\.xml\\'" flymake-xml-init nil nil)
     ("\\.html?\\'" flymake-xml-init nil nil)
     ("\\.cs\\'" csharp-flymake-init csharp-flymake-cleanup nil)
     ("\\.p[ml]\\'" flymake-perl-init nil nil)
     ("\\.php[345]?\\'" flymake-php-init nil nil)
     ("\\.h\\'" flymake-master-make-header-init flymake-master-cleanup nil)
     ("\\.java\\'" flymake-simple-make-java-init flymake-simple-java-cleanup nil)
     ("[0-9]+\\.tex\\'" flymake-master-tex-init flymake-master-cleanup nil)
     ("\\.tex\\'" flymake-simple-tex-init nil nil)
     ("\\.idl\\'" flymake-simple-make-init nil nil))))
 '(highlight-changes-colors (quote ("#FD5FF0" "#AE81FF")))
 '(highlight-tail-colors
   (quote
    (("#3C3D37" . 0)
     ("#679A01" . 20)
     ("#4BBEAE" . 30)
     ("#1DB4D0" . 50)
     ("#9A8F21" . 60)
     ("#A75B00" . 70)
     ("#F309DF" . 85)
     ("#3C3D37" . 100))))
 '(hl-highlight-mode t)
 '(irony-additional-clang-options (quote ("-G" "Visual Studio 14 2015 Win64")))
 '(irony-extra-cmake-args (quote ("-G" "Visual Studio 14 2015 Win64")))
 '(js3-auto-indent-p t)
 '(js3-bounce-indent-p t)
 '(js3-consistent-level-indent-inner-bracket t)
 '(js3-enter-indents-newline t)
 '(js3-indent-dots t)
 '(js3-indent-level 4)
 '(js3-indent-on-enter-key t)
 '(js3-visitor-offset t t)
 '(linum-format " %7i ")
 '(magit-diff-use-overlays nil)
 '(org-agenda-files (quote ("~/OneDrive/org/journal.org")))
 '(package-selected-packages
   (quote
    (smartparens avy python-mode deadgrep spaceline-all-the-icons anzu spaceline cquery ccls dash lsp-ui lsp-mode rust-playground flycheck-rust rust-mode js2-mode zen-mode counsel-gtags counsel swiper ivy ripgrep prog-fill org-mime shell-pop git-messenger itail git-gutter zzz-to-char irony flycheck-clangcheck flycheck tide hl-anything less-css-mode web-mode typescript-mode magit yaml-mode smex restclient rainbow-delimiters projectile powershell omnisharp monokai-theme molokai-theme  markdown-mode log4j-mode ido-vertical-mode highlight2clipboard groovy-mode fsharp-mode flx-ido expand-region csharp-mode company autopair)))
 '(pos-tip-background-color "#FFFACE")
 '(pos-tip-foreground-color "#272822")
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#F92672")
     (40 . "#CF4F1F")
     (60 . "#C26C0F")
     (80 . "#E6DB74")
     (100 . "#AB8C00")
     (120 . "#A18F00")
     (140 . "#989200")
     (160 . "#8E9500")
     (180 . "#A6E22E")
     (200 . "#729A1E")
     (220 . "#609C3C")
     (240 . "#4E9D5B")
     (260 . "#3C9F79")
     (280 . "#A1EFE4")
     (300 . "#299BA6")
     (320 . "#2896B5")
     (340 . "#2790C3")
     (360 . "#66D9EF"))))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (quote
    (unspecified "#272822" "#3C3D37" "#F70057" "#F92672" "#86C30D" "#A6E22E" "#BEB244" "#E6DB74" "#40CAE4" "#66D9EF" "#FB35EA" "#FD5FF0" "#74DBCD" "#A1EFE4" "#F8F8F2" "#F8F8F0"))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-level-4 ((t (:inherit default :foreground "#E6DB74" :weight bold :height 1.1))))
 '(org-tag ((t nil))))

(provide 'init)


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

;; (package-initialize)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(if (string-equal system-type "darwin")
    ()
    (when window-system
      (server-start)))

(require 'init-packages)
(require 'init-ui)
(require 'init-utils)
(require 'init-tools)
(require 'init-org)
(require 'init-org-roam)
(require 'init-magit)
(require 'init-language-base)
(require 'init-keybindings)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#282a36" "#ff5555" "#50fa7b" "#f1fa8c" "#61bfff" "#ff79c6" "#8be9fd" "#f8f8f2"])
 '(custom-safe-themes
   (quote
    ("1d5e33500bc9548f800f9e248b57d1b2a9ecde79cb40c0b1398dec51ee820daf" "234dbb732ef054b109a9e5ee5b499632c63cc24f7c2383a849815dacc1727cb6" "7eea50883f10e5c6ad6f81e153c640b3a288cd8dc1d26e4696f7d40f754cc703" "7a7b1d475b42c1a0b61f3b1d1225dd249ffa1abb1b7f726aec59ac7ca3bf4dae" "a9a67b318b7417adbedaab02f05fa679973e9718d9d26075c6235b1f0db703c8" "0466adb5554ea3055d0353d363832446cd8be7b799c39839f387abb631ea0995" "8146edab0de2007a99a2361041015331af706e7907de9d6a330a3493a541e5a6" "6b5c518d1c250a8ce17463b7e435e9e20faa84f3f7defba8b579d4f5925f60c1" "e2acbf379aa541e07373395b977a99c878c30f20c3761aac23e9223345526bcc" "71e5acf6053215f553036482f3340a5445aee364fb2e292c70d9175fb0cc8af7" "76bfa9318742342233d8b0b42e824130b3a50dcc732866ff8e47366aed69de11" "be9645aaa8c11f76a10bcf36aaf83f54f4587ced1b9b679b55639c87404e2499" "7b50dc95a32cadd584bda3f40577e135c392cd7fb286a468ba4236787d295f4b" "a22f40b63f9bc0a69ebc8ba4fbc6b452a4e3f84b80590ba0a92b4ff599e53ad0" "585942bb24cab2d4b2f74977ac3ba6ddbd888e3776b9d2f993c5704aa8bb4739" "bc75dfb513af404a26260b3420d1f3e4131df752c19ab2984a7c85def9a2917e" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default)))
 '(doom-modeline-vcs-max-length 20)
 '(ediff-split-window-function (quote split-window-horizontally))
 '(ediff-window-setup-function (quote ediff-setup-windows-plain))
 '(exec-path
   (quote
    ("~/.cargo/bin" "/usr/local/sbin" "/usr/local/bin" "/usr/sbin" "/usr/bin" "/sbin" "/bin" "/usr/games" "/usr/local/games" "/snap/bin")))
 '(exwm-floating-border-color "#242530")
 '(fci-rule-color "#6272a4")
 '(find-name-arg "-iname")
 '(highlight-tail-colors
   ((("#2c3e3c" "#2a3b2e" "green")
     . 0)
    (("#313d49" "#2f3a3b" "brightcyan")
     . 20)))
 '(initial-major-mode (quote org-mode))
 '(initial-scratch-message
   "_This buffer is for text that is not saved, active mode is org-mode_
_To create a file, visit it with \\[find-file] and enter text in its buffer_

")
 '(ivy-rich-parse-remote-buffer nil)
 '(jdee-db-active-breakpoint-face-colors (cons "#1E2029" "#bd93f9"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#1E2029" "#50fa7b"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#1E2029" "#565761"))
 '(markdown-command "C:/Users/joskim/AppData/Local/Pandoc/pandoc.exe")
 '(nhexl-line-width 8)
 '(objed-cursor-color "#ff5555")
 '(org-agenda-files
   (quote
    ("~/Sync/RoamNotes/20210824160436-ebs_server_bible.org" "~/Sync/RoamNotes/20211010224151-rust.org" "~/Sync/org/amazon.org" "~/Sync/org/journal.org")))
 '(org-emphasis-alist
   (quote
    (("_"
      (:foreground "#A6E22E" :height nil :underline nil))
     ("/"
      (:foreground "#AE81FF" :height nil))
     ("*"
      (:foreground "#FD971F" :height nil :box nil :weight semi-bold))
     ("*" bold)
     ("/" italic)
     ("_" underline)
     ("=" org-verbatim verbatim)
     ("~" org-code verbatim)
     ("+"
      (:strike-through t)))))
 '(org-export-backends (quote (ascii html icalendar latex md odt)))
 '(org-src-preserve-indentation t)
 '(package-selected-packages
   (quote
    (gnuplot gnuplot-mode org-tree-slide dired-narrow rainbow-delimiters go-mode org-roam dumb-jump lsp-mode flymd impatient-mode nhexl-mode undo-tree all-the-icons smex company smart-mode-line-atom-one-dark-theme smart-mode-line avy expand-region rust-mode tide web-mode js3-mode yaml-mode markdown-mode csharp-mode log4j-mode git-gutter gruvbox-theme doom-themes)))
 '(pdf-view-midnight-colors (cons "#f8f8f2" "#282a36"))
 '(quote (org-agenda-files (quote ("~/Sync/org/journal.org"))))
 '(rustic-ansi-faces
   ["#282a36" "#ff5555" "#50fa7b" "#f1fa8c" "#61bfff" "#ff79c6" "#8be9fd" "#f8f8f2"])
 '(tramp-remote-path
   (quote
    (tramp-default-remote-path "/bin" "/usr/bin" "/sbin" "/usr/sbin" "/usr/local/bin" "/usr/local/sbin" "/local/bin" "/local/freeware/bin" "/local/gnu/bin" "/usr/freeware/bin" "/usr/pkg/bin" "/usr/contrib/bin" "/opt/bin" "/opt/sbin" "/opt/local/bin")))
 '(vc-annotate-background "#282a36")
 '(vc-annotate-color-map
   (list
    (cons 20 "#50fa7b")
    (cons 40 "#85fa80")
    (cons 60 "#bbf986")
    (cons 80 "#f1fa8c")
    (cons 100 "#f5e381")
    (cons 120 "#face76")
    (cons 140 "#ffb86c")
    (cons 160 "#ffa38a")
    (cons 180 "#ff8ea8")
    (cons 200 "#ff79c6")
    (cons 220 "#ff6da0")
    (cons 240 "#ff617a")
    (cons 260 "#ff5555")
    (cons 280 "#d45558")
    (cons 300 "#aa565a")
    (cons 320 "#80565d")
    (cons 340 "#6272a4")
    (cons 360 "#6272a4")))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:background "gray20" :foreground nil))))
 '(mode-line-inactive ((t (:background "dim gray")))))
(put 'narrow-to-region 'disabled nil)

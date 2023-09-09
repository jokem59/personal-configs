
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

;; To save sessions
(desktop-save-mode 1)

;; Prompt me before quitting
(setq confirm-kill-emacs 'y-or-n-p)

(require 'init-packages)
(require 'init-ui)
(require 'init-utils)
(require 'init-tools)
(require 'init-org)
(require 'init-org-roam)
(require 'init-magit)
(require 'init-language-base)
(require 'init-keybindings)
;; (require 'init-eglot-cpp)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#282a36" "#ff5555" "#50fa7b" "#f1fa8c" "#61bfff" "#ff79c6" "#8be9fd" "#f8f8f2"])
 '(custom-safe-themes
   '("7a424478cb77a96af2c0f50cfb4e2a88647b3ccca225f8c650ed45b7f50d9525" "b54376ec363568656d54578d28b95382854f62b74c32077821fdfd604268616a" "be84a2e5c70f991051d4aaf0f049fa11c172e5d784727e0b525565bb1533ec78" "a9abd706a4183711ffcca0d6da3808ec0f59be0e8336868669dc3b10381afb6f" "8d8207a39e18e2cc95ebddf62f841442d36fcba01a2a9451773d4ed30b632443" "251ed7ecd97af314cd77b07359a09da12dcd97be35e3ab761d4a92d8d8cf9a71" "b99e334a4019a2caa71e1d6445fc346c6f074a05fcbb989800ecbe54474ae1b0" "aec7b55f2a13307a55517fdf08438863d694550565dee23181d2ebd973ebd6b8" "7661b762556018a44a29477b84757994d8386d6edee909409fabe0631952dad9" "333958c446e920f5c350c4b4016908c130c3b46d590af91e1e7e2a0611f1e8c5" "cf922a7a5c514fad79c483048257c5d8f242b21987af0db813d3f0b138dfaf53" "d6844d1e698d76ef048a53cefe713dbbe3af43a1362de81cdd3aefa3711eae0d" "745d03d647c4b118f671c49214420639cb3af7152e81f132478ed1c649d4597d" "4133d2d6553fe5af2ce3f24b7267af475b5e839069ba0e5c80416aa28913e89a" "1278c5f263cdb064b5c86ab7aa0a76552082cf0189acf6df17269219ba496053" "b0e446b48d03c5053af28908168262c3e5335dcad3317215d9fdeb8bac5bacf9" "6f4421bf31387397f6710b6f6381c448d1a71944d9e9da4e0057b3fe5d6f2fad" "4a5aa2ccb3fa837f322276c060ea8a3d10181fecbd1b74cb97df8e191b214313" "e19ac4ef0f028f503b1ccafa7c337021834ce0d1a2bca03fcebc1ef635776bea" "266ecb1511fa3513ed7992e6cd461756a895dcc5fef2d378f165fed1c894a78c" "6c531d6c3dbc344045af7829a3a20a09929e6c41d7a7278963f7d3215139f6a7" "8d7b028e7b7843ae00498f68fad28f3c6258eda0650fe7e17bfb017d51d0e2a2" "5784d048e5a985627520beb8a101561b502a191b52fa401139f4dd20acb07607" "1d5e33500bc9548f800f9e248b57d1b2a9ecde79cb40c0b1398dec51ee820daf" "234dbb732ef054b109a9e5ee5b499632c63cc24f7c2383a849815dacc1727cb6" "7eea50883f10e5c6ad6f81e153c640b3a288cd8dc1d26e4696f7d40f754cc703" "7a7b1d475b42c1a0b61f3b1d1225dd249ffa1abb1b7f726aec59ac7ca3bf4dae" "a9a67b318b7417adbedaab02f05fa679973e9718d9d26075c6235b1f0db703c8" "0466adb5554ea3055d0353d363832446cd8be7b799c39839f387abb631ea0995" "8146edab0de2007a99a2361041015331af706e7907de9d6a330a3493a541e5a6" "6b5c518d1c250a8ce17463b7e435e9e20faa84f3f7defba8b579d4f5925f60c1" "e2acbf379aa541e07373395b977a99c878c30f20c3761aac23e9223345526bcc" "71e5acf6053215f553036482f3340a5445aee364fb2e292c70d9175fb0cc8af7" "76bfa9318742342233d8b0b42e824130b3a50dcc732866ff8e47366aed69de11" "be9645aaa8c11f76a10bcf36aaf83f54f4587ced1b9b679b55639c87404e2499" "7b50dc95a32cadd584bda3f40577e135c392cd7fb286a468ba4236787d295f4b" "a22f40b63f9bc0a69ebc8ba4fbc6b452a4e3f84b80590ba0a92b4ff599e53ad0" "585942bb24cab2d4b2f74977ac3ba6ddbd888e3776b9d2f993c5704aa8bb4739" "bc75dfb513af404a26260b3420d1f3e4131df752c19ab2984a7c85def9a2917e" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default))
 '(doom-modeline-vcs-max-length 20)
 '(ediff-split-window-function (quote split-window-horizontally))
 '(ediff-window-setup-function (quote ediff-setup-windows-plain))
 '(exec-path
   (quote
    ("~/.cargo/bin" "/usr/local/sbin" "/usr/local/bin" "/usr/sbin" "/usr/bin" "/sbin" "/bin" "/usr/games" "/usr/local/games" "/snap/bin")))
 '(exwm-floating-border-color "#242530")
 '(fci-rule-color "#6272a4")
 '(file-name-shadow-properties '(invisible t intangible t))
 '(file-name-shadow-tty-properties '(before-string "{" after-string "} " field shadow))
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
 '(isearch-lazy-count t)
 '(ispell-dictionary nil)
 '(jdee-db-active-breakpoint-face-colors (cons "#1E2029" "#bd93f9"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#1E2029" "#50fa7b"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#1E2029" "#565761"))
 '(markdown-command "C:/Users/joskim/AppData/Local/Pandoc/pandoc.exe")
 '(mu4e-mu-binary "/usr/local/bin/mu")
 '(mu4e-search-results-limit -1)
 '(mu4e-split-view 'vertical)
 '(nhexl-line-width 8)
 '(objed-cursor-color "#ff5555")
 '(org-agenda-files
   (quote
    ("~/Sync/RoamNotes/20210824160436-ebs_server_bible.org" "~/Sync/RoamNotes/20211010224151-rust.org" "~/Sync/org/amazon.org" "~/Sync/org/journal.org")))
 '(org-babel-load-languages (quote ((C . t))))
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
   '(auto-complete orderless marginalia consult-ls-git consult vertico mu4e-column-faces use-package eglot 0blayout mini-frame cmake-mode gnuplot gnuplot-mode org-tree-slide dired-narrow rainbow-delimiters go-mode org-roam dumb-jump flymd impatient-mode nhexl-mode undo-tree all-the-icons smex company smart-mode-line-atom-one-dark-theme smart-mode-line avy expand-region rust-mode tide web-mode js3-mode yaml-mode markdown-mode csharp-mode log4j-mode git-gutter gruvbox-theme doom-themes))
 '(pdf-view-midnight-colors (cons "#f8f8f2" "#282a36"))
 '(quote (org-agenda-files (quote ("~/Sync/org/journal.org"))))
 '(rustic-ansi-faces
   ["#282a36" "#ff5555" "#50fa7b" "#f1fa8c" "#61bfff" "#ff79c6" "#8be9fd" "#f8f8f2"])
 '(tramp-remote-path
   (quote
    (tramp-default-remote-path "/bin" "/usr/bin" "/sbin" "/usr/sbin" "/usr/local/bin" "/usr/local/sbin" "/local/bin" "/local/freeware/bin" "/local/gnu/bin" "/usr/freeware/bin" "/usr/pkg/bin" "/usr/contrib/bin" "/opt/bin" "/opt/sbin" "/opt/local/bin" "/apollo/env/envImprovement/bin")))
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
 '(vc-annotate-very-old-color nil)
 '(vertico-resize nil))
(put 'narrow-to-region 'disabled nil)

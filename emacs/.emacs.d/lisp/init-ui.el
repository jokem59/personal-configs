(require 'golden-ratio)
(golden-ratio-mode 1)

;; Start emacs in fullscreen
(add-to-list 'default-frame-alist '(fullscreen . maximized))

; Don't show the Welcome screen
(setq inhibit-startup-screen t)

(setq-default indent-tabs-mode nil)

(column-number-mode 1)
(setq column-number-mode t)
(setq line-number-mode t)

(display-time)
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(golden-ratio-mode 1)
(setq-default show-trailing-whitespace 1)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(setq electric-pair-mode nil) ; disable auto matching of braces
(setq visible-bell t)

;;
;; Line Numbers (linum)
;;

(set-fill-column 119)
(autoload 'linum-mode "linum" "toggle line numbers on/off" t)

;;
;; Smart Mode Line
;;
(custom-set-faces
 '(mode-line ((t (:background "gray20" :foreground nil))))
 '(mode-line-inactive ((t (:background "dim gray")))))
(setq sml/no-confirm-load-theme t)
(setq sml/theme 'atom-one-dark)
(sml/setup)

;;
;; Theme
;;

(load-theme 'gruvbox-dark-hard t)
(set-face-attribute 'default nil :height 120)
(when window-system
  (set-face-attribute 'default nil :family "Roboto Mono" :weight 'regular)
  (setq-default line-spacing 1))

;;
;; Ivy Mode
;;

(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq ivy-count-format "(%d/%d) ")
(setq ivy-re-builders-alist
      '((swiper . ivy--regex-plus)
        (t      . ivy--regex-fuzzy)))

;; better performance on everything (especially windows), ivy-0.10.0 required
;; @see https://github.com/abo-abo/swiper/issues/1218
(setq ivy-dynamic-exhibit-delay-ms 250)

;;
;; The uniquify library makes it so that when you visit two files with the same name in different directories,
;; the buffer names have the directory name appended to them instead of the silly hello<2> names you get by default.
;;
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;;
;; The saveplace library saves the location of the point when you kill a buffer
;; and returns to it next time you visit the associated file.
;;

(require 'saveplace)
(save-place-mode 1)

;;
;; Enable Git Gutter
;;
(require 'git-gutter)
(global-git-gutter-mode 1)

(provide 'init-ui)

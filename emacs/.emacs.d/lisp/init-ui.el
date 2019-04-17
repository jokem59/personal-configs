(require 'golden-ratio)

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
(setq inhibit-startup-message t)

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
;; Theme
;;

(load-theme 'monokai t)
(set-face-attribute 'default nil :height 135)
(when window-system
  (set-face-attribute 'default nil :font "Consolas")
  (setq-default line-spacing 3))

;;
;; Ivy instead of Ido
;;
;; Ido-mode with flx and configuration
;; (require 'ido-vertical-mode)
;; (require 'flx-ido)
;; (ido-mode 1)
;; (ido-everywhere 1)
;; (ido-vertical-mode 1)
;; (flx-ido-mode 1)
;; ;; disable ido faces to see flx highlights.
;; (setq ido-enable-flex-matching t)
;; (setq ido-use-faces nil)
;; (setq ido-vertical-define-keys 'C-n-C-p-up-down-left-right)

(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq ivy-count-format "(%d/%d) ")
(setq ivy-re-builders-alist
      '((swiper . ivy--regex-plus)
        (t      . ivy--regex-fuzzy)))

(use-package spaceline
  :demand t
  :init
  (setq powerline-default-separator 'arrow-fade)
  :config
  (require 'spaceline-config)
  (spaceline-spacemacs-theme))

(global-anzu-mode +1)

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

(provide 'init-ui)

;; Golden ratio settings
(require 'golden-ratio)
(golden-ratio-mode 1)

;; Start emacs in fullscreen
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Don't show the Welcome screen
(setq inhibit-startup-screen t)

(setq-default indent-tabs-mode nil)

(column-number-mode 1)
(setq column-number-mode t)
(setq line-number-mode t)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(if (display-graphic-p)
    (progn
      (tool-bar-mode -1)
      (scroll-bar-mode -1)))
(tool-bar-mode 0)
(menu-bar-mode 0)
(display-time)
(golden-ratio-mode 1)
(setq-default show-trailing-whitespace 1)

;; Line numbers
(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Show file name in title bar
(setq frame-title-format "%b")

;; Theme
(add-hook 'after-init-hook (lambda () (load-theme 'doom-dark+)))

;; Solaire-mode is an aesthetic plugin designed to visually distinguish "real" buffers vs "unreal" buffers
(require 'solaire-mode)

;; Enable solaire-mode anywhere it can be enabled
;; Helps with showing buffers like a more transluscent background
(solaire-global-mode +1)
;; To enable solaire-mode unconditionally for certain modes:
(add-hook 'ediff-prepare-buffer-hook #'solaire-mode)

;; ...if you use auto-revert-mode, this prevents solaire-mode from turning
;; itself off every time Emacs reverts the file
(add-hook 'after-revert-hook #'turn-on-solaire-mode)

(cond
 ((string-equal system-type "windows-nt")
  (progn
    (solaire-mode-swap-bg)
    (add-hook 'minibuffer-setup-hook #'solaire-mode-in-minibuffer))))
 ;; ((string-equal system-type "gnu/linux")
 ;;  (progn
 ;;    (solaire-mode-swap-bg)
 ;;    (add-hook 'minibuffer-setup-hook #'solaire-mode-in-minibuffer))))

;; Don't show trailing whitespace in minibuffer
(dolist (hook '(special-mode-hook
                term-mode-hook
                comint-mode-hook
                compilation-mode-hook
                minibuffer-setup-hook))
  (add-hook hook
            (lambda () (setq show-trailing-whitespace nil))))

(setq electric-pair-mode nil) ; disable auto matching of braces
(setq visible-bell t)
(setq ring-bell-function 'ignore)

;;
;; Ivy rich
;;
(require 'ivy-rich)
(ivy-rich-mode 1)
(setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line)

;; Disable ivy-rich details while using Tramp to improve performance
(setq ivy-rich-parse-remote-buffer nil)

;;
;; Prefer vertical window splits to horizontal
;;
(defun split-window-sensibly-prefer-horizontal (&optional window)
"Based on split-window-sensibly, but designed to prefer a horizontal split,
i.e. windows tiled side-by-side."
  (let ((window (or window (selected-window))))
    (or (and (window-splittable-p window t)
         ;; Split window horizontally
         (with-selected-window window
           (split-window-right)))
    (and (window-splittable-p window)
         ;; Split window vertically
         (with-selected-window window
           (split-window-below)))
    (and
         ;; If WINDOW is the only usable window on its frame (it is
         ;; the only one or, not being the only one, all the other
         ;; ones are dedicated) and is not the minibuffer window, try
         ;; to split it horizontally disregarding the value of
         ;; `split-height-threshold'.
         (let ((frame (window-frame window)))
           (or
            (eq window (frame-root-window frame))
            (catch 'done
              (walk-window-tree (lambda (w)
                                  (unless (or (eq w window)
                                              (window-dedicated-p w))
                                    (throw 'done nil)))
                                frame)
              t)))
     (not (window-minibuffer-p window))
     (let ((split-width-threshold 0))
       (when (window-splittable-p window t)
         (with-selected-window window
           (split-window-right))))))))

;;
;; Have sane minimums to determine a vertical vs horizontal split
;;
(setq
   split-height-threshold 4
   split-width-threshold 40
   split-window-preferred-function 'split-window-sensibly-prefer-horizontal)

;;
;; Line Numbers (linum)
;;

(set-fill-column 119)
(autoload 'linum-mode "linum" "toggle line numbers on/off" t)

;;
;; Theme
;;
(if (string-equal system-type "darwin")
    (set-face-attribute 'default nil :height 145))

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
        (counsel-git . ivy--regex-plus)
        (t      . ivy--regex-plus)))

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

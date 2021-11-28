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

(if (display-graphic-p)
    (progn
      (tool-bar-mode -1)
      (scroll-bar-mode -1)))
(tool-bar-mode 0)
(menu-bar-mode 0)
(display-time)
(golden-ratio-mode 1)
(setq-default show-trailing-whitespace 1)

;; Don't show trailing whitespace in minibuffer
(dolist (hook '(special-mode-hook
                term-mode-hook
                comint-mode-hook
                compilation-mode-hook
                minibuffer-setup-hook))
  (add-hook hook
            (lambda () (setq show-trailing-whitespace nil))))

;; Disable ivy-rich details while using Tramp to improve performance
(setq ivy-rich-parse-remote-buffer nil)

;; Disable to make ivy-rich mode look cleaner
(add-hook 'minibuffer-setup-hook
          (lambda () (setq-local show-trailing-whitespace nil)))

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(setq electric-pair-mode nil) ; disable auto matching of braces
(setq visible-bell t)
(setq ring-bell-function 'ignore)

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
;; Smart Mode Line
;;
;; (custom-set-faces
;;  '(mode-line ((t (:background "gray20" :foreground nil))))
;;  '(mode-line-inactive ((t (:background "dim gray")))))
;; (setq sml/no-confirm-load-theme t)
;; (setq sml/theme 'atom-one-dark)
;; (sml/setup)

;;
;; Theme
;;
(if (string-equal system-type "darwin")
    (set-face-attribute 'default nil :height 145))

(when window-system
  (set-face-attribute 'default nil :family "Roboto Mono" :weight 'regular)
  (setq-default line-spacing 1))

(require 'doom-modeline)
(doom-modeline-mode 1)
;; How tall the mode-line should be (only respected in GUI Emacs).
(setq doom-modeline-height 25)

;; How wide the mode-line bar should be (only respected in GUI Emacs).
(setq doom-modeline-bar-width 3)

(setq doom-modeline-buffer-file-name-style 'truncate-upto-project)

;; Whether display icons or not (if nil nothing will be showed).
(setq doom-modeline-icon t)

;; Whether display the icon for major mode. It respects `doom-modeline-icon'.
(setq doom-modeline-major-mode-icon t)

;; Display color icons for `major-mode'. It respects `all-the-icons-color-icons'.
(setq doom-modeline-major-mode-color-icon t)

;; Whether display minor modes or not. Non-nil to display in mode-line.
(setq doom-modeline-minor-modes nil)

;; If non-nil, a word count will be added to the selection-info modeline segment.
(setq doom-modeline-enable-word-count nil)

;; If non-nil, only display one number for checker information if applicable.
(setq doom-modeline-checker-simple-format t)

;; The maximum displayed length of the branch name of version control.
(setq doom-modeline-vcs-max-length 12)

;; Whether display perspective name or not. Non-nil to display in mode-line.
(setq doom-modeline-persp-name t)

;; Whether display `lsp' state or not. Non-nil to display in mode-line.
(setq doom-modeline-lsp t)

;; Whether display github notifications or not. Requires `ghub` package.
(setq doom-modeline-github nil)

;; The interval of checking github.
(setq doom-modeline-github-interval (* 30 60))

;; Whether display environment version or not
(setq doom-modeline-env-version t)
;; Or for individual languages
(setq doom-modeline-env-enable-python t)
(setq doom-modeline-env-enable-ruby t)
(setq doom-modeline-env-enable-perl t)
(setq doom-modeline-env-enable-go t)
(setq doom-modeline-env-enable-elixir t)
(setq doom-modeline-env-enable-rust t)

;; Change the executables to use for the language version string
(setq doom-modeline-env-python-executable "python")
(setq doom-modeline-env-ruby-executable "ruby")
(setq doom-modeline-env-perl-executable "perl")
(setq doom-modeline-env-go-executable "go")
(setq doom-modeline-env-elixir-executable "iex")
(setq doom-modeline-env-rust-executable "rustc")

;; Whether display mu4e notifications or not. Requires `mu4e-alert' package.
(setq doom-modeline-mu4e t)

;; Whether display irc notifications or not. Requires `circe' package.
(setq doom-modeline-irc t)

;; Function to stylize the irc buffer names.
(setq doom-modeline-irc-stylize 'identity)

(require 'doom-themes)

;; Global settings (defaults)
(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
      doom-themes-enable-italic t) ; if nil, italics is universally disabled

;; Load the theme (doom-one, doom-molokai, etc); keep in mind that each theme
;; may have their own settings.
(load-theme 'doom-dark+ t)


;; Solaire-mode is an aesthetic plugin designed to visually distinguish "real" buffers vs "unreal" buffers
(require 'solaire-mode)

;; Enable solaire-mode anywhere it can be enabled
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

;; (use-package ivy-posframe
;;   :after ivy
;;   :diminish
;;   :config
;;   (set-face-attribute 'ivy-posframe nil :background "gray11")
;;   (set-face-attribute 'ivy-posframe-border nil :background "gray14")
;;   (setq ivy-posframe-display-functions-alist
;;         '((swiper          . ivy-display-function-fallback)
;;           (complete-symbol . ivy-posframe-display-at-point)
;;           (t . ivy-posframe-display-at-frame-top-center)))
;;   (setq ivy-posframe-height-alist '((swiper . 15)
;;                                    (t      . 20)))
;;   (setq ivy-posframe-parameters '((internal-border-width . 4) (font . "Roboto Mono")))
;;   (setq ivy-posframe-width 700)
;;   (ivy-posframe-mode +1))

(use-package ivy-rich
  :preface
  (defun ivy-rich-switch-buffer-icon (candidate)
    (with-current-buffer
        (get-buffer candidate)
      (let ((icon (all-the-icons-icon-for-mode major-mode)))
        (if (symbolp icon)
            (all-the-icons-icon-for-mode 'fundamental-mode)
          icon))))
  :init
  (setq ivy-rich-display-transformers-list ; max column width sum = (ivy-poframe-width - 1)
        '(ivy-switch-buffer
          (:columns
           ((ivy-rich-switch-buffer-icon (:width 2))
            (ivy-rich-candidate (:width 40))
            (ivy-rich-switch-buffer-project (:width 15 :face success))
            (ivy-rich-switch-buffer-major-mode (:width 13 :face warning)))
           :predicate
           (lambda (cand) (get-buffer cand)))

          ivy-switch-buffer-other-window
          (:columns
           ((ivy-rich-switch-buffer-icon (:width 2))
            (ivy-rich-candidate (:width 40))
            (ivy-rich-switch-buffer-project (:width 15 :face success))
            (ivy-rich-switch-buffer-major-mode (:width 13 :face warning)))
           :predicate
           (lambda (cand) (get-buffer cand)))

          counsel-M-x
          (:columns
           ((counsel-M-x-transformer (:width 40))  ; thr original transformer
            (ivy-rich-counsel-function-docstring (:width 100 :face font-lock-doc-face))))

          counsel-describe-function
          (:columns
           ((counsel-describe-function-transformer (:width 40))
            (ivy-rich-counsel-function-docstring (:width 100 :face font-lock-doc-face))))

          counsel-describe-variable
          (:columns
           ((counsel-describe-variable-transformer (:width 40))
            (ivy-rich-counsel-variable-docstring (:width 100 :face font-lock-doc-face))))

          package-install
          (:columns
           ((counsel-describe-variable-transformer (:width 40))  ; the original transformer
            (ivy-rich-counsel-variable-docstring (:face font-lock-doc-face))))  ; return the docstring of the variable

          counsel-recentf
          (:columns
           ((ivy-rich-candidate (:width 0.8)) ; return the candidate itself
            (ivy-rich-file-last-modified-time (:face font-lock-comment-face)))))) ; return the last modified time of the file
  :config
  (ivy-rich-mode +1)
  (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line))

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

;;
;; Ivy-rich settings
;;
(require 'ivy-rich)
(ivy-rich-mode 1)
(setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line)

(provide 'init-ui)

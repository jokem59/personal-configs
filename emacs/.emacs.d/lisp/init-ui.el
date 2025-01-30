;; Golden ratio settings
(require 'golden-ratio)
(golden-ratio-mode 1)

;; Disable auto complete
(setq auto-complete-mode nil)

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

(tool-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode 0)
(menu-bar-mode 0)
(display-time)
(golden-ratio-mode 1)
(setq-default show-trailing-whitespace 1)

;; These settings hide the truncation glyhphs on terminal and gui repsectively
;; When resizing windows, they can refresh many times which is visually distracting
;; Replace truncation glyphs on terminal "$" with space
(set-display-table-slot standard-display-table 'truncation ?\ )
;; Remove truncation glyphs for GUI
(push '(truncation nil nil) ;; no truncation indicators
      ;; '(truncation nil right-arrow) ;; right indicator only
      ;; '(truncation left-arrow nil) ;; left indicator only
      ;; '(truncation left-arrow right-arrow) ;; default
      fringe-indicator-alist)

;; Line numbers
(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Show file name in title bar
(setq frame-title-format "%b")

;; Use short yes/no prompt, y/n
(if (version< emacs-version "29.1")
    (message "Current version doesn't support setopt")
  (setopt use-short-answers t))

;;
;; all-the-icons
;;
(use-package all-the-icons
  :if (display-graphic-p))

(use-package all-the-icons-completion
  :after (marginalia all-the-icons)
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init
  (all-the-icons-completion-mode))

;; Have isearch show number of matches (requires Emacs 27.1+)
(setq isearch-lazy-count t)

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
;; Theme
;;
(if (string-equal system-type "darwin")
    (set-face-attribute 'default nil :height 145))

(set-face-attribute 'default nil :family "Roboto Mono" :weight 'medium :height 130)
(setq-default line-spacing 1)

;; When navigating back to home (~), make the previous part of CWD invsible
(setq file-name-shadow-properties '(invisible t intangible t))

;;
;; Modeline
;;
(setq-default mode-line-format
              '("%e"
                mode-line-front-space
                mode-line-mule-info
                mode-line-client
                mode-line-modified
                mode-line-remote
                mode-line-frame-identification
                mode-line-buffer-identification
                "   "
                mode-line-position
                (vc-mode vc-mode)
                "  "
                my/modeline-major-mode
                "        "
                mode-line-misc-info))
                ;;mode-line-end-spaces))


(defvar-local my/modeline-buffer-name
  '(:eval
    (format " %s "
            (propertize (buffer-name) 'face 'my-modeline-red-background)))
  "Mode line constuct to display the buffer name.")


(defun my/modeline--major-mode-name ()
  "Return capitalized 'major-mode' as a string."
  (capitalize (symbol-name major-mode)))

(defvar-local my/modeline-major-mode
  '(:eval
    (list
     (propertize "⚡" 'face 'bold)
     (propertize (my/modeline--major-mode-name) 'face 'bold)))
  "Mode line construct to display the major mode.")

;; Necessary variably property to use locally
(put 'my/modeline-major-mode 'risky-local-variable t)

;; Pulsar, pulse curor on actions
(require 'pulsar)

;; Check the default value of `pulsar-pulse-functions'.  That is where
;; you add more commands that should cause a pulse after they are
;; invoked

(setq pulsar-pulse t)
(setq pulsar-delay 0.055)
(setq pulsar-iterations 10)
(setq pulsar-face 'pulsar-magenta)
(setq pulsar-highlight-face 'pulsar-yellow)

;; Custom hooks to add pulese
(add-hook 'my-previous-window-hook #'pulsar-pulse-line)

(pulsar-global-mode 1)

;; Return back to the position in the file you last visited
(save-place-mode 1)

(provide 'init-ui)


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

;; (package-initialize)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; Don't pop up the *Warnings* buffer for async native-compilation warnings
;; (e.g. expand-region's per-mode files referencing functions from modes that
;; aren't loaded at compile time). Warnings are still logged to
;; *Async-native-compile-log* if you ever need them.
(setq native-comp-async-report-warnings-errors 'silent)

(if (string-equal system-type "darwin")
    ()
    (when window-system
      (server-start)))

;; To save sessions
;; (desktop-save-mode 1)

;; Prompt me before quitting
(setq confirm-kill-emacs 'y-or-n-p)

;; Point Customize at its own file. `package-install' (from init-packages)
;; saves `package-selected-packages' to `custom-file' during startup, and
;; anything saved from a Customize buffer goes there too -- keeping that out
;; of init.el means Emacs never rewrites this file behind your back. Loading
;; it before the requires also means those values are in place before an
;; install can save them (otherwise the still-empty package list gets saved
;; over the real one).
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

(put 'narrow-to-region 'disabled nil)

(require 'init-packages)
(require 'init-ui)
(require 'init-utils)
(require 'init-tools)
(require 'init-org)
(require 'init-org-roam)
(require 'init-magit)
(require 'init-eat)
(require 'init-language-base)
;; This goes last as it often relies on functions defined in the above
(require 'init-keybindings)
(require 'init-eglot-cpp)
(require 'init-eglot)        ; auto-start eglot for every language with a server
;; init-org-jira is work-only and lives on load-path but is untracked; the work
;; overlay (init-org-roam-work.el) requires it. Personal machines skip it entirely.
(require 'tablature-mode)

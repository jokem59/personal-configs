;; magit configuration
(define-derived-mode magit-staging-mode magit-status-mode "Magit staging"
  "Mode for showing staged and unstaged changes."
  :group 'magit-status)
(defun magit-staging-refresh-buffer ()
  (magit-insert-section (status)
    (magit-insert-untracked-files)
    (magit-insert-unstaged-changes)
    (magit-insert-staged-changes)))
(defun magit-staging ()
  (interactive)
  (magit-mode-setup #'magit-staging-mode))

;; NOTE: disabled — this ran `golden-ratio` on EVERY `select-window` call
;; (minibuffer, magit, completion popups, etc.), adding latency on every
;; window switch. If you still want golden-ratio behaviour, prefer the
;; package's own global minor mode instead: (golden-ratio-mode 1)
;; (require 'golden-ratio)
;; (define-advice select-window (:after (window &optional no-record) golden-ratio-resize-window)
;;     (golden-ratio)
;;     nil)

(provide 'init-magit)

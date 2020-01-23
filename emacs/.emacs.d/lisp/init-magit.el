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

;; Properly resizes magit-status window
(define-advice select-window (:after (window &optional no-record) golden-ratio-resize-window)
    (golden-ratio)
    nil)

(provide 'init-magit)

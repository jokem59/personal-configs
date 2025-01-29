;; Temp files now to go temporary directory instead of same directory as file
(defvar --backup-directory "~/.saves/")
(if (not (file-exists-p --backup-directory))
    (make-directory --backup-directory t))
(setq backup-directory-alist
      `((".*" . ,--backup-directory)))
(setq auto-save-file-name-transforms
      `((".*", --backup-directory t)))
(setq make-backup-files t               ; backup of a file the first time it is saved.
      backup-by-copying t               ; don't clobber symlinks
      version-control t                 ; version numbers for backup files
      delete-old-versions t             ; delete excess backup files silently
      delete-by-moving-to-trash t
      kept-old-versions 3               ; oldest versions to keep when a new numbered backup is made (default: 2)
      kept-new-versions 3               ; newest versions to keep when a new numbered backup is made (default: 2)
      auto-save-default t               ; auto-save every buffer that visits a file
      auto-save-timeout 20              ; number of seconds idle time before auto-save (default: 30)
      auto-save-interval 200            ; number of keystrokes between auto-saves (default: 300)
      )

;; TODO: revisit based on OS
;;(custom-set-variables
;;  `(markdown-command "C:/Users/joskim/AppData/Local/Pandoc/pandoc.exe"))

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; Do not check if remote files are readable
;; Constant checks freeze on Windows when buffers to large network files exists
(setq recentf-keep '(file-remote-p file-readable-p))

;; For windows, have dired-find-name use GnuWin32 x64bit port find.exe
;; Expectation is to rename find.exe to gfind.exe to deconflict with %SystemRoot%\System32\find.exe
(cond ((eq system-type 'windows-nt)
       (setq find-program "gfind")))

(defun backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word, with argument ARG, do that arg number of times."
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point))))

(defun dos2unix ()
  "Replace DOS eolns CR LF with Unix eolns CR"
  (interactive)
  (goto-char (point-min))
  (while (search-forward "\r" nil t)
    (replace-match "")))

(defun eval-and-replace ()
  "Replace the preceding sexp with its value."
  (interactive)
  (backward-kill-sexp)
  (condition-case nil
      (prin1 (eval (read (current-kill 0)))
             (current-buffer))
    (error (message "Invalid expression")
           (insert (current-kill 0)))))

(require 'imenu)

(defun uuidgen-braces()
  (interactive)
  (save-excursion (insert "{")
                  (shell-command "uuidgen.exe" t)
                  (exchange-point-and-mark)
                  (backward-char 1)
                  (delete-char 1)
                  (insert "}")))

(defun uuidgen-nobraces()
  (interactive)
  (save-excursion (shell-command "uuidgen.exe" t)
                  (exchange-point-and-mark)
                  (backward-char 1)
                  (delete-char 1)))

(defun uuidgen-struct()
  (interactive)
  (save-excursion (save-excursion (shell-command "uuidgen.exe -s" t)
                                  (exchange-point-and-mark)
                                  (backward-char 2)
                                  (delete-char 2))
                  (delete-char 16)
                  (forward-char 2)
                  (delete-char 47)
                  (forward-char 11)
                  (delete-char 4)
                  (forward-char 8)
                  (delete-char 4)
                  (forward-char 8)
                  (delete-char 4)
                  (move-end-of-line nil)
                  (delete-char 2)
                  ))

(defun uuidgen-messageid()
  (interactive)
  (save-excursion (save-excursion (uuidgen-struct))
                  (delete-char 1)
                  (insert "MessageId(")
                  (forward-char 29)
                  (delete-char 1)
                  (forward-char 46)
                  (delete-char 1)
                  (forward-char 1)
                  (delete-char 1)
                  (insert ")")))

(defun uuidgen-contractid()
  (interactive)
  (save-excursion (save-excursion (uuidgen-struct))
                  (delete-char 1)
                  (insert "ContractId(")
                  (forward-char 29)
                  (delete-char 1)
                  (forward-char 46)
                  (delete-char 1)
                  (forward-char 1)
                  (delete-char 1)
                  (insert ")")))

(defun uuidgen-parens()
  (interactive)
  (save-excursion (save-excursion (uuidgen-struct))
                  (delete-char 1)
                  (insert "(")
                  (delete-char 1)
                  (forward-char 28)
                  (delete-char 1)
                  (forward-char 46)
                  (delete-char 3)
                  (insert ")")
                  ))

(defun uuidgen-struct-long()
  (interactive)
  (save-excursion (shell-command "uuidgen.exe -s" t)
                  (exchange-point-and-mark)
                  (backward-char 1)
                  (delete-char 1)))

(defun copy-current-line-position-to-clipboard ()
  "Copy current line in file to clipboard as '</path/to/file>:<line-number>'"
  (interactive)
  (let ((path-with-line-number
         (concat (buffer-file-name) "::" (number-to-string (line-number-at-pos)))))
    (x-select-text path-with-line-number)
    (kill-new path-with-line-number)
    (message (concat path-with-line-number " copied to clipboard"))))

(defun copy-region-as-richtext-to-clipboard (beg end)
  "Copy Region as rich text to clipboard"
  (interactive "r")
  (highlight2clipboard-copy-region-to-clipboard beg end)
  (pop-to-mark-command)
  (message "Copied to clipboard"))

(defun append-line-to-scratch ()
  "Append current line in file to scratch"
  (interactive)
  (save-excursion
    (let ((oldbuf (current-buffer)))
      (set-mark-command (beginning-of-line))
      (end-of-line)
      (copy-region-as-kill (region-beginning) (region-end))
      (set-buffer (get-buffer-create "*scratch*"))
      (barf-if-buffer-read-only)
      (goto-char (point-max))
      (yank)
      (insert ?\n))))

;; Custom HideShow Function
(defun toggle-fold ()
  (interactive)
  (save-excursion
    (end-of-line)
    (hs-toggle-hiding)))

;; Git-gutter
(global-git-gutter-mode +1)

;; Clippety
(use-package clipetty
  :ensure t
  :hook (after-init . global-clipetty-mode))

;; Dwim quit minibuffer
(defun my/force-quit-minibuffer ()
  "Forcefully quit the minibuffer, even if it's not the active window."
  (interactive)
  (let ((mini-window (minibuffer-window)))
    (when (window-live-p mini-window)
      (with-selected-window mini-window
        (abort-recursive-edit)))))

;; Dwim quit minibuffer advice function
(defun my/keyboard-quit-advice ()
  "Call `force-quit-minibuffer` if the minibuffer is active; otherwise, do nothing."
  (when (active-minibuffer-window)
    (my/force-quit-minibuffer)))

;; Add the advice to keyboard-quit
(advice-add 'keyboard-quit :before #'my/keyboard-quit-advice)

(provide 'init-utils)

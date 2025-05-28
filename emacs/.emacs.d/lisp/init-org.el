(require 'org)

;; Run on journal.org file for org agenda to use
;; M-x org-agenda-file-to-front

;; Visual line mode on by defauilt
(with-eval-after-load 'org
  (add-hook 'org-mode-hook #'visual-line-mode))

(cond ((eq system-type 'windows-nt)
       ;; Windows specific for slow org-mode
       (setq gc-cons-threshold (* 511 1024 1024))
       (setq gc-cons-percentage 0.5)
       (run-with-idle-timer 5 t #'garbage-collect)
       (setq garbage-collection-messages t)

       (defun org-outlook-open (path) (w32-shell-execute "open" "C:/Program Files (x86)/Microsoft Office/root/Office16/OUTLOOK.exe" (concat "outlook:" path)))
       (org-add-link-type "outlook" 'org-outlook-open)

       (defun org-insert-clipboard-image ()
	 "Insert clipboard image into org"
	 (interactive)
	 (call-process-shell-command "powershell.exe Get-OrgImageLink")
	 (yank))
       )
      ((eq system-type 'gnu/linux)
       ;; Linux-specific code goes here.
       ))


(setq org-directory "~/Sync/org")
(setq org-default-notes-file (concat org-directory "/journal.org"))
(setq org-default-journal-file (concat org-directory "/journal.org"))
(setq org-catch-invisible-edits 'show-and-error)
(setq org-startup-with-inline-images t)

(setq org-capture-templates
      '(    ;; ... other templates
        ("t" "Todo"
         entry
         (file+headline org-default-todo-file "Tasks") "* TODO %?\n %i\n %a")

        ("j" "Journal Entry"
         entry
         (file+datetree org-default-journal-file)
         "* %?"
         :empty-lines 1)

        ("p" "Personal Notes"
         entry
         (file+datetree org-default-personal-file)
         "* %?"
         :empty-lines 1)
        ))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key "\C-cj" 'my/org-open-journal)

(defun my/org-open-journal()
  (interactive)
  (find-file org-default-journal-file))


;; Enable inline highlighting for codeblocks
(setq org-src-fontify-natively t)
;; set maximum indentation for description lists
(setq org-list-description-max-indent 5)
;; prevent demoting heading also shifting text inside sections
(setq org-adapt-indentation nil)

;; Hide formatting characters like *, /, _
(setq org-hide-emphasis-markers t)

(add-to-list 'org-emphasis-alist
             '("*" (:foreground "#FD971F" :height nil :box nil :weight semi-bold)))

(add-to-list 'org-emphasis-alist
             '("/" (:foreground "#AE81FF" :height nil)))

(add-to-list 'org-emphasis-alist
             '("_" (:foreground "#A6E22E" :height nil :underline nil)))

;; START TODO Workflow
;; TODO keywords.
(setq org-todo-keywords
  '((sequence "TODO(t)" "NEXT(n)" "PROG(p)" "INTR(i)" "DONE(d)")))

;; Show the daily agenda by default.
(setq org-agenda-span 'day)

;; Hide tasks that are scheduled in the future.
(setq org-agenda-todo-ignore-scheduled 'future)

;; Use "second" instead of "day" for time comparison.
;; It hides tasks with a scheduled time like "<2020-11-15 Sun 11:30>"
(setq org-agenda-todo-ignore-time-comparison-use-seconds t)

;; Hide the deadline prewarning prior to scheduled date.
(setq org-agenda-skip-deadline-prewarning-if-scheduled 'pre-scheduled)

;; Customized view for the daily workflow. (Command: "C-c a n")
(setq org-agenda-custom-commands
  '(("n" "Work Agenda / INTR / PROG / NEXT / DONE"
     (;;(agenda "" nil) ; shows daily view which pollutes with DONE dates
      (todo "INTR" nil)
      (todo "PROG" nil)
      (todo "NEXT" nil)
      (todo "DONE" nil))
     ((org-agenda-files '("~/Sync/RoamNotes/20210816094150-todo.org"))))

    ("j" "Personal Agenda / INTR / PROG / NEXT / DONE"
     (;;(agenda "" nil) ; shows daily view which pollutes with DONE dates
      (todo "INTR" nil)
      (todo "PROG" nil)
      (todo "NEXT" nil)
      (todo "DONE" nil))
     ((org-agenda-files '("~/Sync/RoamNotes/20250522101720-personal_todo.org"))))))
;; END TODO Workflow

(use-package org-tree-slide
  :custom
  (org-image-actual-width nil))

(provide 'init-org)

(require 'org)

(setq org-directory "~/OneDrive/org")
(setq org-default-notes-file (concat org-directory "/journal.org"))
(setq org-default-journal-file (concat org-directory "/journal.org"))
(setq org-default-todo-file (concat org-directory "/todo.org"))
(setq org-default-personal-file (concat org-directory "/personal.org"))

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
(global-set-key "\C-cj" 'org-open-journal)

(defun org-open-journal()
  (interactive)
  (find-file org-default-journal-file))

(defun org-outlook-open (path) (w32-shell-execute "open" "C:/Program Files (x86)/Microsoft Office/root/Office16/OUTLOOK.exe" (concat "outlook:" path)))
(org-add-link-type "outlook" 'org-outlook-open)

(defun org-insert-clipboard-image ()
  "Insert clipboard image into org"
  (interactive)
  (call-process-shell-command "powershell.exe Get-OrgImageLink")
  (yank))

;; Enable inline highlighting for codeblocks
(setq org-src-fontify-natively t)
;; set maximum indentation for description lists
(setq org-list-description-max-indent 5)
;; prevent demoting heading also shifting text inside sections
(setq org-adapt-indentation nil)

(add-to-list 'org-emphasis-alist
             '("*" (:foreground "Red" :height 145)
               ))

(provide 'init-org)

;; Configuration file for mail related things

(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e/")

(require 'mu4e)

(setq mu4e-mu-binary "/usr/local/bin/mu")

(with-eval-after-load 'mu4e
  (mu4e-column-faces-mode))

;; use mu4e for e-mail in emacs
(setq mail-user-agent 'mu4e-user-agent)

(setq mu4e-drafts-folder "/[Gmail].Drafts")
(setq mu4e-sent-folder   "/[Gmail].Sent Mail")
(setq mu4e-trash-folder  "/[Gmail].Trash")

;; don't save message to Sent Messages, Gmail/IMAP takes care of this
(setq mu4e-sent-messages-behavior 'delete)

;; (See the documentation for `mu4e-sent-messages-behavior' if you have
;; additional non-Gmail addresses and want assign them different
;; behavior.)

;; setup some handy shortcuts
;; you can quickly switch to your Inbox -- press ``ji''
;; then, when you want archive some messages, move them to
;; the 'All Mail' folder by pressing ``ma''.

(setq mu4e-maildir-shortcuts
    '( (:maildir "/INBOX"              :key ?i)
       (:maildir "/[Gmail].Sent Mail"  :key ?s)
       (:maildir "/[Gmail].Trash"      :key ?t)
       (:maildir "/[Gmail].All Mail"   :key ?a)))

(add-to-list 'mu4e-bookmarks
    ;; ':favorite t' i.e, use this one for the modeline
   '(:query "maildir:/inbox" :name "Inbox" :key ?i :favorite t))

;; Refresh mail using mbsync every 5 minutes
(setq mu4e-update-interval (* 5 60))

;; allow for updating mail using 'U' in the main view:
(setq mu4e-get-mail-command "mbsync -a")

;; something about ourselves
(setq
   user-mail-address "joe.kim509@gmail.com"
   user-full-name  "Joe Kim"
   mu4e-compose-signature
    (concat
      "Cheers,\n"
      "Joe\n"))

;; sending mail -- replace USERNAME with your gmail username
;; also, make sure the gnutls command line utils are installed
;; package 'gnutls-bin' in Debian/Ubuntu

(require 'smtpmail)
(setq message-send-mail-function 'smtpmail-send-it
   starttls-use-gnutls t
   smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
   smtpmail-default-smtp-server "smtp.gmail.com"
   smtpmail-smtp-server "smtp.gmail.com"
   smtpmail-smtp-service 587)

;; alternatively, for emacs-24 you can use:
;;(setq message-send-mail-function 'smtpmail-send-it
;;     smtpmail-stream-type 'starttls
;;     smtpmail-default-smtp-server "smtp.gmail.com"
;;     smtpmail-smtp-server "smtp.gmail.com"
;;     smtpmail-smtp-service 587)

;; Total number of search results to show, the more the slower, -1 for unlimited
(setq mu4e-search-results-limit -1)

;; Split vertically when opening email
(setq mu4e-split-view 'vertical)

;; Keybinding changes
(define-key mu4e-headers-mode-map (kbd "!") 'mu4e-headers-mark-for-refile)
(define-key mu4e-headers-mode-map (kbd "r") 'mu4e-headers-mark-for-read)

;; don't keep message buffers around
(setq message-kill-buffer-on-exit t)

(provide 'init-mail)

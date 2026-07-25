(setq jiralib-url "https://roblox.atlassian.net")

;; Machine-local, untracked file holding the Jira auth cookie. Not every
;; machine has this set up, so don't let its absence abort the rest of init.el.
(let ((jira-cookie-file (expand-file-name "~/dev/nosync_emacs_configs/init-org-jira-cookie.el")))
  (if (file-exists-p jira-cookie-file)
      (load-file jira-cookie-file)
    (message "init-org-jira: %s not found, skipping (org-jira will be unauthenticated)" jira-cookie-file)))

;; Our jira doesn't allow reporter field to be edited, so we exclude it when we post
(setq jiralib-update-issue-fields-exclude-list '(reporter))

;; Make the following changes in jiralib.el the bytecompile the file
;; Original implementation only allowed for a single GET request which is limited to 1000 results per
;; the API https://docs.atlassian.com/software/jira/docs/api/REST/1000.824.0/#api/2/user-findBulkAssignableUsers
;; PR: https://github.com/ahungry/org-jira/pull/370
      ;; ;; ('getUsers
      ;; ;;  (jiralib--rest-call-it (format "/rest/api/2/user/assignable/search?project=%s&maxResults=10000" (first params))
      ;; ;;                         :type "GET"))
      ;; ('getUsers
      ;;  (let* ((project (first params))
      ;;         (start-at 0)
      ;;         (max-results 1000)
      ;;         (all-users '())
      ;;         (more-results t))
      ;;    (while more-results
      ;;      (let* ((endpoint (format "/rest/api/2/user/assignable/search?project=%s&startAt=%d&maxResults=%d"
      ;;                               project start-at max-results))
      ;;             (response (jiralib--rest-call-it endpoint :type "GET")))
      ;;        (setq all-users (append all-users response))
      ;;        (setq more-results (>= (length response) max-results))
      ;;        (setq start-at (+ start-at max-results))))
      ;;    all-users))

(provide 'init-org-jira)

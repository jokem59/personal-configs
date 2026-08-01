(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  ;; Personal store, Syncthing-synced across personal machines. This is the
  ;; tracked default; the work machine overlays it (see the load at the bottom).
  (org-roam-directory "~/Sync/RoamNotes")
  ;; Dailies live under the org-roam default daily/ (indexed recursively).
  (org-roam-dailies-directory "daily/")
  ;; The DB is a regenerable per-machine cache (rebuilt from the .org files) — it
  ;; is neither config nor a note, so keep it out of BOTH git (this repo, since
  ;; ~/.emacs.d symlinks into it) and Syncthing (a live SQLite file must not sync
  ;; across machines). Park it in a machine-local cache dir instead.
  (org-roam-db-location (expand-file-name "~/.cache/emacs/org-roam.db"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n g" . org-roam-graph))
  ;; A prefix keymap must be bound with :bind-keymap (not :bind), which also
  ;; autoloads org-roam when C-c n d is first pressed.
  :bind-keymap ("C-c n d" . org-roam-dailies-map)
  :config
  (require 'org-roam-dailies)
  ;; Ensure the machine-local cache dir for org-roam-db-location exists.
  (make-directory (file-name-directory org-roam-db-location) t)
  ;; Everything is captured in dailies + tags — no dedicated todo file. Evergreen
  ;; notes go to the roam root; the refs template pre-fills ROAM_REFS for
  ;; URL/PR/Slack links so ref discovery works from the start.
  (setq org-roam-capture-templates
        '(("d" "default" plain "%?"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}\n#+filetags:\n#+date-created: %<%Y-%m-%d>\n")
           :unnarrowed t)
          ("r" "with refs (url/pr/slack)" plain "%?"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                              ":PROPERTIES:\n:ROAM_REFS: %^{Refs (space-separated URLs)}\n:END:\n#+title: ${title}\n#+filetags:\n#+date-created: %<%Y-%m-%d>\n")
           :unnarrowed t)))
  (setq org-roam-dailies-capture-templates
        '(("d" "session" entry "* %<%H:%M> %?"
           :if-new (file+head "%<%Y-%m-%d>.org"
                              "#+title: %<%Y-%m-%d>\n#+filetags: :session:\n"))))
  ;; Keep the SQLite DB in step with files written outside emacs (e.g. by the
  ;; org-roam-notes-personal skill) so backlinks/agenda/node-find pick them up on idle.
  (org-roam-db-autosync-mode)
  (org-roam-setup)
  ;; Work-machine overlay: switches the store back to the Roblox graph, restores
  ;; Jira-aware capture + work agenda, and loads org-jira. Untracked (lives in
  ;; ~/dev/nosync_emacs_configs/); a no-op on personal machines where it's absent.
  (load "~/dev/nosync_emacs_configs/init-org-roam-work.el" 'noerror 'nomessage))

(provide 'init-org-roam)

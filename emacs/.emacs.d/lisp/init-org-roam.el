
(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/Sync/RoamNotes")
  :bind(("C-c n l" . org-roam-buffer-toggle)
        ("C-c n f" . org-roam-node-find)
        ("C-c n i" . org-roam-node-insert)
        ("C-c n g" . org-roam-graph))
  :config
  (setq org-roam-capture-templates '(("d" "default" plain
                                      "%?" :if-new
                                      (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                                                 "#+title: ${title}?\n#+date-created: %<%Y>-%<%m>-%<%d> %<%H>:%<%M>.%<%S>" )
                                      :unnarrowed t)))
  (org-roam-setup))

(provide 'init-org-roam)

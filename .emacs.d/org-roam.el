(use-package org-roam
  :ensure t
  :custom
  (setq org-roam-directory "~/orgs-roam")
  (org-roam-db-autosync-mode)
  :bind (:map org-mode-map ("C-i" . completion-at-point))
  :config (org-roam-setup))

(use-package org-roam-ui
  :ensure t
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))
(setq org-roam-v2-ack t)

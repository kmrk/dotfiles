;;; init-dired.el --- Dired / Wdired / Ibuffer（evil 键位在 init-evil.el） -*- lexical-binding: t; -*-

(setq delete-by-moving-to-trash t)

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom
  (dired-listing-switches "-agho --group-directories-first")
  :hook (dired-mode . dired-hide-details-mode)
  :config
  (put 'dired-find-alternate-file 'disabled nil))

(use-package wdired
  :ensure nil
  :after dired
  :config
  ;; 允许修改文件权限
  (setq wdired-allow-to-change-permissions t))

(defun my/ibuffer-setup ()
  "Local defaults for `ibuffer-mode'."
  (setq-local truncate-lines t))

(use-package ibuffer
  :ensure nil
  :commands ibuffer
  :hook (ibuffer-mode . my/ibuffer-setup))

(provide 'init-dired)
;;; init-dired.el ends here

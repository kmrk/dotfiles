(use-package company
  :hook (prog-mode . company-mode)
  :ensure t
  :config
  (add-hook 'eglot-managed-mode-hook (lambda ()
                                     (add-to-list 'company-backends
                                                  '(company-capf :with company-yasnippet))))
  (setq company-dabbrev-downcase 0)
  (setq company-idle-delay 0))
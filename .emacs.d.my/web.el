;(use-package rjsx-mode
;  :ensure t
;  :config
;  (add-to-list 'auto-mode-alist '("\\.tsx.*$" . rjsx-mode)))
;
;(use-package typescript-mode :ensure t)

(use-package tide :ensure t)
(use-package flycheck :ensure t)

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

(setq company-tooltip-align-annotations t)
(add-hook 'before-save-hook 'tide-format-before-save)
(add-hook 'typescript-mode-hook #'setup-tide-mode)
(use-package web-mode :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.tsx.*$'" . web-mode))
  (add-hook 'web-mode-hook
            (lambda ()
                (setq web-mode-markup-indent-offset 2)
                (setup-tide-mode))))

;; enable typescript - tslint checker
(flycheck-add-mode 'typescript-tslint 'web-mode)

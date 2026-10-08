;;; init-navigation.el --- 项目、搜索、按键提示、imenu -*- lexical-binding: t; -*-

(use-package projectile
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :config
  (setq projectile-completion-system 'default)
  (projectile-mode 1))

;; 搜索结果的 RET 统一在主编辑窗口打开（见 init-windows.el）
(use-package ag
  :config
  (define-key ag-mode-map (kbd "RET") #'my/compile-goto-error-same-window))

(use-package rg
  :config
  (rg-enable-default-bindings)
  (setq rg-group-result t
        rg-show-columns t)
  (define-key rg-mode-map (kbd "RET") #'my/compile-goto-error-same-window))

(use-package imenu-list
  :commands (imenu-list-smart-toggle)
  :config
  (setq imenu-list-focus-after-activation t
        imenu-list-auto-resize t))

;;; ============================================================================
;;; which-key（minibuffer 里临时关掉）
;;; ============================================================================

(defvar my/which-key-was-enabled-before-minibuffer nil
  "Whether `which-key-mode' was enabled before entering the minibuffer.")

(defun my/which-key-disable-in-minibuffer ()
  "Disable `which-key-mode' while the minibuffer is active."
  (setq my/which-key-was-enabled-before-minibuffer
        (bound-and-true-p which-key-mode))
  (when my/which-key-was-enabled-before-minibuffer
    (which-key-mode -1)))

(defun my/which-key-restore-after-minibuffer ()
  "Restore `which-key-mode' after leaving the minibuffer."
  (when my/which-key-was-enabled-before-minibuffer
    (which-key-mode 1))
  (setq my/which-key-was-enabled-before-minibuffer nil))

(use-package which-key
  :diminish which-key-mode
  :init
  (which-key-mode 1)
  :config
  (setq which-key-idle-delay 1
        which-key-inhibit-regexps '("C-s"))
  (add-hook 'minibuffer-setup-hook #'my/which-key-disable-in-minibuffer)
  (add-hook 'minibuffer-exit-hook #'my/which-key-restore-after-minibuffer))

(provide 'init-navigation)
;;; init-navigation.el ends here

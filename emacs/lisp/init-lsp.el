;;; init-lsp.el --- Eglot / Flymake 通用设置 -*- lexical-binding: t; -*-

;; 这里只放与语言无关的部分。每门语言在自己的 init-lang-*.el 里：
;;   (add-hook 'xxx-mode-hook #'eglot-ensure)
;;   (my/eglot-register '(xxx-mode) '("server" "--stdio"))

(defun my/eglot-register (modes command)
  "Register COMMAND as the Eglot server for MODES once Eglot is loaded.
MODES is a mode symbol or a list in `eglot-server-programs' key format.
COMMAND is a list, or a function returning one (called when Eglot loads)."
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 (cons modes (if (functionp command) (funcall command) command)))))

(defun my/eglot-enable-flymake ()
  "Turn on Flymake in Eglot-managed buffers."
  (when (eglot-managed-p)
    (flymake-mode 1)))

(use-package eglot
  :ensure nil
  :defer t
  :custom
  (eglot-confirm-server-edits nil)
  ;; 不记录 LSP 事件日志（Emacs 30 起取代 eglot-events-buffer-size）
  (eglot-events-buffer-config '(:size 0 :format full))
  :hook (eglot-managed-mode . my/eglot-enable-flymake)
  :bind (:map eglot-mode-map
              ("C-c C-e r" . eglot-rename)
              ("C-c C-e l" . flymake-show-buffer-diagnostics)
              ("C-c C-e p" . flymake-show-buffer-diagnostics)
              ("C-c C-e C" . eglot-show-workspace-configuration)
              ("C-c C-e R" . eglot-reconnect)
              ("C-c C-e S" . eglot-shutdown)
              ("C-c C-e A" . eglot-shutdown-all)
              ("C-c C-e a" . eglot-code-actions)
              ("C-c C-e f" . eglot-format)
              ("C-c r" . eglot-rename)
              ("C-c f" . eglot-code-actions)))

;; Flymake 跳转（evil 下的 ]e / [e 在 init-evil.el）
(global-set-key (kbd "M-n") #'flymake-goto-next-error)
(global-set-key (kbd "M-p") #'flymake-goto-prev-error)

(provide 'init-lsp)
;;; init-lsp.el ends here

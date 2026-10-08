;;; init-editing.el --- 编辑增强：片段、选区、中英文空格、输入法、杂项工具 -*- lexical-binding: t; -*-

(use-package yasnippet
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :after yasnippet)

(use-package expand-region
  :bind (("<C-S-right>" . er/expand-region)
         ("<C-S-left>" . er/contract-region)))

;;; ============================================================================
;;; 非编程 buffer 里中英文之间自动插空格
;;; ============================================================================

(defun my-insert-space-between-cn-and-en (char)
  "在中英文之间自动插入空格。"
  (let* ((prev (char-before))
         (next (char-after))
         (is-en (and (>= char ?!) (<= char ?~)))
         (is-cn-prev (and prev (>= prev #x4e00)))
         (is-cn-next (and next (>= next #x4e00))))
    (when (and is-en is-cn-prev (not (eq prev ?\s)))
      (insert " "))
    (when (and is-en is-cn-next)
      (save-excursion (insert " ")))))

(defun my-self-insert-hook ()
  (when (and (characterp last-command-event)
             (>= last-command-event 32))
    (my-insert-space-between-cn-and-en last-command-event)))

(defun my-enable-cn-en-space ()
  "Enable auto space insertion only for non-programming modes."
  (unless (derived-mode-p 'prog-mode)
    (add-hook 'post-self-insert-hook #'my-self-insert-hook nil t)))

(add-hook 'after-change-major-mode-hook #'my-enable-cn-en-space)

;;; ============================================================================
;;; 输入法
;;; ============================================================================

(use-package rime
  :custom
  (default-input-method "rime")
  (rime-title " 中 ")
  (rime-user-data-dir "~/.config/rime")
  :config
  (setq rime-show-candidate 'minibuffer
        rime-inline-ascii-trigger 'shift-l))

;;; ============================================================================
;;; 杂项工具
;;; ============================================================================

(use-package eat)
(use-package command-log-mode)

(provide 'init-editing)
;;; init-editing.el ends here

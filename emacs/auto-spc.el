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

(provide 'auto-cn-en-space)

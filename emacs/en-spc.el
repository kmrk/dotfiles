;;; en-spc.el --- auto space between CN & EN

(defun en-spc--chinese-p (char)
  "Return t if CHAR is a Chinese character."
  (and char
       (>= char #x4E00)
       (<= char #x9FFF)))

(defun en-spc-post-self-insert ()
  "Auto insert spaces between Chinese and English.  Must take NO arguments."
  (let* ((char last-command-event)
         (prev (char-after (1- (point))))
         (next (char-after (point)))
         (is-en (and (>= char 33) (<= char 126)))
         (is-cn-prev (en-spc--chinese-p prev))
         (is-cn-next (en-spc--chinese-p next)))
    ;; 英文后 → 中文前
    (when (and is-en is-cn-prev)
      (save-excursion
        (backward-char)
        (unless (eq (char-after (1- (point))) ?\s)
          (insert " "))))
    ;; 中文后 → 英文前
    (when (and is-en is-cn-next)
      (save-excursion
        (insert " ")))))

(add-hook 'post-self-insert-hook #'en-spc-post-self-insert)

;;; en-spc.el ends here boox有缩放相关功能完善hell

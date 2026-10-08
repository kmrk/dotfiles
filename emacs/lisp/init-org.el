;;; init-org.el --- Org 模式 -*- lexical-binding: t; -*-

(defun org-font-setup ()
  "Use bullet glyphs and scaled Ubuntu headings in graphical Org buffers."
  (when (display-graphic-p)
    (font-lock-add-keywords
     'org-mode
     '(("^ *\\([-]\\) "
        (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
    (dolist (pair '((org-level-1 . 120)
                    (org-level-2 . 114)
                    (org-level-3 . 110)
                    (org-level-4 . 109)
                    (org-level-5 . 108)
                    (org-level-6 . 107)
                    (org-level-7 . 106)
                    (org-level-8 . 105)))
      (set-face-attribute (car pair) nil
                          :font "Ubuntu"
                          :weight 'regular
                          :height (cdr pair)))))

(use-package org)

(use-package org-bullets
  :after org
  :hook ((org-mode . org-font-setup)
         (org-mode . org-bullets-mode))
  :custom
  (org-bullets-bullet-list '("✱" "◉" "◆" "◇" "◈" "✲" "✧" "⊙" "✦" "⊚" "⊛" "○")))

(provide 'init-org)
;;; init-org.el ends here

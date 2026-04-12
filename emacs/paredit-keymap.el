;;; paredit-keymap.el --- Custom paredit / evil-paredit bindings -*- lexical-binding: t; -*-
;;; Commentary:
;;
;;
;;                       [ M-k ]
;;                          ^
;;                    (WRAP CURRENT)
;;                          |
;;          [ M-h ] <-------+-------> [ M-l ]
;;          (SLURP)         |         (SLURP)
;;                          |
;;          [ M-H ] <-------+-------> [ M-L ]
;;          ( BARF)         |         ( BARF)
;;                          |
;;                    (REMOVE SHELL)
;;                          v
;;                       [ M-j ]
;;
;;  ─────────────────────────────────────────────────
;;     NAVIGATE:  [ M-p ]  <─── o ───>  [ M-n ]
;;  ─────────────────────────────────────────────────
;;
;;  [ DESIGN LOGIC ]
;;  - Vertical (j/k): Structural Depth (In/Out)
;;  - Horizontal (h/l): Structural Boundaries (Extend/Shrink)
;;  - Shift Key: Reverses the Boundary action (Barf)
;; Concrete examples:
;;
;;   [a b c d]      -- M-k on d --> [a b c [d]]
;;   (a b c d)      -- M-k on d --> (a b c (d))
;;   [a b c [d]]    -- M-j on d --> [a b c d]
;;   (a b c (d))    -- M-j on d --> (a b c d)
;;
;; Design rules:
;;
;; - h/l operate on structural boundaries.
;; - Shift on h/l reverses the boundary action.
;; - j/k operate on structural depth.
;; - up acts on the current sexp, not on the whole parent container.
;; - up inherits the nearest enclosing delimiter type: [], (), or {}.
;; - down removes the nearest enclosing shell around point.

;;; Code:

(use-package paredit
  :ensure t
  :hook ((emacs-lisp-mode . enable-paredit-mode)
	 (eval-expression-minibuffer-setup . enable-paredit-mode)
	 (ielm-mode . enable-paredit-mode)
	 (lisp-mode . enable-paredit-mode)
	 (lisp-interaction-mode . enable-paredit-mode)
	 (scheme-mode . enable-paredit-mode)
	 (racket-mode . enable-paredit-mode)
	 (slime-repl-mode . enable-paredit-mode)
	 (clojure-mode . enable-paredit-mode)
	 (clojurescript-mode . enable-paredit-mode)
	 (cider-repl-mode . enable-paredit-mode)
	 (cider-mode . enable-paredit-mode)))

(with-eval-after-load 'evil
  (unless (fboundp 'evil-called-interactively-p)
    (defalias 'evil-called-interactively-p #'called-interactively-p)))

(defun my/paredit--current-sexp-bounds ()
  "Return bounds for the current or next sexp near point."
  (or (bounds-of-thing-at-point 'sexp)
      (save-excursion
        (skip-chars-forward " \t\n")
        (bounds-of-thing-at-point 'sexp))))

(defun my/paredit--enclosing-list-bounds ()
  "Return bounds for the nearest list relevant to point."
  (save-excursion
    (cond
     ((looking-at-p "\\s(")
      (let ((start (point))
            (end (scan-sexps (point) 1)))
        (when end
          (cons start end))))
     ((and (not (bobp))
           (save-excursion
             (backward-char 1)
             (looking-at-p "\\s)")))
      (backward-char 1)
      (let ((end (1+ (point)))
            (start (scan-sexps (point) -1)))
        (when start
          (cons start end))))
     (t
      (let ((start (nth 1 (syntax-ppss))))
        (when start
          (cons start (scan-sexps start 1))))))))

(defun my/paredit--enclosing-delimiters ()
  "Return the delimiter pair inherited from the nearest enclosing list."
  (let ((start (nth 1 (syntax-ppss))))
    (when start
      (save-excursion
        (goto-char start)
        (pcase (char-after)
          (?\( '("(" . ")"))
          (?\[ '("[" . "]"))
          (?\{ '("{" . "}"))
          (_ nil))))))

(defun my/paredit-down-dwim ()
  "Remove the nearest surrounding list so repeated down climbs one level."
  (interactive)
  (let ((bounds (my/paredit--enclosing-list-bounds)))
    (unless bounds
      (user-error "No enclosing list to unwrap"))
    (atomic-change-group
      (save-excursion
        (goto-char (cdr bounds))
        (backward-delete-char 1)
        (goto-char (car bounds))
        (delete-char 1)))))

(defun my/paredit-up-dwim ()
  "Wrap the current sexp using the nearest enclosing delimiter style."
  (interactive)
  (let ((bounds (my/paredit--current-sexp-bounds))
        (delims (or (my/paredit--enclosing-delimiters)
                    '("(" . ")"))))
    (unless bounds
      (user-error "No sexp at point to wrap"))
    (atomic-change-group
      (save-excursion
        (goto-char (cdr bounds))
        (insert (cdr delims))
        (goto-char (car bounds))
        (insert (car delims))))))

(use-package evil-paredit
  :ensure t
  :after (evil paredit)
  :hook (paredit-mode . evil-paredit-mode)
  :config
  (define-key evil-paredit-mode-map (kbd "M-h") #'paredit-backward-slurp-sexp)
  (define-key evil-paredit-mode-map (kbd "M-H") #'paredit-backward-barf-sexp)
  (define-key evil-paredit-mode-map (kbd "M-l") #'paredit-forward-slurp-sexp)
  (define-key evil-paredit-mode-map (kbd "M-L") #'paredit-forward-barf-sexp)
  (define-key evil-paredit-mode-map (kbd "M-j") #'my/paredit-down-dwim)
  (define-key evil-paredit-mode-map (kbd "M-k") #'my/paredit-up-dwim)
  (define-key evil-paredit-mode-map (kbd "M-n") #'paredit-forward)
  (define-key evil-paredit-mode-map (kbd "M-p") #'paredit-backward))

(provide 'paredit-keymap)
;;; paredit-keymap.el ends here

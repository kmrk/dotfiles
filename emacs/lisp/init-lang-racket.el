;;; init-lang-racket.el --- Racket / Scribble -*- lexical-binding: t; -*-

;;; ============================================================================
;;; LSP：racket-langserver
;;; ============================================================================

(defvar my-racket-langserver-checked nil)
(defvar my-racket-langserver-available nil)

(defun my-racket-langserver-installed-p ()
  "Return non-nil when racket-langserver is installed."
  (unless my-racket-langserver-checked
    (setq my-racket-langserver-checked t
          my-racket-langserver-available
          (and (executable-find "raco")
               (eq 0 (call-process "raco" nil nil nil "pkg" "show" "racket-langserver")))))
  my-racket-langserver-available)

(defun my-eglot-racket-server ()
  "Return the preferred Racket LSP server command."
  (if (executable-find "xvfb-run")
      '("xvfb-run" "-a" "racket" "-l" "racket-langserver")
    '("racket" "-l" "racket-langserver")))

(defun my-racket-eglot-ensure ()
  "Start Eglot for Racket when racket-langserver is available."
  (if (my-racket-langserver-installed-p)
      (eglot-ensure)
    (message "Racket Eglot requires: raco pkg install racket-langserver")))

(my/eglot-register 'racket-mode #'my-eglot-racket-server)

;;; ============================================================================
;;; Racket
;;; ============================================================================

(use-package racket-mode
  :hook (racket-mode . my-racket-eglot-ensure)
  :bind (:map racket-mode-map
              ("C-c C-d" . racket-doc)
              ("C-c C-r" . racket-run))
  :config
  (setq racket-mode-help-on-errors nil)
  (add-hook 'racket-xp-mode-hook
            (lambda ()
              (remove-hook 'pre-redisplay-functions #'racket-xp-pre-redisplay t))))

;; Racket 文件里 #lang at-exp 的 @foo{ 高亮
(font-lock-add-keywords 'racket-mode '(("@\\w+{" . font-lock-keyword-face)))

(my/display-in-side "\\*Racket Repl \\(.*\\)\\*" 'right 1 0.3)

;;; ============================================================================
;;; Scribble（.scrbl 由 scribble-mode 接管）
;;; ============================================================================

(defun my-scribble-build ()
  "Compile the current Scribble file."
  (interactive)
  (when (buffer-file-name)
    (message "%s" (shell-command-to-string
                   (format "scribble %s" (shell-quote-argument (buffer-file-name)))))))

(use-package scribble-mode
  :mode "\\.scrbl\\'"
  :bind (:map scribble-mode-map
              ("C-c C-c" . racket-run)
              ("C-c C-k" . racket-check-syntax-mode))
  :config
  (setq scribble-indent-width 2)
  (add-hook 'scribble-mode-hook #'show-paren-mode))

(provide 'init-lang-racket)
;;; init-lang-racket.el ends here

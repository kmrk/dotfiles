;;; init-lang-web.el --- JavaScript / TypeScript / TSX -*- lexical-binding: t; -*-

(use-package typescript-mode
  :demand t
  :mode ("\\.ts\\'" . typescript-mode)
  :config
  (define-derived-mode my-typescript-tsx-mode typescript-mode "TSX"
    "Major mode for TSX files using `typescript-mode' editing rules.")
  (put 'my-typescript-tsx-mode 'eglot-language-id "typescriptreact")
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . my-typescript-tsx-mode)))

(use-package js
  :ensure nil
  :mode ("\\.mjs\\'" "\\.cjs\\'" "\\.js\\'"))

;;; ============================================================================
;;; LSP：typescript-language-server
;;; ============================================================================

(defun my-eglot-ts-server ()
  "Return the preferred TypeScript/JavaScript LSP server command."
  (if (executable-find "typescript-language-server")
      '("typescript-language-server" "--stdio")
    '("npx" "--yes" "typescript-language-server" "--stdio")))

(dolist (hook '(js-mode-hook js-ts-mode-hook
                typescript-mode-hook typescript-ts-mode-hook
                tsx-ts-mode-hook my-typescript-tsx-mode-hook))
  (add-hook hook #'eglot-ensure))

(my/eglot-register '(js-mode js-ts-mode typescript-mode typescript-ts-mode tsx-ts-mode)
                   #'my-eglot-ts-server)
;; 注册在后面，所以排在 eglot-server-programs 的更前面
(my/eglot-register '(my-typescript-tsx-mode :language-id "typescriptreact")
                   #'my-eglot-ts-server)

(provide 'init-lang-web)
;;; init-lang-web.el ends here

;;; init-lang-python.el --- Python -*- lexical-binding: t; -*-

(defun my-eglot-python-server ()
  "Return the preferred Python LSP server command."
  (cond
   ((executable-find "basedpyright-langserver")
    '("basedpyright-langserver" "--stdio"))
   ((executable-find "pyright-langserver")
    '("pyright-langserver" "--stdio"))
   (t
    '("npx" "--yes" "pyright" "--stdio"))))

(add-hook 'python-mode-hook #'eglot-ensure)
(add-hook 'python-ts-mode-hook #'eglot-ensure)
(my/eglot-register '(python-mode python-ts-mode) #'my-eglot-python-server)

(provide 'init-lang-python)
;;; init-lang-python.el ends here

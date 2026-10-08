;;; init-lang-rust.el --- Rust -*- lexical-binding: t; -*-

(use-package rust-mode
  :mode "\\.rs\\'"
  :config
  (setq rust-format-on-save t))

(add-hook 'rust-mode-hook #'eglot-ensure)
(add-hook 'rust-ts-mode-hook #'eglot-ensure)
(my/eglot-register '(rust-mode rust-ts-mode) '("rust-analyzer"))

(provide 'init-lang-rust)
;;; init-lang-rust.el ends here

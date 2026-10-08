;;; init-lang-haskell.el --- Haskell -*- lexical-binding: t; -*-

(use-package haskell-mode
  :hook ((haskell-mode . interactive-haskell-mode)
         (haskell-mode . eglot-ensure))
  :config
  (setq haskell-stylish-on-save t
        haskell-indentation-layout-offset 4
        haskell-indentation-starter-offset 4))

(my/eglot-register 'haskell-mode '("haskell-language-server-wrapper" "--lsp"))

(my/display-in-side "\\*haskell\\*" 'right 2 0.3)

(provide 'init-lang-haskell)
;;; init-lang-haskell.el ends here

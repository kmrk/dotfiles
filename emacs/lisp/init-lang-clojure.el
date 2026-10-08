;;; init-lang-clojure.el --- Clojure -*- lexical-binding: t; -*-

(use-package cider)
(use-package edn)

(dolist (hook '(clojure-mode-hook clojurescript-mode-hook clojurec-mode-hook))
  (add-hook hook #'eglot-ensure))

(my/eglot-register '(clojure-mode clojurescript-mode clojurec-mode) '("clojure-lsp"))

(provide 'init-lang-clojure)
;;; init-lang-clojure.el ends here

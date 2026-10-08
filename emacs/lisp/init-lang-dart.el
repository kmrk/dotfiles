;;; init-lang-dart.el --- Dart / Flutter -*- lexical-binding: t; -*-

(use-package dart-mode
  :mode "\\.dart\\'"
  :custom
  (dart-format-on-save t)
  :hook ((dart-mode . subword-mode)
         (dart-mode . electric-pair-local-mode)
         (dart-mode . eglot-ensure))
  :bind (:map dart-mode-map
              ("C-c C-c" . eglot-format)))

(my/eglot-register 'dart-mode '("dart" "language-server" "--protocol=lsp"))

(use-package flutter
  :after dart-mode
  :config
  (let ((flutter-sdk (expand-file-name "~/.local/lib/flutter")))
    (when (file-directory-p flutter-sdk)
      (setq flutter-sdk-path flutter-sdk))))

(provide 'init-lang-dart)
;;; init-lang-dart.el ends here

(load "~/.emacs.d/ui.el")
(load "~/.emacs.d/packages.el")

(put 'dired-find-alternate-file 'disabled nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("f5f070872db3e4d8b82dbb2f3b1c60beca86fc93327a38ebddd22070458a14bc" default))
 '(package-selected-packages
   '(eziam-themes f yasnippet-snippets which-key racket-mode projectile org-bullets magit ivy-rich ivy-prescient expand-region evil-terminal-cursor-changer evil edn diminish dart-mode counsel company command-log-mode cider ag)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(show-paren-match ((t (:background "cyan" :foreground "black" :weight bold))))
 '(show-paren-mismatch ((t (:background "red" :foreground "white" :weight bold)))))

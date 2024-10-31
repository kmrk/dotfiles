(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(setq term-buffer-maximum-size 0) ;; 允许终端缓冲区大小无限
(setq vterm-max-scrollback 10000) ;; 增加 vterm 的历史记录


(setenv "TERM" "xterm-256color")






(define-key input-decode-map "\e[1;2A" [S-up])
(define-key input-decode-map "\e[1;2B" [S-down])
(define-key input-decode-map "\e[1;2C" [S-right])
(define-key input-decode-map "\e[1;2D" [S-left])
(define-key input-decode-map "\e[1;5A" [C-up])
(define-key input-decode-map "\e[1;5B" [C-down])
(define-key input-decode-map "\e[1;5C" [C-right])
(define-key input-decode-map "\e[1;5D" [C-left])
(define-key input-decode-map "\e[1;6A" [C-S-up])
(define-key input-decode-map "\e[1;6B" [C-S-down])
(define-key input-decode-map "\e[1;6C" [C-S-right])
(define-key input-decode-map "\e[1;6D" [C-S-left])








(load "~/.emacs.d/ui.el")

(load "~/.emacs.d/packages.el")

(put 'dired-find-alternate-file 'disabled nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("f0f5201c7dd9a5d9f84e3f98099230ebb27f2c9db4fc5395b994451242dcbd8f" "f5f070872db3e4d8b82dbb2f3b1c60beca86fc93327a38ebddd22070458a14bc" default))
 '(eglot-confirm-server-edits nil nil nil "Customized with use-package eglot")
 '(package-selected-packages
   '(eziam-themes f yasnippet-snippets which-key racket-mode projectile org-bullets magit ivy-rich ivy-prescient expand-region evil-terminal-cursor-changer evil edn diminish dart-mode counsel company command-log-mode cider ag)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-level-1 ((t (:extend nil :background "brightwhite" :overline t :weight bold :height 1.8))))
 '(show-paren-match ((t (:background "cyan" :foreground "black" :weight bold))))
 '(show-paren-mismatch ((t (:background "red" :foreground "white" :weight bold)))))

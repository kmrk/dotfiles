(load "~/.emacs.d/use-package.el")
(load "~/.emacs.d/user-config.el")
(load "~/.emacs.d/basic.el")
(load "~/.emacs.d/evil.el")
(load "~/.emacs.d/treemacs.el")
(load "~/.emacs.d/company.el")
(load "~/.emacs.d/cider.el")
(load "~/.emacs.d/rime.el")
(load "~/.emacs.d/hooks.el")
(load "~/.emacs.d/indent-line.el")
(load "~/.emacs.d/org-roam.el")
(load "~/.emacs.d/font.el")
;(load "~/.emacs.d/web.el")

(if (>= emacs-major-version 29) (load "~/.emacs.d/tree-sitter.el"))

(setq custom-file "~/.emacs.d/custome.el")
(load custom-file 'noerror)

(custom-set-faces
 '(line-number ((t (:foreground "gray50" :height 0.8))))
 '(line-number-current-line ((t (:foreground "white" :weight bold :height 0.8)))))

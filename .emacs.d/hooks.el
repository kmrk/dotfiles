;; dev hooks
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'text-mode-hook 'display-line-numbers-mode)

(if (package-installed-p 'eglot) (add-hook 'prog-mode-hook 'eglot-ensure))

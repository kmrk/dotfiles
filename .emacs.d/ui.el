(setq inhibit-startup-message t)
					;(load-theme 'tango-dark t)

					;(defun dont-kill-emacs()
					;  "Disable C-x C-c binding execute kill-emacs."
					;  (interactive)
					;  (error (substitute-command-keys "To exit emacs: \\[kill-emacs]")))
					;(global-set-key (kbd "C-x C-c") 'dont-kill-emacs)

(setq-default line-spacing 0)
(setq frame-title-format "%b - Emacs")
(tool-bar-mode 0)
(scroll-bar-mode 0)
(setq tree-widget-image-enable nil)
(menu-bar-mode 0)
(column-number-mode 1)

(setq speedbar-show-unknown-files t)


(defconst emacs-tmp-dir (format "%s%s%s/" temporary-file-directory "emacs" (user-uid)))
(setq backup-directory-alist `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms `((".*" ,emacs-tmp-dir t)))
(setq auto-save-list-file-prefix emacs-tmp-dir)

(show-paren-mode t)
(electric-pair-mode t)

(setq electric-pair-pairs '((?\' . ?\')))


(custom-set-faces
 '(show-paren-match ((t (:background "cyan" :foreground "black" :weight bold))))
 '(show-paren-mismatch ((t (:background "red" :foreground "white" :weight bold)))))


(load-theme 'eziam-light t)

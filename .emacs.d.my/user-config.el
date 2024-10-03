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
(menu-bar-mode nil)
(column-number-mode 1)

(setq speedbar-show-unknown-files t)


(defconst emacs-tmp-dir (format "%s%s%s/" temporary-file-directory "emacs" (user-uid)))
(setq backup-directory-alist `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms `((".*" ,emacs-tmp-dir t)))
(setq auto-save-list-file-prefix emacs-tmp-dir)

(show-paren-mode t)
(electric-pair-mode t)

(setq electric-pair-pairs '((?\' . ?\')))

(setq-default indent-tabs-mode nil)

(winner-mode t)
(global-tab-line-mode t)

(defun kkk () 
  (interactive)                                                                   
  (mapc 'kill-buffer (cdr (buffer-list (current-buffer)))))


;; add total lines to default line position mode
;; (current_line/total_linecount,current_column)
(setq-default mode-line-position
              '((line-number-mode
                 ("(%l/"
                  (:eval
                   (number-to-string
                    (count-lines (point-min) (point-max))))))
                (column-number-mode ":%c)")))

(setq tooltip-mode nil)
;(set-fringe-mode 50)
(set-mouse-color "#fff")
(global-eldoc-mode nil)
(setq eldoc-echo-area-use-multiline-p nil)
(set-face-background 'menu "blue")
(setq initial-frame-alist '((top . 100) (left . 100) (width . 160) (height . 50)))


(setq split-width-threshold 0)
(setq split-height-threshold nil)

;; desktop env only, not work in xlaunch
(defun do-transparency ()
  (set-frame-parameter (selected-frame) 'alpha '(90 90))
  (add-to-list 'default-frame-alist '(alpha 90 90)))
(setq company-lsp-cache-candidates t)


(setq speedbar-directory-unshown-regexp "^$")
(setq visible-bell t)
(menu-bar-mode -1)

(add-to-list 'auto-mode-alist '("\\.clj\\'" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.cljc\\'" . clojure-mode)) 
(add-to-list 'auto-mode-alist '("\\.cljs\\'" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.edn\\'" . clojure-mode))


(add-hook 'org-mode-hook
          (lambda () 
            (org-cycle-global '(1))))

(use-package eziam-theme :ensure t)

(setq inhibit-startup-message t)

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

(add-to-list 'default-frame-alist '(background-color . "#ffffff"))

(custom-set-faces
 '(show-paren-match ((t (:background "cyan" :foreground "black" :weight bold))))
 '(show-paren-mismatch ((t (:background "red" :foreground "white" :weight bold)))))


(setq-default indent-tabs-mode nil)

(winner-mode t)
(global-tab-line-mode t)

(defun kkk () (interactive) (mapc 'kill-buffer (cdr (buffer-list (current-buffer)))))


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
(set-mouse-color "#000")
(global-eldoc-mode nil)
(setq eldoc-echo-area-use-multiline-p nil)
(set-face-background 'menu "blue")
(setq initial-frame-alist '((top . 100) (left . 100) (width . 160) (height . 50)))


(setq split-width-threshold 0)
(setq split-height-threshold nil)

;; desktop env only, not work in xlaunch;
;(defun do-transparency ()
;  (set-frame-parameter (selected-frame) 'alpha '(90 90))
;  (add-to-list 'default-frame-alist '(alpha 90 90)))

(setq company-lsp-cache-candidates t)


(setq speedbar-directory-unshown-regexp "^$")
(setq visible-bell t)


; scale & gui fonts
;(setq scale (if (and (equal ":0" (getenv "DISPLAY")) (eq 'gnu/linux system-type)) 1.5 1))
;(set-face-attribute 'default nil :font "JetBrains Mono" :height (round ( * scale 100)))

;(defun set-font-face (family height)
;  (face-remap-add-relative 'default `(:family ,family :height ,height)))

;(add-hook 'org-mode-hook (lambda () (set-font-face "Iosevka Aile" (round (* scale 120)))))
;(add-hook 'prog-mode-hook (lambda () (set-font-face "Monaco" (round (* scale 100)))))
;(add-hook 'shell-mode-hook (lambda () (set-font-face "Fira Code Regular" (round (* scale 100)))))

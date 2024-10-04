(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                        ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;;
;; ivy mode
;;
(use-package ivy
  :ensure t
  :diminish (ivy-mode . "")
  :config
  (ivy-mode 1)
  (use-package ivy-prescient :ensure t
    :config (ivy-prescient-mode 1))
  (setq ivy-use-virutal-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-height 15)
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-count-format "%d/%d")
  (setq ivy-re-builders-alist
        `((t . ivy--regex-ignore-order))))

;;
;; counsel
;;
(use-package counsel
  :ensure t
  :config
  (ivy-configure 'consel-M-x :initial-input "")
  :bind (("M-x" . counsel-M-x)
         ("C-;" . counsel-M-x)
         ("\C-x \C-f" . counsel-find-file)))

;;
;; swiper
;;
(use-package swiper
  :ensure t
  :bind (("\C-s" . swiper)))

;;
;; yasnippet
;;
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode)
  (use-package yasnippet-snippets :ensure t))

;;
;; magit
;;
(use-package magit
  :ensure t
  :after evil
                                        ;:init (evil-collection-init)
  :bind ("\C-x g" . magit-status))


;;;
;; projectile
;;
(use-package projectile
  :ensure t
  :bind-keymap
  ("\C-c p" . projectile-command-map)
  :config
  (projectile-mode t)
  (setq projectile-completion-system 'ivy)
  (use-package counsel-projectile
    :ensure t))


(use-package ag :ensure t)

(use-package diminish :ensure t)


; (use-package paredit
;   :ensure t
;   :hook ((emacs-lisp-mode . enable-paredit-mode)
; 	 (eval-expression-minibuffer-setup . enable-paredit-mode)
; 	 (ielm-mode . enable-paredit-mode)
; 	 (lisp-mode . enable-paredit-mode) 
; 	 (lisp-interaction-mode . enable-paredit-mode)
; 	 (scheme-mode . enable-paredit-mode)
; 	 (slime-repl-mode . enable-paredit-mode) 
; 	 (clojure-mode . enable-paredit-mode)
; 	 (clojurescript-mode . enable-paredit-mode)
; 	 (cider-repl-mode . enable-paredit-mode)
; 	 (cider-mode . enable-paredit-mode)
; 	 (clojure-mode . enable-paredit-mode))
;   :config
;   (show-paren-mode t)
;   ;; paredit makes evil column editing error.
;   ;; do comment by select "va(" and M-;
;   ;; the key binds to (paredit-comment-dwin)
;   ;; it toggles the comment/uncomment
;   :bind (("C->" . paredit-forward-slurp-sexp)
; 	 ("C-<" . paredit-forward-barf-sexp)
; 	 ("C-M-<" . paredit-backward-slurp-sexp)
; 	 ("C-M->" . paredit-backward-barf-sexp)
; 	 ("<C-right>" .  nil)
; 	 ("<C-left>" .  nil)
; 	 ("M-[" . paredit-wrap-square)
; 	 ("M-{" . paredit-wrap-curly)))


(use-package dired :ensure nil 
             :commands (dired dired-jump)
             :after evil
             :bind (("C-x C-j" . dired-jump))
             :custom ((dired-listing-switches "-agho --group-directories-first"))
             ;  :config
             ;  (evil-define-key 'normal 'dired-mode-map
             ;    "h" 'dired-up-directory
             ;    "l" 'dired-find-file)
             )

;(setq delete-by-moving-to-trash t)


;;
;; expand region
;;
(use-package expand-region :ensure t
             :bind ("C-=" . er/expand-region))



(use-package dart-mode :ensure t
             :config
             :hook (dart-mode . flutter-test-mode))

(add-to-list 'auto-mode-alist '("\\.dart\\'" . dart-mode) t)
(autoload 'dart-mode "dart-mode")

;(use-package flutter :ensure t)


(use-package command-log-mode :ensure t) 


;(use-package rainbow-delimiters :ensure t
;  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key :ensure t
             :init (which-key-mode)
             :diminish which-key-mode
             :config
             (setq which-key-idle-delay 1))


(use-package ivy-rich :ensure t
             :init (ivy-rich-mode 1))


(defun org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell Regular" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))


(use-package org-bullets
             :ensure t
             :after org
             :hook (org-mode . org-bullets-mode)
             :custom
             (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))


(use-package edn :ensure t)

(use-package company
             :hook (prog-mode . company-mode)
             :ensure t
             :config
             (add-hook 'eglot-managed-mode-hook (lambda ()
                                                  (add-to-list 'company-backends
                                                               '(company-capf :with company-yasnippet))))
             (setq company-dabbrev-downcase 0)
             (setq company-idle-delay 0))

(use-package cider
             :ensure t)

(use-package racket-mode :ensure t)


(defun evil-keyboard-quit ()
  "Keyboard quit and force normal state."
  (interactive)
  (and evil-mode (evil-force-normal-state))
  (keyboard-quit))

(use-package
  evil
  :ensure t
  :init
  (setq evil-want-integration t) (setq evil-want-keybinding nil)
  (fset 'evil-visual-update-x-selection 'ignore)
  :config
  (evil-mode 1)
  (define-key evil-motion-state-map (kbd "C-z") 'suspend-frame)
  (evil-ex-define-cmd "q" 'kill-this-buffer)
  (evil-ex-define-cmd "quit" 'evil-quit)
  (evil-ex-define-cmd "wq"  (lambda () (interactive) (save-buffer)(kill-this-buffer)))
  (evil-ex-define-cmd "x"  (lambda ()  (interactive) (save-buffer)(kill-this-buffer)))
  (define-key evil-normal-state-map (kbd "gt") 'next-buffer)
  (define-key evil-normal-state-map (kbd "gT") 'previous-buffer)
  (define-key evil-normal-state-map   (kbd "C-g") #'evil-keyboard-quit)
  (define-key evil-motion-state-map   (kbd "C-g") #'evil-keyboard-quit)
  (define-key evil-insert-state-map   (kbd "C-g") #'evil-keyboard-quit)
  (define-key evil-window-map         (kbd "C-g") #'evil-keyboard-quit)
  (define-key evil-operator-state-map (kbd "C-g") #'evil-keyboard-quit))


(use-package evil-terminal-cursor-changer
  :ensure t
  :config
  (evil-terminal-cursor-changer-activate)
  (setq evil-motion-state-cursor 'box)
  (setq evil-visual-state-cursor 'box)  ; █
  (setq evil-normal-state-cursor 'box)  ; █
  (setq evil-insert-state-cursor 'bar)  ; ⎸
  (setq evil-replace-state-cursor 'hbar) ; _
  )


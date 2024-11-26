(require 'package)

(setq package-archives
      '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
        ("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

                                        ;(setq package-archives '(
                                        ;			 ("melpa" . "https://melpa.org/packages/")
                                        ;                         ("gnu" . "https://elpa.gnu.org/packages/")
                                        ;                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t) 
(setq package-check-signature nil)

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

(use-package paredit
  :ensure t
  :hook ((emacs-lisp-mode . enable-paredit-mode)
 	 (eval-expression-minibuffer-setup . enable-paredit-mode)
 	 (ielm-mode . enable-paredit-mode)
 	 (lisp-mode . enable-paredit-mode) 
 	 (lisp-interaction-mode . enable-paredit-mode)
 	 (scheme-mode . enable-paredit-mode)
         (racket-mode . enable-paredit-mode)
 	 (slime-repl-mode . enable-paredit-mode) 
 	 (clojure-mode . enable-paredit-mode)
 	 (clojurescript-mode . enable-paredit-mode)
 	 (cider-repl-mode . enable-paredit-mode)
 	 (cider-mode . enable-paredit-mode)
 	 (clojure-mode . enable-paredit-mode)))


(defun dired-create-empty-file (filename)
  "Create an empty file named FILENAME in the current directory."
  (interactive "F新建文件名: ")
  (let ((full-path (expand-file-name filename (dired-current-directory))))
    (if (file-exists-p full-path)
        (message "文件已存在")
      (write-region "" nil full-path)
      (dired-add-file full-path)
      (revert-buffer)
      (message "文件 %s 创建成功" filename))))
(defun my-dired-clear-marks-and-refresh (&rest _args)
  "Clear marks and refresh Dired buffers after moving files."
  (dired-unmark-all-marks) ; 清除所有标记
  (dired-do-redisplay))    ; 刷新当前目录的显示

(with-eval-after-load 'dired
  (advice-add 'dired-do-rename :after #'my-dired-clear-marks-and-refresh))


(use-package dired :ensure nil 
  :commands (dired dired-jump)
  :after evil
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :hook
  (dired-mode
   .
   (lambda ()
     (evil-define-key 'normal dired-mode-map
       (kbd "h") 'dired-up-directory
       (kbd "l") 'dired-find-file
       (kbd "a") 'dired-create-empty-file
       (kbd "A") 'dired-create-directory
       (kbd "D") 'dired-do-delete
       (kbd "r") 'dired-do-rename
       (kbd "R") 'revert-buffer
       (kbd "m") 'dired-mark
       (kbd ".") 'dired-omit-mode))))

(setq delete-by-moving-to-trash t)


;;
;; expand region
;;
(use-package expand-region
  :ensure t
  :bind (("<C-S-right>" . er/expand-region)  ; 扩展区域
         ("<C-S-left>" . er/contract-region))) ; 缩减区域

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
  (org-bullets-bullet-list '("✱" "◉" "◆" "◇" "◈" "✲"  "✧" "⊙" "✦" "⊚" "⊛" "○")))

(use-package org :ensure t
  :config
  (set-face-attribute 'org-level-1 nil :background "color-255" :foreground "black" :italic nil :underline nil)
  (set-face-attribute 'org-level-2 nil :background "color-255" :foreground "black" :italic nil :underline nil)
  (set-face-attribute 'org-level-3 nil :background "color-255" :foreground "black" :italic nil :underline nil)
  (set-face-attribute 'org-level-4 nil :background "color-255" :foreground "black" :italic nil :underline nil)
  (set-face-attribute 'org-level-5 nil :background "color-255" :foreground "black" :italic nil :underline nil)
  (set-face-attribute 'org-level-6 nil :background "color-255" :foreground "black" :italic nil :underline nil)
  (set-face-attribute 'org-level-7 nil :background "color-255" :foreground "black" :italic nil :underline nil)
  (set-face-attribute 'org-level-8 nil :background "color-255" :foreground "black" :italic nil :underline nil))

(use-package edn :ensure t)

(use-package company
  :hook (prog-mode . company-mode)
  :ensure t
  :config
  (setq company-minimum-prefix-length 1)
  (setq company-dabbrev-downcase 0)
  (setq company-idle-delay 0))

(use-package cider
  :ensure t)

(add-hook 'racket-mode-hook #'lsp)
(add-hook 'racket-mode-hook 'company-mode)

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
  (define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)   ;; 向左切换窗口
  (define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)   ;; 向下切换窗口
  (define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)     ;; 向上切换窗口
  (define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)  ;; 向右切换窗口

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
  (setq evil-visual-state-cursor 'box)
  (setq evil-normal-state-cursor 'box) 
  (setq evil-insert-state-cursor 'bar)  
  (setq evil-replace-state-cursor 'hbar))



(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode))

(defun my-racket-mode-hook () 
  (set (make-local-variable 'company-backends)
       '((company-capf company-dabbrev-code))))

(use-package racket-mode
  :ensure t
  :hook
  (racket-mode . lsp)
  :config
  (add-hook 'racket-xp-mode-hook
            (lambda ()
              (remove-hook 'pre-redisplay-functions
                           #'racket-xp-pre-redisplay
                           t)))
  (set-face-attribute 'racket-keyword-argument-face nil :foreground "#808080")
  (set-face-attribute 'font-lock-function-name-face nil :background "color-255" :italic nil :foreground "black" :weight 'bold :underline nil))
(add-to-list 'auto-mode-alist '("\\.scrbl\\'" . racket-mode))
(add-hook 'racket-mode-hook 'company-mode)
(add-hook 'racket-repl-mode-hook 'company-mode)


(add-hook 'my-racket-mode-hook 'company-mode)
(add-hook 'my-racket-repl-mode-hook 'company-mode)

(use-package 
  lsp-mode
  :ensure t
  :hook ((haskell-mode . lsp)
         (python-mode . lsp)
         (racket-mode . lsp))
  :config
  (define-key evil-normal-state-map (kbd "]e") 'flymake-goto-next-error)
  (define-key evil-normal-state-map (kbd "[e") 'flymake-goto-prev-error)
  (setq lsp-headerline-breadcrumb-enable nil)
  :commands lsp)

(use-package eziam-themes
  :ensure t
  :config
  (load-theme 'eziam-light t)
  (custom-set-faces
   '(default ((t (:background "unspecified-bg"))))
   '(show-paren-match ((t (:background "cyan" :foreground "black" :weight bold))))
   '(show-paren-mismatch ((t (:background "red" :foreground "white" :weight bold))))))


(defface haskell-normal
  '((t (:foreground "black" :background "#f9f9f9" :underline nil)))
  "My custom face.")


(use-package haskell-mode
  :ensure t
  :config
  (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
  (setq haskell-stylish-on-save t) 
  (setq haskell-indentation-layout-offset 4) 
  (setq haskell-indentation-starter-offset 4)
  (set-face-attribute 'haskell-constructor-face nil :background nil :underline nil :italic nil)
  (set-face-attribute 'haskell-definition-face nil :foreground "color-16" :background "color-255" :underline nil :italic nil)
  (set-face-attribute 'haskell-operator-face nil :foreground "color-16" :background "color-255" :underline nil)
  (set-face-attribute 'haskell-type-face nil :underline nil))


(use-package lsp-pyright
  :ensure t
  :custom (lsp-pyright-langserver-command "pyright") 
  :hook (python-mode . (lambda () (require 'lsp-pyright) (lsp))))

(use-package lsp-haskell :ensure t)


(use-package windmove
  :ensure t
  :config
  (windmove-default-keybindings)
  (global-set-key (kbd "C-h") 'windmove-left)
  (global-set-key (kbd "C-j") 'windmove-down)
  (global-set-key (kbd "C-k") 'windmove-up)
  (global-set-key (kbd "C-l") 'windmove-right));; 默认的 Alt + hjkl 移动窗口


(use-package scribble-mode
  :ensure t
  :mode "\\.scrbl\\'"
  :config
  ;; 基础设置
  (setq scribble-indent-width 2)
  
  ;; 添加自动补全支持
  (add-hook 'scribble-mode-hook #'company-mode)
  
  ;; 启用括号匹配
  (add-hook 'scribble-mode-hook #'show-paren-mode)
  
  ;; 启用 rainbow delimiters
 ; (add-hook 'scribble-mode-hook #'rainbow-delimiters-mode)
  
  ;; 设置快捷键
  (define-key scribble-mode-map (kbd "C-c C-c") 'racket-run)
  (define-key scribble-mode-map (kbd "C-c C-k") 'racket-check-syntax-mode)
  
  ;; 语法高亮设置
  (font-lock-add-keywords
   'scribble-mode
   '(("@section\\|@subsection\\|@subsubsection" . font-lock-keyword-face)
     ("@define\\|@require" . font-lock-function-name-face)
     ("@\\w+" . font-lock-preprocessor-face))))

;; 配置 racket-mode 支持
(add-hook 'racket-mode-hook
          (lambda ()
            (define-key racket-mode-map (kbd "C-c C-d") 'racket-doc)
            (define-key racket-mode-map (kbd "C-c C-r") 'racket-run)))

;; 配置 flycheck 支持（可选）
(use-package flycheck
  :ensure t
  :config
  (add-hook 'scribble-mode-hook 'flycheck-mode))

(defun my-scribble-build ()
  "Compile the current Scribble file."
  (interactive)
  (when (buffer-file-name)
    (let ((output (shell-command-to-string
                   (format "scribble %s" (shell-quote-argument (buffer-file-name))))))
      (message "%s" output))))

(add-hook 'racket-mode-hook
          (lambda ()
            (when (string-match "\\.scrbl\\'" (or (buffer-file-name) ""))
              (local-set-key (kbd "C-c C-c") 'my-scribble-build))))

(font-lock-add-keywords
 'racket-mode
 '(("@\\w+{" . font-lock-keyword-face)))

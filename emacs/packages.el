;;; packages.el --- 包配置 -*- lexical-binding: t; -*-

;;; ============================================================================
;;; 包管理器设置
;;; ============================================================================

(require 'package)

(setq package-archives
      '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
        ("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t)
(setq package-check-signature nil)

(use-package diminish :ensure t)

;;; ============================================================================
;;; 补全系统
;;; ============================================================================

;; ---- Ivy ----
(use-package ivy
  :ensure t
  :diminish (ivy-mode . "")
  :config
  (ivy-mode 1)
  (use-package ivy-prescient :ensure t
    :config (ivy-prescient-mode 1))
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-height 15)
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-count-format "%d/%d")
  (setq ivy-re-builders-alist
        `((t . ivy--regex-ignore-order))))

;; ---- Counsel ----
(use-package counsel
  :ensure t
  :config
  (ivy-configure 'counsel-M-x :initial-input "")
  :bind (("M-x" . counsel-M-x)
         ("C-;" . counsel-M-x)
         ("\C-x \C-f" . counsel-find-file)))

;; ---- Swiper ----
(use-package swiper
  :ensure t
  :bind (("\C-s" . swiper)))

;; ---- Ivy-rich ----
(use-package ivy-rich :ensure t
  :init (ivy-rich-mode 1))

;; ---- Company ----
(use-package company
  :ensure t
  :hook (prog-mode . company-mode)
  :init (global-company-mode)
  :config
  (setq company-minimum-prefix-length 1)
  (setq company-dabbrev-downcase 0)
  (setq company-idle-delay 0.1)
  (add-to-list 'company-backends 'company-capf))

;;; ============================================================================
;;; 导航和搜索
;;; ============================================================================

;; ---- Projectile ----
(use-package projectile
  :ensure t
  :bind-keymap
  ("\C-c p" . projectile-command-map)
  :config
  (projectile-mode t)
  (setq projectile-completion-system 'ivy)
  (use-package counsel-projectile :ensure t))

;; ---- 搜索工具 ----
(use-package ag :ensure t)

(use-package rg
  :ensure t
  :config
  (rg-enable-default-bindings)
  (setq rg-group-result t rg-show-columns t))

;; ---- Which-key ----
(use-package which-key :ensure t
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

;; ---- Windmove ----
(use-package windmove
  :ensure t
  :config
  (windmove-default-keybindings)
  (global-set-key (kbd "C-h") 'windmove-left)
  (global-set-key (kbd "C-j") 'windmove-down)
  (global-set-key (kbd "C-k") 'windmove-up)
  (global-set-key (kbd "C-l") 'windmove-right))

;;; ============================================================================
;;; 编辑增强
;;; ============================================================================

;; ---- Yasnippet ----
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode)
  (use-package yasnippet-snippets :ensure t))

;; ---- Expand-region ----
(use-package expand-region
  :ensure t
  :bind (("<C-S-right>" . er/expand-region)
         ("<C-S-left>" . er/contract-region)))

;; ---- Paredit ----
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
         (cider-mode . enable-paredit-mode)))

;; ---- 中英文自动空格 ----
(defun my-insert-space-between-cn-and-en (char)
  "在中英文之间自动插入空格。"
  (let* ((prev (char-before))
         (next (char-after))
         (is-en (and (>= char ?!) (<= char ?~)))
         (is-cn-prev (and prev (>= prev #x4e00)))
         (is-cn-next (and next (>= next #x4e00))))
    (when (and is-en is-cn-prev (not (eq prev ?\s)))
      (insert " "))
    (when (and is-en is-cn-next)
      (save-excursion (insert " ")))))

(defun my-self-insert-hook ()
  (when (and (characterp last-command-event)
             (>= last-command-event 32))
    (my-insert-space-between-cn-and-en last-command-event)))

(defun my-enable-cn-en-space ()
  "Enable auto space insertion only for non-programming modes."
  (unless (derived-mode-p 'prog-mode)
    (add-hook 'post-self-insert-hook #'my-self-insert-hook nil t)))

(add-hook 'after-change-major-mode-hook #'my-enable-cn-en-space)

;;; ============================================================================
;;; Dired
;;; ============================================================================

(put 'dired-find-alternate-file 'disabled nil)
(setq delete-by-moving-to-trash t)

(defun my-dired-clear-marks-and-refresh (&rest _args)
  "Clear marks and refresh Dired buffers after moving files."
  (dired-unmark-all-marks)
  (dired-do-redisplay))

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

;;; ============================================================================
;;; Evil
;;; ============================================================================

(defun evil-keyboard-quit ()
  "Keyboard quit and force normal state."
  (interactive)
  (and evil-mode (evil-force-normal-state))
  (keyboard-quit))

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (fset 'evil-visual-update-x-selection 'ignore)
  :config
  (evil-mode 1)
  (define-key evil-motion-state-map (kbd "C-z") 'suspend-frame)
  (evil-ex-define-cmd "q" 'kill-this-buffer)
  (evil-ex-define-cmd "quit" 'evil-quit)
  (evil-ex-define-cmd "wq" (lambda () (interactive) (save-buffer) (kill-this-buffer)))
  (evil-ex-define-cmd "x" (lambda () (interactive) (save-buffer) (kill-this-buffer)))
  (define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
  (define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
  (define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
  (define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)
  (define-key evil-normal-state-map (kbd "gt") 'next-buffer)
  (define-key evil-normal-state-map (kbd "gT") 'previous-buffer)
  (define-key evil-normal-state-map (kbd "C-g") #'evil-keyboard-quit)
  (define-key evil-motion-state-map (kbd "C-g") #'evil-keyboard-quit)
  (define-key evil-insert-state-map (kbd "C-g") #'evil-keyboard-quit)
  (define-key evil-window-map (kbd "C-g") #'evil-keyboard-quit)
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

;;; ============================================================================
;;; LSP
;;; ============================================================================

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode))

(use-package lsp-mode
  :ensure t
  :hook ((haskell-mode . lsp)
         (python-mode . lsp)
         (racket-mode . lsp))
  :config
  (define-key evil-normal-state-map (kbd "]e") 'flymake-goto-next-error)
  (define-key evil-normal-state-map (kbd "[e") 'flymake-goto-prev-error)
  (setq lsp-headerline-breadcrumb-enable nil)
  :commands lsp)

;;; ============================================================================
;;; 编程语言 - Racket
;;; ============================================================================

(use-package racket-mode
  :ensure t
  :mode "\\.scrbl\\'"
  :hook ((racket-mode . lsp)
         (racket-mode . company-mode)
         (racket-repl-mode . company-mode))
  :config
  (add-hook 'racket-xp-mode-hook
            (lambda ()
              (remove-hook 'pre-redisplay-functions
                           #'racket-xp-pre-redisplay
                           t)))
  (setq racket-mode-help-on-errors nil)
  :bind (:map racket-mode-map
              ("C-c C-d" . racket-doc)
              ("C-c C-r" . racket-run)))

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

(font-lock-add-keywords 'racket-mode '(("@\\w+{" . font-lock-keyword-face)))

;;; ============================================================================
;;; 编程语言 - Haskell
;;; ============================================================================

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

(use-package lsp-haskell :ensure t)

;;; ============================================================================
;;; 编程语言 - Python
;;; ============================================================================

(use-package lsp-pyright
  :ensure t
  :custom (lsp-pyright-langserver-command "pyright")
  :hook (python-mode . (lambda () (require 'lsp-pyright) (lsp))))

;;; ============================================================================
;;; 编程语言 - Rust
;;; ============================================================================

(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'"
  :config
  (setq rust-format-on-save t))

(use-package eglot
  :ensure nil
  :hook ((rust-mode . eglot-ensure)
         (rust-ts-mode . eglot-ensure))
  :config
  (setq eglot-events-buffer-size 0)
  (add-to-list 'eglot-server-programs
               '((rust-mode rust-ts-mode) . ("rust-analyzer")))
  (define-key eglot-mode-map (kbd "C-c r") 'eglot-rename)
  (define-key eglot-mode-map (kbd "C-c f") 'eglot-code-actions))

;;; ============================================================================
;;; 编程语言 - Clojure
;;; ============================================================================

(use-package cider :ensure t)
(use-package edn :ensure t)
(use-package flycheck-clj-kondo :ensure t :after (flycheck cider))

;;; ============================================================================
;;; 编程语言 - Dart
;;; ============================================================================

(use-package dart-mode :ensure t
  :mode "\\.dart\\'"
  :hook (dart-mode . flutter-test-mode))

;;; ============================================================================
;;; 编程语言 - Scribble
;;; ============================================================================

(use-package scribble-mode
  :ensure t
  :mode "\\.scrbl\\'"
  :config
  (setq scribble-indent-width 2)
  (add-hook 'scribble-mode-hook #'company-mode)
  (add-hook 'scribble-mode-hook #'show-paren-mode)
  :bind (:map scribble-mode-map
              ("C-c C-c" . racket-run)
              ("C-c C-k" . racket-check-syntax-mode)))

;;; ============================================================================
;;; Flycheck
;;; ============================================================================

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config
  (add-hook 'scribble-mode-hook 'flycheck-mode))

;;; ============================================================================
;;; Org 模式
;;; ============================================================================

(defun org-font-setup ()
  (when (display-graphic-p)
    (font-lock-add-keywords
     'org-mode
     '(("^ *\\([-]\\) "
        (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
    (dolist (pair '((org-level-1 . 1.2)
                    (org-level-2 . 1.15)
                    (org-level-3 . 1.10)
                    (org-level-4 . 1.09)
                    (org-level-5 . 1.08)
                    (org-level-6 . 1.07)
                    (org-level-7 . 1.06)
                    (org-level-8 . 1.05)))
      (let* ((face (car pair))
             (val (cdr pair))
             (height (if (and (numberp val) (< val 3))
                         (truncate (* val 100))
                       (truncate val))))
        (set-face-attribute face nil
                            :font "Ubuntu"
                            :weight 'regular
                            :height height)))))

(use-package org-bullets
  :ensure t
  :after org
  :hook ((org-mode . org-font-setup)
         (org-mode . org-bullets-mode))
  :custom
  (org-bullets-bullet-list '("✱" "◉" "◆" "◇" "◈" "✲" "✧" "⊙" "✦" "⊚" "⊛" "○")))

(use-package org :ensure t)

;;; ============================================================================
;;; 输入法
;;; ============================================================================

(use-package rime
  :ensure t
  :custom
  (default-input-method "rime")
  (rime-title " 中 ")
  (rime-user-data-dir "~/.config/rime")
  :config
  (setq rime-show-candidate 'minibuffer)
  (setq rime-inline-ascii-trigger 'shift-l))

;;; ============================================================================
;;; 其他工具
;;; ============================================================================

;; 终端
(use-package eat :ensure t)

;; 命令日志
(use-package command-log-mode :ensure t)

;;; packages.el ends here

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

(use-package envrc
  :ensure t
  :config
  (envrc-global-mode +1))

;;; ============================================================================
;;; 补全系统
;;; ============================================================================

;; ---- Legacy Ivy / Counsel / Swiper (disabled after Vertico migration) ----
;; (use-package ivy
;;   :ensure t
;;   :diminish (ivy-mode . "")
;;   :config
;;   (ivy-mode 1)
;;   (use-package ivy-prescient :ensure t
;;     :config (ivy-prescient-mode 1))
;;   (setq ivy-use-virtual-buffers t)
;;   (setq enable-recursive-minibuffers t)
;;   (setq ivy-height 15)
;;   (setq ivy-initial-inputs-alist nil)
;;   (setq ivy-count-format "%d/%d")
;;   (setq ivy-re-builders-alist
;;         `((t . ivy--regex-ignore-order))))
;;
;; (use-package counsel
;;   :ensure t
;;   :config
;;   (ivy-configure 'counsel-M-x :initial-input "")
;;   :bind (("M-x" . counsel-M-x)
;;          ("C-;" . counsel-M-x)
;;          ("\C-x \C-f" . counsel-find-file)))
;;
;; (use-package swiper
;;   :ensure t
;;   :bind (("\C-s" . swiper)))
;;
;; (use-package ivy-rich :ensure t
;;   :init (ivy-rich-mode 1))

;; ---- Savehist ----
(use-package savehist
  :ensure nil
  :init
  (savehist-mode 1))

;; ---- Vertico ----
(use-package vertico
  :ensure t
  :init
  (vertico-mode 1)
  :custom
  (vertico-count 15)
  (vertico-cycle t))

;; ---- Orderless ----
(use-package orderless
  :ensure t
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides
        '((file (styles basic partial-completion)))))

;; ---- Marginalia ----
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode 1))

;; ---- Consult ----
(use-package consult
  :ensure t
  :bind (("M-x" . execute-extended-command)
         ("C-;" . execute-extended-command)
         ("M-;" . execute-extended-command)
         ("C-c ;" . execute-extended-command)
         ("\C-x \C-f" . find-file)
         ("\C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("C-c h" . consult-history)
         ("C-c k" . consult-ripgrep)
         ("C-c m" . consult-imenu)))

(defun my/search-target-window ()
  "Return the main editing window used for search result jumps."
  (or
   (car
    (sort
     (seq-filter
      (lambda (window)
        (and (not (window-minibuffer-p window))
             (not (window-dedicated-p window))
             (null (window-parameter window 'window-side))
             (not (eq window (selected-window)))))
      (window-list nil 'no-minibuf))
     (lambda (a b)
       (> (* (window-total-width a) (window-total-height a))
          (* (window-total-width b) (window-total-height b))))))
   (selected-window)))

(defun my/visit-search-result-in-window (visit-fn)
  "Run VISIT-FN while forcing the target to reuse the main editing window."
  (let ((target-window (my/search-target-window))
        (result-buffer (current-buffer))
        (result-point (point)))
    (if (window-live-p target-window)
        (with-selected-window target-window
          (with-current-buffer result-buffer
            (goto-char result-point)
            (funcall visit-fn)))
      (funcall visit-fn))))

(defun my/compile-goto-error-same-window ()
  "Visit the current compilation-style result in the main editing window."
  (interactive)
  (my/visit-search-result-in-window #'compile-goto-error))

(defun my/xref-goto-same-window ()
  "Visit the current xref in the main editing window."
  (interactive)
  (my/visit-search-result-in-window #'xref-goto-xref))

(defun my/occur-goto-same-window ()
  "Visit the current occur result in the main editing window."
  (interactive)
  (my/visit-search-result-in-window #'occur-mode-goto-occurrence))

;; ---- Embark ----
(use-package embark
  :ensure t
  :bind (("C-." . embark-act)
         ("C-h B" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

;; ---- Embark Consult ----
(use-package embark-consult
  :ensure t
  :after (embark consult))

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
  (setq projectile-completion-system 'default))

;; ---- 搜索工具 ----
(use-package ag
  :ensure t
  :config
  (define-key ag-mode-map (kbd "RET") #'my/compile-goto-error-same-window))

(use-package rg
  :ensure t
  :config
  (rg-enable-default-bindings)
  (setq rg-group-result t
        rg-show-columns t)
  (define-key rg-mode-map (kbd "RET") #'my/compile-goto-error-same-window))

(with-eval-after-load 'compile
  (define-key compilation-mode-map (kbd "RET") #'my/compile-goto-error-same-window))

(with-eval-after-load 'xref
  (define-key xref--xref-buffer-mode-map (kbd "RET") #'my/xref-goto-same-window)
  (define-key xref--transient-buffer-mode-map (kbd "RET") #'my/xref-goto-same-window))

(with-eval-after-load 'replace
  (define-key occur-mode-map (kbd "RET") #'my/occur-goto-same-window))

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
;;; Dired & Wdired
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

(use-package wdired
  :ensure nil
  :after dired
  :config
  ;; 允许修改文件权限
  (setq wdired-allow-to-change-permissions t)
  ;; 在 Evil 下，进入 wdired 后自动进入 insert 模式（可选，方便直接修改）
  ;; (add-hook 'wdired-mode-hook 'evil-insert-state)
  )

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
;;; 编程语言 - Racket
;;; ============================================================================

(defvar my-racket-langserver-checked nil)
(defvar my-racket-langserver-available nil)

(defun my-racket-langserver-installed-p ()
  "Return non-nil when racket-langserver is installed."
  (unless my-racket-langserver-checked
    (setq my-racket-langserver-checked t)
    (setq my-racket-langserver-available
          (and (executable-find "raco")
               (eq 0 (call-process "raco" nil nil nil "pkg" "show" "racket-langserver")))))
  my-racket-langserver-available)

(defun my-eglot-racket-server ()
  "Return the preferred Racket LSP server command."
  (if (executable-find "xvfb-run")
      '("xvfb-run" "-a" "racket" "-l" "racket-langserver")
    '("racket" "-l" "racket-langserver")))

(defun my-racket-eglot-ensure ()
  "Start Eglot for Racket when racket-langserver is available."
  (if (my-racket-langserver-installed-p)
      (eglot-ensure)
    (message "Racket Eglot requires: raco pkg install racket-langserver")))

(use-package racket-mode
  :ensure t
  :mode "\\.scrbl\\'"
  :hook ((racket-mode . my-racket-eglot-ensure)
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
  :hook ((python-mode . eglot-ensure)
         (python-ts-mode . eglot-ensure)
         (js-mode . eglot-ensure)
         (js-ts-mode . eglot-ensure)
         (typescript-mode . eglot-ensure)
         (typescript-ts-mode . eglot-ensure)
         (tsx-ts-mode . eglot-ensure)
         (clojure-mode . eglot-ensure)
         (clojurescript-mode . eglot-ensure)
         (clojurec-mode . eglot-ensure)
         (haskell-mode . eglot-ensure)
         (rust-mode . eglot-ensure)
         (rust-ts-mode . eglot-ensure)
         (dart-mode . eglot-ensure)
         (eglot-managed-mode . (lambda ()
                                 (flymake-mode 1))))
  :bind (:map eglot-mode-map
              ("C-c C-e r" . eglot-rename)
              ("C-c C-e l" . flymake-show-buffer-diagnostics)
              ("C-c C-e p" . flymake-show-buffer-diagnostics)
              ("C-c C-e C" . eglot-show-workspace-configuration)
              ("C-c C-e R" . eglot-reconnect)
              ("C-c C-e S" . eglot-shutdown)
              ("C-c C-e A" . eglot-shutdown-all)
              ("C-c C-e a" . eglot-code-actions)
              ("C-c C-e f" . eglot-format)
              ("C-c r" . eglot-rename)
              ("C-c f" . eglot-code-actions))
  :config
  (defun my-eglot-python-server ()
    "Return the preferred Python LSP server command."
    (cond
     ((executable-find "basedpyright-langserver")
      '("basedpyright-langserver" "--stdio"))
     ((executable-find "pyright-langserver")
      '("pyright-langserver" "--stdio"))
     (t
      '("npx" "--yes" "pyright" "--stdio"))))

  (defun my-eglot-ts-server ()
    "Return the preferred TypeScript/JavaScript LSP server command."
    (if (executable-find "typescript-language-server")
        '("typescript-language-server" "--stdio")
      '("npx" "--yes" "typescript-language-server" "--stdio")))

  (setq eglot-events-buffer-size 0)
  (add-to-list 'eglot-server-programs
               `(racket-mode . ,(my-eglot-racket-server)))
  (add-to-list 'eglot-server-programs
               `((python-mode python-ts-mode) . ,(my-eglot-python-server)))
  (add-to-list 'eglot-server-programs
               `((js-mode js-ts-mode typescript-mode typescript-ts-mode tsx-ts-mode)
                 . ,(my-eglot-ts-server)))
  (add-to-list 'eglot-server-programs
               '((rust-mode rust-ts-mode) . ("rust-analyzer")))
  (add-to-list 'eglot-server-programs
               '(haskell-mode . ("haskell-language-server-wrapper" "--lsp")))
  (add-to-list 'eglot-server-programs
               '(dart-mode . ("dart" "language-server" "--protocol=lsp")))
  (add-to-list 'eglot-server-programs
               '((clojure-mode clojurescript-mode clojurec-mode)
                 . ("clojure-lsp"))))

;;; ============================================================================
;;; 编程语言 - Clojure
;;; ============================================================================

(use-package cider :ensure t)
(use-package edn :ensure t)

;;; ============================================================================
;;; 编程语言 - Dart
;;; ============================================================================

(use-package dart-mode
  :ensure t
  :mode "\\.dart\\'"
  :custom
  (dart-format-on-save t)
  :hook ((dart-mode . subword-mode)
         (dart-mode . electric-pair-local-mode))
  :bind (:map dart-mode-map
              ("C-c C-c" . eglot-format)))

(use-package flutter
  :ensure t
  :after dart-mode
  :config
  (let ((flutter-sdk (expand-file-name "~/.local/lib/flutter")))
    (when (file-directory-p flutter-sdk)
      (setq flutter-sdk-path flutter-sdk))))

;;; ============================================================================
;;; 编程语言 - JavaScript / TypeScript
;;; ============================================================================

(use-package typescript-mode
  :ensure t
  :mode ("\\.ts\\'" "\\.tsx\\'"))

(use-package js
  :ensure nil
  :mode ("\\.mjs\\'" "\\.cjs\\'" "\\.js\\'"))

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
;;; Flymake
;;; ============================================================================

(define-key evil-normal-state-map (kbd "]e") #'flymake-goto-next-error)
(define-key evil-normal-state-map (kbd "[e") #'flymake-goto-prev-error)
(global-set-key (kbd "M-n") #'flymake-goto-next-error)
(global-set-key (kbd "M-p") #'flymake-goto-prev-error)

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
;;; 主题
;;; ============================================================================

(use-package atom-one-dark-theme :ensure t)

;;; ============================================================================
;;; 其他工具
;;; ============================================================================

;; 终端
(use-package eat :ensure t)

;; 命令日志
(use-package command-log-mode :ensure t)

;; 状态栏精简（解决终端下显示不全的问题）
(use-package minions
  :ensure t
  :config
  (setq minions-mode-line-lighter " [+]") ; 在终端下显示为 [+] 比较整齐
  (minions-mode 1))

;;; packages.el ends here

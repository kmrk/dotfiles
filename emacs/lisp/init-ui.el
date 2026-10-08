;;; init-ui.el --- 界面：主题、字体、frame、tab-bar、mode-line -*- lexical-binding: t; -*-

;;; ============================================================================
;;; 真彩色支持
;;; ============================================================================

(setenv "COLORTERM" "truecolor")
(add-to-list 'term-file-aliases '("tmux-256color" . "xterm"))

(defun my/enable-tty-truecolor (frame)
  "Tell FRAME's terminal that it supports 24-bit colors."
  (when (eq (framep frame) t)
    (set-terminal-parameter (frame-terminal frame) 'colors 16777216)))

(add-hook 'after-make-frame-functions #'my/enable-tty-truecolor)

;;; ============================================================================
;;; 基础界面（菜单栏/工具栏/滚动条在 early-init.el 里关掉）
;;; ============================================================================

(setq inhibit-startup-message t
      frame-title-format "%b - Emacs"
      visible-bell t)
(column-number-mode 1)
(tab-bar-mode 1)
(winner-mode 1)
(show-paren-mode 1)
(electric-pair-mode 1)
(setq electric-pair-pairs '((?\' . ?\')))
(tooltip-mode -1)
(set-mouse-color "#000")
(global-eldoc-mode 1)
(setq eldoc-echo-area-use-multiline-p nil)
(setq-default line-spacing 0)

;; 相对行号
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

;; 字符串引号也像括号一样高亮
(require 'pair-highlight)
(pair-highlight-mode 1)

;; 鼠标支持（终端）
(xterm-mouse-mode 1)

;;; ============================================================================
;;; Frame 与字体（GUI）
;;; ============================================================================

(setq initial-frame-alist '((top . 100) (left . 100) (width . 160) (height . 50)))

(defun my/setup-graphic-frame (frame)
  "Apply size and font settings to graphical FRAME."
  (with-selected-frame frame
    (when (display-graphic-p)
      (set-frame-size frame 120 40)
      (set-face-attribute 'default frame :font "Monaspace Neon NF-9"))))

(add-hook 'after-make-frame-functions #'my/setup-graphic-frame)
(my/setup-graphic-frame (selected-frame))

;;; ============================================================================
;;; Tab Bar
;;; ============================================================================

(setq tab-bar-close-button-show nil
      tab-bar-auto-width t
      tab-bar-auto-width-max nil
      tab-bar-new-button-show t
      tab-bar-tab-name-truncated-max 100
      tab-bar-format '(tab-bar-format-tabs
                       tab-bar-format-align-right
                       tab-bar-format-global))

;; tab 名显示 buffer 名 + 未保存标记 + Git 状态
(require 'tab-bar-vc)
(tab-bar-vc-mode 1)

;;; ============================================================================
;;; 主题
;;; ============================================================================

(use-package doom-themes
  :config
  (load-theme 'doom-one t)
  (doom-themes-org-config)
  (set-face-attribute 'line-number nil :foreground "#54636D"))

;;; ============================================================================
;;; 模式行
;;; ============================================================================

(defvar-local my/line-count-cache nil
  "Cons of (MODIFIED-TICK . LINE-COUNT) for the current buffer.")

(defun my/buffer-line-count ()
  "Return the buffer's line count as a string, recounting only after edits."
  (let ((tick (buffer-chars-modified-tick)))
    (unless (eql (car my/line-count-cache) tick)
      (setq my/line-count-cache
            (cons tick (count-lines (point-min) (point-max)))))
    (number-to-string (cdr my/line-count-cache))))

;; 显示 (当前行/总行数:列)
(setq-default mode-line-position
              '((line-number-mode ("(%l/" (:eval (my/buffer-line-count))))
                (column-number-mode ":%c)")))

(use-package minions
  :config
  (setq minions-mode-line-lighter " [+]") ; 在终端下显示为 [+] 比较整齐
  (minions-mode 1))

(use-package keycast
  :custom
  (keycast-tab-bar-format "[%k]%c%R")
  (keycast-tab-bar-minimal-width 30)
  :config
  (keycast-tab-bar-mode 1))

(use-package smart-mode-line
  :init
  (setq sml/no-confirm-load-theme t)
  (sml/setup))

;;; ============================================================================
;;; Speedbar
;;; ============================================================================

(setq speedbar-show-unknown-files t
      speedbar-directory-unshown-regexp "^$"
      tree-widget-image-enable nil)

(provide 'init-ui)
;;; init-ui.el ends here

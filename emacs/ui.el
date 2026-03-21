;;; ui.el --- UI 配置 -*- lexical-binding: t; -*-

;;; ============================================================================
;;; 真彩色支持
;;; ============================================================================

(setenv "COLORTERM" "truecolor")
(add-to-list 'term-file-aliases '("tmux-256color" . "xterm"))

(add-hook 'after-make-frame-functions
          (lambda (frame)
            (when (eq (framep frame) t)
              (set-terminal-parameter (frame-terminal frame) 'colors 16777216))))

;;; ============================================================================
;;; 基础界面
;;; ============================================================================

(setq inhibit-startup-message t)
(setq frame-title-format "%b - Emacs")
(tool-bar-mode 0)
(scroll-bar-mode 0)
(menu-bar-mode 0)
(column-number-mode 1)
(global-tab-line-mode t)
(winner-mode t)
(show-paren-mode t)
(electric-pair-mode t)
(setq electric-pair-pairs '((?\' . ?\')))
(setq visible-bell t)
(setq tooltip-mode nil)
(set-mouse-color "#000")
(global-eldoc-mode nil)
(setq eldoc-echo-area-use-multiline-p nil)

;; 行间距
(setq-default line-spacing 0)

;; 缩进
(setq-default indent-tabs-mode nil)

;;; ============================================================================
;;; 备份文件
;;; ============================================================================

(defconst emacs-tmp-dir (format "%s%s%s/" temporary-file-directory "emacs" (user-uid)))
(setq backup-directory-alist `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms `((".*" ,emacs-tmp-dir t)))
(setq auto-save-list-file-prefix emacs-tmp-dir)

;;; ============================================================================
;;; 模式行
;;; ============================================================================

;; 显示 (当前行/总行数,列)
(setq-default mode-line-position
              '((line-number-mode
                 ("(%l/" (:eval (number-to-string (count-lines (point-min) (point-max))))))
                (column-number-mode ":%c)")))

;;; ============================================================================
;;; 窗口和帧
;;; ============================================================================

;; 窗口分割
(setq split-width-threshold 0)
(setq split-height-threshold nil)

;; 初始窗口大小
(setq initial-frame-alist '((top . 100) (left . 100) (width . 160) (height . 50)))

(defun my/setup-frame-size (frame)
  (with-selected-frame frame
    (when (display-graphic-p)
      (set-frame-size frame 120 40))))

(add-hook 'after-make-frame-functions #'my/setup-frame-size)
(when (display-graphic-p)
  (my/setup-frame-size (selected-frame)))

;;; ============================================================================
;;; 字体
;;; ============================================================================

(defun my/setup-font (frame)
  (with-selected-frame frame
    (when (display-graphic-p)
      (set-face-attribute 'default frame
                          :font "Monaspace Neon NF-9"))))

(add-hook 'after-make-frame-functions #'my/setup-font)
(when (display-graphic-p)
  (my/setup-font (selected-frame)))

;;; ============================================================================
;;; 终端相关
;;; ============================================================================

;; 鼠标支持
(xterm-mouse-mode 1)

;; 透明背景（终端）
;(defun my-make-emacs-transparent ()
;  (unless (display-graphic-p)
;    (set-face-background 'default "unspecified-bg")
;    (set-face-background 'fringe "unspecified-bg")))

;(add-hook 'window-setup-hook 'my-make-emacs-transparent)

;;; ============================================================================
;;; Speedbar
;;; ============================================================================

(setq speedbar-show-unknown-files t)
(setq speedbar-directory-unshown-regexp "^$")
(setq tree-widget-image-enable nil)

;;; ============================================================================
;;; 主题
;;; ============================================================================

;; 根据时间切换主题
;(defun my/remove-tty-face-boxes ()
;  "Drop face box attributes that use GUI-style colors in terminal Emacs.
;
;Some themes set `:box' colors like \"#64645E\", which can trigger
;`Invalid face box color' on TTY frames.  In that case, keep the theme
;but remove box styling after it is enabled."
;  (unless (display-graphic-p)
;    (dolist (face (face-list))
;      (when (facep face)
;        (let ((box (face-attribute face :box nil 'default)))
;          (when (or (stringp box)
;                    (and (listp box) (plist-get box :color)))
;            (set-face-attribute face nil :box nil)))))))

;(defun my/theme-switcher ()
;  (interactive)
;  (let ((hour (string-to-number (format-time-string "%H"))))
;    (mapc #'disable-theme custom-enabled-themes)
;    (if (and (>= hour 7) (< hour 18))
;        (load-theme 'leuven t)
;      (load-theme 'atom-one-dark t))
;    (my/remove-tty-face-boxes)))



;;; ============================================================================
;;; 特殊缓冲区显示位置
;;; ============================================================================

;; Keep source buffers in the main editing area and reserve side windows for
;; transient result/help buffers.
(setq even-window-sizes nil)
(setq display-buffer-base-action
      '((display-buffer-reuse-window display-buffer-use-some-window)))

(add-to-list
 'display-buffer-alist
 '("\\*Help\\*"
   (display-buffer-reuse-window display-buffer-in-side-window)
   (side . right)
   (slot . 0)
   (window-width . 0.3)))

(add-to-list
 'display-buffer-alist
 '("\\*xref\\*"
   (display-buffer-reuse-window display-buffer-in-side-window)
   (side . bottom)
   (slot . 0)
   (window-height . 0.25)))

(add-to-list
 'display-buffer-alist
 '("\\*grep\\*"
   (display-buffer-reuse-window display-buffer-in-side-window)
   (side . bottom)
   (slot . 1)
   (window-height . 0.25)))

(add-to-list
 'display-buffer-alist
 '("\\*compilation\\*"
   (display-buffer-reuse-window display-buffer-in-side-window)
   (side . bottom)
   (slot . 2)
   (window-height . 0.25)))

(add-to-list
 'display-buffer-alist
 '("\\*Racket Repl \\(.*\\)\\*"
   (display-buffer-reuse-window display-buffer-in-side-window)
   (side . right)
   (slot . 1)
   (window-width . 0.3)))

(add-to-list
 'display-buffer-alist
 '("\\*haskell\\*"
   (display-buffer-reuse-window display-buffer-in-side-window)
   (side . right)
   (slot . 2)
   (window-width . 0.3)))

;;; ui.el ends here

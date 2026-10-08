;;; early-init.el --- 启动早期设置 -*- lexical-binding: t; -*-

;; 启动期间放宽 GC，启动完成后恢复到适合 LSP 的值。
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 16 1024 1024))))

;; 在第一个 frame 创建之前关掉界面元素，避免闪烁。
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq menu-bar-mode nil
      tool-bar-mode nil
      scroll-bar-mode nil)

;;; early-init.el ends here

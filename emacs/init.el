;;; init.el --- Emacs 主配置文件 -*- lexical-binding: t; -*-

;;; ============================================================================
;;; 基础环境设置
;;; ============================================================================

;; Guix 库路径
(setenv "LD_LIBRARY_PATH"
        (concat (expand-file-name "~/.guix-profile/lib") ":"
                (or (getenv "LD_LIBRARY_PATH") "")))

;; 编码设置
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; 终端设置
(setq term-buffer-maximum-size 0)
(setq vterm-max-scroll-back 10000)
(setenv "TERM" "xterm-256color")

;; Shell 设置
(setq shell-file-name "/bin/bash")
(setq explicit-shell-file-name "/bin/bash")
(setq shell-command-switch "-ic")

;; 终端功能键映射
(define-key input-decode-map "\e[1;2A" [S-up])
(define-key input-decode-map "\e[1;2B" [S-down])
(define-key input-decode-map "\e[1;2C" [S-right])
(define-key input-decode-map "\e[1;2D" [S-left])
(define-key input-decode-map "\e[1;5A" [C-up])
(define-key input-decode-map "\e[1;5B" [C-down])
(define-key input-decode-map "\e[1;5C" [C-right])
(define-key input-decode-map "\e[1;5D" [C-left])
(define-key input-decode-map "\e[1;6A" [C-S-up])
(define-key input-decode-map "\e[1;6B" [C-S-down])
(define-key input-decode-map "\e[1;6C" [C-S-right])
(define-key input-decode-map "\e[1;6D" [C-S-left])

;; 本地变量安全设置
(setq safe-local-variable-values
      '((coding . utf-8)
        (py-indent-offset . 4)))

;; 执行路径
(add-to-list 'exec-path "~/.cargo/bin")

;; 关闭 Emacs client
(defun my-close-emacs-client ()
  "Close the current Emacs client without killing the daemon."
  (interactive)
  (if (y-or-n-p "Do you want to close this Emacs client? ")
      (server-edit)
    (message "Cancelled closing client")))

;; 关闭其他缓冲区
(defun kkk ()
  (interactive)
  (mapc 'kill-buffer (cdr (buffer-list (current-buffer)))))

;; Rust analyzer
(executable-find "rust-analyzer")

;;; ============================================================================
;;; 加载模块
;;; ============================================================================

(load "~/.emacs.d/ui.el")
(load "~/.emacs.d/packages.el")

;;; ============================================================================
;;; Custom 设置
;;; ============================================================================

(custom-set-variables
 '(custom-safe-themes
   '("4f1e4cadfd4f998cc23338246bae383a0d3a99a5edea9bcf26922ef054671299"
     "a5c590aeb7dc5c2b8d36601a4c94a1145e46bd2291571af02807dd7a8552630c"
     "28b9703810da2df6fb8667b681cea47d6fbfa5df6a7f23d5dee41d25acca38ba"
     "bb8587d7e8ba2a39fcd293498140598188c7bd0c8be0360cca36f08c2b7bf5d9"
     "fc5c5ec472d1a97e99bf294efdae866827ff78692530038e4df7b6dfe633263d"
     "ba4f725d8e906551cfab8c5f67e71339f60fac11a8815f51051ddb8409ea6e5c"
     "b02eae4d22362a941751f690032ea30c7c78d8ca8a1212fdae9eecad28a3587f"
     "c8b83e7692e77f3e2e46c08177b673da6e41b307805cd1982da9e2ea2e90e6d7"
     "95b0bc7b8687101335ebbf770828b641f2befdcf6d3c192243a251ce72ab1692"
     "f0f5201c7dd9a5d9f84e3f98099230ebb27f2c9db4fc5395b994451242dcbd8f"
     "f5f070872db3e4d8b82dbb2f3b1c60beca86fc93327a38ebddd22070458a14bc"
     default))
 '(eglot-confirm-server-edits nil nil nil "Customized with use-package eglot")
 '(package-selected-packages nil))

(custom-set-faces
 '(show-paren-match ((t (:background "cyan" :foreground "black" :weight bold))))
 '(show-paren-mismatch ((t (:background "red" :foreground "white" :weight bold)))))

;;; init.el ends here

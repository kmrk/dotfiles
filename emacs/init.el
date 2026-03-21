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
;;; 
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

;; Make Nix-installed tools visible even for GUI/daemon Emacs sessions.
(dolist (path '("~/.local/bin"
                "~/.nix-profile/bin"
                "/nix/var/nix/profiles/default/bin"
                "~/.local/lib/flutter/bin"))
  (let ((expanded (expand-file-name path)))
    (when (file-directory-p expanded)
      (add-to-list 'exec-path expanded)
      (setenv "PATH" (concat expanded path-separator (or (getenv "PATH") ""))))))

;; Make Node/NPM tools from NVM visible to GUI/daemon Emacs sessions.
(let* ((nvm-root (expand-file-name "~/.nvm/versions/node"))
       (node-bin-dirs
        (when (file-directory-p nvm-root)
          (sort (directory-files nvm-root t "^v[0-9]")
                #'string>))))
  (dolist (dir node-bin-dirs)
    (let ((bin-dir (expand-file-name "bin" dir)))
      (when (file-directory-p bin-dir)
        (add-to-list 'exec-path bin-dir)
        (setenv "PATH" (concat bin-dir path-separator (or (getenv "PATH") "")))))))

;; Completion defaults
(setq tab-always-indent 'complete
      completions-max-height 20
      completion-auto-select 'second-tab)

;; 设置相对行号
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)


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

;; For emacsclient / quick startup
(require 'server)
(unless (server-running-p)
  (server-start))

;;; ============================================================================
;;; 加载模块
;;; ============================================================================

(load "~/.emacs.d/ui.el")
(load "~/.emacs.d/packages.el")


;;; ============================================================================
;;; Custom 设置
;;; ============================================================================

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("ca1b398ceb1b61709197478dc7f705b8337a0a9631e399948e643520c5557382"
     "b6269b0356ed8d9ed55b0dcea10b4e13227b89fd2af4452eee19ac88297b0f99"
     "03239f8106a402b9d965757a0cdeab5e70961cb39fa11f1e803e9caf4250786d"
     "65057902bcd51d84e0e28036f4759295e08f57b1ba94b9ae10a8d5ffde5f154f"
     "e3a1b1fb50e3908e80514de38acbac74be2eb2777fc896e44b54ce44308e5330"
     "fb83a50c80de36f23aea5919e50e1bccd565ca5bb646af95729dc8c5f926cbf3"
     "4f1e4cadfd4f998cc23338246bae383a0d3a99a5edea9bcf26922ef054671299"
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


(defun wsl-copy-to-clipboard (text &optional push)
  (with-temp-buffer
    (insert text)
    (call-process-region (point-min) (point-max) 
                         "/mnt/c/Windows/System32/clip.exe")))

(setq interprogram-cut-function 'wsl-copy-to-clipboard)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; init-env.el --- 运行环境：PATH、编码、Shell、终端、剪贴板、server -*- lexical-binding: t; -*-

;;; ============================================================================
;;; PATH / exec-path
;;; ============================================================================

(defun my/env-prepend-path (dir)
  "Prepend DIR to both `exec-path' and $PATH when it exists."
  (let ((expanded (expand-file-name dir)))
    (when (file-directory-p expanded)
      (add-to-list 'exec-path expanded)
      (setenv "PATH" (concat expanded path-separator (or (getenv "PATH") ""))))))

;; Guix 库路径
(setenv "LD_LIBRARY_PATH"
        (concat (expand-file-name "~/.guix-profile/lib") ":"
                (or (getenv "LD_LIBRARY_PATH") "")))

(add-to-list 'exec-path (expand-file-name "~/.cargo/bin"))

;; 让 GUI/daemon 方式启动的 Emacs 也能找到 Nix 等安装的工具。
(dolist (dir '("~/.local/bin"
               "~/.nix-profile/bin"
               "/nix/var/nix/profiles/default/bin"
               "~/.local/lib/flutter/bin"))
  (my/env-prepend-path dir))

;; NVM 安装的 Node/NPM 工具。
(let ((nvm-root (expand-file-name "~/.nvm/versions/node")))
  (when (file-directory-p nvm-root)
    (dolist (dir (sort (directory-files nvm-root t "^v[0-9]") #'string>))
      (my/env-prepend-path (expand-file-name "bin" dir)))))

;;; ============================================================================
;;; 编码
;;; ============================================================================

(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;;; ============================================================================
;;; Shell / 终端
;;; ============================================================================

(setq shell-file-name "/bin/bash"
      explicit-shell-file-name "/bin/bash"
      shell-command-switch "-ic")

(setq term-buffer-maximum-size 0
      vterm-max-scroll-back 10000)
(setenv "TERM" "xterm-256color")

;; 终端功能键映射
(dolist (m '(("\e[1;2A" . [S-up])    ("\e[1;2B" . [S-down])
             ("\e[1;2C" . [S-right]) ("\e[1;2D" . [S-left])
             ("\e[1;5A" . [C-up])    ("\e[1;5B" . [C-down])
             ("\e[1;5C" . [C-right]) ("\e[1;5D" . [C-left])
             ("\e[1;6A" . [C-S-up])    ("\e[1;6B" . [C-S-down])
             ("\e[1;6C" . [C-S-right]) ("\e[1;6D" . [C-S-left])))
  (define-key input-decode-map (car m) (cdr m)))

;; 本地变量安全设置
(setq safe-local-variable-values
      '((coding . utf-8)
        (py-indent-offset . 4)))

;;; ============================================================================
;;; WSL 剪贴板（win32yank）
;;; ============================================================================

(defconst wsl-win32yank-path
  (or (executable-find "win32yank.exe")
      "/mnt/c/Program Files/Neovim/bin/win32yank.exe"))

(defun wsl-copy-to-clipboard (text &optional push)
  (when (and (not push) text)
    (with-temp-buffer
      (insert text)
      (call-process-region (point-min) (point-max)
                           wsl-win32yank-path nil 0 nil "-i" "--crlf"))))

(defun wsl-paste-from-clipboard ()
  (string-trim-right
   (with-output-to-string
     (with-current-buffer standard-output
       (call-process wsl-win32yank-path nil t nil "-o" "--lf")))))

(when (file-executable-p wsl-win32yank-path)
  (setq interprogram-cut-function #'wsl-copy-to-clipboard
        interprogram-paste-function #'wsl-paste-from-clipboard))

;;; ============================================================================
;;; direnv / Server
;;; ============================================================================

(use-package envrc
  :config
  (envrc-global-mode +1))

(require 'server)
(unless (server-running-p)
  (server-start))

(provide 'init-env)
;;; init-env.el ends here

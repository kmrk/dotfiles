;;; init-package.el --- 包管理器 -*- lexical-binding: t; -*-

;; package.el 会在 early-init.el 之后自动初始化（package-enable-at-startup），
;; 这里不需要再调用 `package-initialize'。

(require 'package)

(setq package-archives
      '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
        ("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

;; TODO: 关闭了签名校验；确认 gnu-elpa-keyring 可用后可以去掉这一行。
(setq package-check-signature nil)

;; use-package 从 Emacs 29 起内置。
(require 'use-package)
(setq use-package-always-ensure t)

(use-package diminish)

(provide 'init-package)
;;; init-package.el ends here

;;; init.el --- Emacs 入口：只负责装配模块 -*- lexical-binding: t; -*-

;; lisp/       配置模块（init-*.el），可以依赖彼此，按下面的顺序加载。
;; site-lisp/  独立的小包，不依赖这里的任何配置。
(dolist (dir '("lisp" "site-lisp"))
  (add-to-list 'load-path (expand-file-name dir user-emacs-directory)))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

;; 基础设施
(require 'init-package)     ; package.el + use-package
(require 'init-env)         ; PATH、编码、shell、终端、剪贴板、server、direnv
(require 'init-defaults)    ; 内置行为默认值：性能、编辑、历史、备份、自动刷新

;; 界面与交互
(require 'init-ui)          ; 主题、字体、tab-bar、mode-line
(require 'init-windows)     ; 窗口布局、侧边窗口规则、搜索结果跳转
(require 'init-completion)  ; vertico/consult/embark/company
(require 'init-navigation)  ; projectile、rg/ag、which-key、imenu-list
(require 'init-editing)     ; yasnippet、expand-region、中英文空格、rime
(require 'init-evil)        ; evil 及所有 evil 风格键位
(require 'init-paredit)     ; paredit + VI 风格结构化编辑
(require 'init-dired)       ; dired、wdired、ibuffer

;; 编程语言
(require 'init-lsp)         ; eglot/flymake 通用部分，提供 `my/eglot-register'
(require 'init-lang-python)
(require 'init-lang-web)
(require 'init-lang-rust)
(require 'init-lang-haskell)
(require 'init-lang-racket)
(require 'init-lang-clojure)
(require 'init-lang-dart)
(require 'init-lang-markdown)

;; 写作
(require 'init-org)

(load custom-file 'noerror 'nomessage)

;;; init.el ends here

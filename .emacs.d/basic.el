
(require 'package)

;; 添加 MELPA 到包源列表
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))

;; 初始化包管理器
(package-initialize)

;; 如果包列表没有被下载过，刷新一次
(unless package-archive-contents
  (package-refresh-contents))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq menu-bar-mode nil)


(use-package evil :ensure t :init (setq evil-want-integration t) (setq evil-want-keybinding nil) :config (evil-mode 1)) 

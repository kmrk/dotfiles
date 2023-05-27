(setq package-archives '(("gnu"   . "http://mirrors.cloud.tencent.com/elpa/gnu/")
                         ("melpa" . "http://mirrors.cloud.tencent.com/elpa/melpa/")))


(defun melpa_raw ()
  (setq url-gateway-method 'socks)
  (setq socks-server '("Default server" "172.28.176.1" 1080 5))
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  (add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t))

;(melpa_raw)




(package-initialize)


(setq byte-compile-warnings '(cl-functions))

; use use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(use-package diminish :ensure t)
(use-package bind-key :ensure t)


(use-package auto-package-update
	     :ensure t
	     :config
	     (setq auto-package-update-delete-old-versions t)
	     (setq auto-package-update-hide-results t)
	     (auto-package-update-maybe))

(if (eq 'windows-nt system-type) (desktop-save-mode 1))


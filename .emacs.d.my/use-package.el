;(setq package-archives '(("gnu"   . "http://mirrors.cloud.tencent.com/elpa/gnu/")
;                         ("melpa" . "http://mirrors.cloud.tencent.com/elpa/melpa/")))

(setq package-archives '(("gnu"   . "http://mirrors.cloud.tencent.com/elpa/gnu/")
                         ("melpa" . "http://mirrors.cloud.tencent.com/elpa/melpa/")))


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


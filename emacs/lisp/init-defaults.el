;;; init-defaults.el --- 内置行为的默认值：性能、编辑、历史、备份、自动刷新 -*- lexical-binding: t; -*-

;;; ============================================================================
;;; 性能
;;; ============================================================================

;; 不做双向文本扫描
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t)

;; 输入时跳过 fontification
(setq redisplay-skip-fontification-on-input t)

;; 加大进程输出缓冲区（LSP）
(setq read-process-output-max (* 4 1024 1024))

;; 非焦点窗口不渲染光标
(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)

;;; ============================================================================
;;; Kill ring / 历史
;;; ============================================================================

(setq save-interprogram-paste-before-kill t
      kill-do-not-save-duplicates t)

(use-package savehist
  :ensure nil
  :init
  (setq savehist-additional-variables
        '(search-ring regexp-search-ring kill-ring))
  (savehist-mode 1)
  :config
  ;; 保存前去掉 kill-ring 的文本属性
  (add-hook 'savehist-save-hook
            (lambda ()
              (setq kill-ring
                    (mapcar #'substring-no-properties
                            (cl-remove-if-not #'stringp kill-ring))))))

;;; ============================================================================
;;; 编辑
;;; ============================================================================

(electric-indent-mode -1)

;; 缩进：全局默认值 + 编程 buffer 里再强制一次（覆盖 major mode 的局部设置）。
(defconst my/indent-settings
  '((indent-tabs-mode . nil)
    (tab-width . 2)
    (standard-indent . 2)
    (js-indent-level . 2)
    (js-jsx-indent-level . 2)
    (typescript-indent-level . 2)
    (css-indent-offset . 2)
    (sh-basic-offset . 2)
    (sh-indentation . 2))
  "Indentation variables shared by every buffer.")

(dolist (setting my/indent-settings)
  (set-default (car setting) (cdr setting)))

(defun my/prog-mode-2-space-indent ()
  "Use 2-space indentation defaults in programming buffers."
  ;; Makefile 的 recipe 必须用 tab。
  (unless (derived-mode-p 'makefile-mode)
    (dolist (setting my/indent-settings)
      (set (make-local-variable (car setting)) (cdr setting)))))

(add-hook 'prog-mode-hook #'my/prog-mode-2-space-indent)

;; 保存脚本时自动加可执行权限
(add-hook 'after-save-hook #'executable-make-buffer-file-executable-if-script-p)

(setq reb-re-syntax 'string
      set-mark-command-repeat-pop t
      help-window-select t)

;; save-place 恢复位置后居中
(advice-add 'save-place-find-file-hook :after
            (lambda (&rest _)
              (when buffer-file-name (ignore-errors (recenter)))))

;;; ============================================================================
;;; 备份 / 自动保存
;;; ============================================================================

(defconst emacs-tmp-dir
  (format "%s%s%s/" temporary-file-directory "emacs" (user-uid)))
(setq backup-directory-alist `((".*" . ,emacs-tmp-dir))
      auto-save-file-name-transforms `((".*" ,emacs-tmp-dir t))
      auto-save-list-file-prefix emacs-tmp-dir)

;;; ============================================================================
;;; 自动刷新
;;; ============================================================================

(setq global-auto-revert-non-file-buffers t
      auto-revert-verbose nil)
(global-auto-revert-mode 1)

(declare-function dired-buffer-stale-p "dired")

(defun my/revert-all-buffers ()
  "Revert unmodified file and Dired buffers that changed on disk."
  (interactive)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (and (not (buffer-modified-p))
                 (cond (buffer-file-name
                        (not (verify-visited-file-modtime buf)))
                       ((derived-mode-p 'dired-mode)
                        (dired-buffer-stale-p t))))
        (revert-buffer t t t)))))

(defun my/revert-on-focus-in ()
  "Revert stale buffers when an Emacs frame gains focus."
  (when (eq (frame-focus-state) t)
    (my/revert-all-buffers)))

(add-function :after after-focus-change-function #'my/revert-on-focus-in)

;;; ============================================================================
;;; 常用命令
;;; ============================================================================

(defun my-close-emacs-client ()
  "Close the current Emacs client without killing the daemon."
  (interactive)
  (if (y-or-n-p "Do you want to close this Emacs client? ")
      (server-edit)
    (message "Cancelled closing client")))

(defun kkk ()
  "Kill every buffer except the current one."
  (interactive)
  (dolist (buf (buffer-list))
    (unless (eq buf (current-buffer))
      (kill-buffer buf))))

(provide 'init-defaults)
;;; init-defaults.el ends here

;;; init-completion.el --- 补全：minibuffer（vertico 系）与 buffer 内（company） -*- lexical-binding: t; -*-

(setq tab-always-indent 'complete
      completions-max-height 20
      completion-auto-select 'second-tab)

;;; ============================================================================
;;; Minibuffer 补全
;;; ============================================================================

(use-package vertico
  :init
  (vertico-mode 1)
  :custom
  (vertico-count 15)
  (vertico-cycle t))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides
        '((file (styles basic partial-completion)))))

(use-package prescient
  :custom
  (prescient-save-file (expand-file-name "prescient-save.el" user-emacs-directory))
  (prescient-history-length 200)
  (prescient-sort-length-enable nil)
  :config
  (prescient-persist-mode 1))

(use-package vertico-prescient
  :after (vertico prescient)
  :custom
  (vertico-prescient-enable-filtering nil)
  (vertico-prescient-enable-sorting t)
  :config
  (vertico-prescient-mode 1))

;;; ============================================================================
;;; Marginalia：M-x 候选显示 [来源 major:/minor: 标签] 与文档
;;; ============================================================================

;; 先加载 marginalia：下面的注解函数要用到它的宏 `marginalia--fields'。
(use-package marginalia
  :init
  (marginalia-mode 1)
  :config
  (setf (cadr (assq 'command marginalia-annotators))
        #'my/marginalia-annotate-command))

(defun my/command-mode-tags (command)
  "Return mode tags relevant to COMMAND."
  (let ((major (and (boundp 'major-mode)
                    (string-remove-suffix "-mode" (symbol-name major-mode))))
        (minor (delq nil
                     (mapcar (lambda (mode)
                               (when (and (boundp mode) (symbol-value mode))
                                 (string-remove-suffix "-mode" (symbol-name mode))))
                             minor-mode-list)))
        (tags nil))
    (when (and major (string-prefix-p major command))
      (push (format "major:%s" major) tags))
    (dolist (mode minor)
      (when (and mode (string-prefix-p mode command))
        (push (format "minor:%s" mode) tags)))
    (nreverse (delete-dups tags))))

(defun my/command-source-tag (sym)
  "Return a source tag for command SYM."
  (let ((file (symbol-file sym 'defun)))
    (cond
     ((or (null file)
          (string-match-p "/share/emacs/.*/lisp/" file)
          (string-match-p "/libexec/emacs/" file))
      "built-in")
     ((string-match "\\(/elpa/\\|/straight/build/\\)\\([^/]+\\)" file)
      (replace-regexp-in-string "-[0-9].*\\'" "" (match-string 2 file)))
     ((string-match-p "/site-lisp/" file)
      "site-lisp")
     (t
      (file-name-base file)))))

(defun my/marginalia-annotate-command (cand)
  "Annotate command CAND with keybinding, source, mode tags and docs."
  (when-let* ((sym (intern-soft cand)))
    (let* ((source (my/command-source-tag sym))
           (modes (my/command-mode-tags cand))
           (tags (string-join (cons source modes) " "))
           (doc (marginalia--function-doc sym)))
      (marginalia--fields
       (:left (marginalia-annotate-binding cand))
       ((and tags (format "[%s]" tags))
        :face 'marginalia-type :truncate 0.35)
       (doc
        :truncate 1.0 :face 'marginalia-documentation)))))

;;; ============================================================================
;;; Consult / Embark
;;; ============================================================================

(use-package consult
  :custom
  (consult-find-command "fdfind --color=never --full-path ARG OPTS")
  :bind (("M-x" . execute-extended-command)
         ("C-;" . execute-extended-command)
         ("M-;" . execute-extended-command)
         ("C-c ;" . execute-extended-command)
         ("C-x C-f" . find-file)
         ("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("C-c h" . consult-history)
         ("C-c k" . consult-ripgrep)
         ("C-c m" . consult-imenu)))

(use-package embark
  :bind (("C-." . embark-act)
         ;; C-h 已被 windmove 占用，帮助前缀用 <f1>
         ("<f1> B" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :after (embark consult))

;;; ============================================================================
;;; Buffer 内补全
;;; ============================================================================

(use-package company
  :config
  (setq company-minimum-prefix-length 1
        company-dabbrev-downcase 0
        company-idle-delay 0.1)
  (add-to-list 'company-backends 'company-capf)
  (global-company-mode 1))

(provide 'init-completion)
;;; init-completion.el ends here

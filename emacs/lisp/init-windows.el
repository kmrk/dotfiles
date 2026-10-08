;;; init-windows.el --- 窗口：分割、特殊 buffer 位置、搜索结果跳转、窗口切换 -*- lexical-binding: t; -*-

;;; ============================================================================
;;; 分割与特殊 buffer 的显示位置
;;; ============================================================================

(setq split-width-threshold 0
      split-height-threshold nil
      window-combination-resize t
      even-window-sizes nil)

;; 源码 buffer 留在主编辑区，侧边窗口只放临时的结果/帮助 buffer。
;; 语言相关的规则（REPL 等）由各自的 init-lang-*.el 用 `my/display-in-side' 注册。
(setq display-buffer-base-action
      '((display-buffer-reuse-window display-buffer-use-some-window)))

(defun my/display-in-side (regexp side slot size)
  "Show buffers matching REGEXP in a side window at SIDE and SLOT.
SIZE is the window width for left/right sides and height otherwise."
  (add-to-list
   'display-buffer-alist
   `(,regexp
     (display-buffer-reuse-window display-buffer-in-side-window)
     (side . ,side)
     (slot . ,slot)
     (,(if (memq side '(left right)) 'window-width 'window-height) . ,size))))

(my/display-in-side "\\*Help\\*"        'right  0 0.3)
(my/display-in-side "\\*xref\\*"        'bottom 0 0.25)
(my/display-in-side "\\*grep\\*"        'bottom 1 0.25)
(my/display-in-side "\\*compilation\\*" 'bottom 2 0.25)

;;; ============================================================================
;;; 搜索结果总是在主编辑窗口打开
;;; ============================================================================

(defun my/search-target-window ()
  "Return the main editing window used for search result jumps."
  (or (car
       (sort
        (seq-filter
         (lambda (window)
           (and (not (window-minibuffer-p window))
                (not (window-dedicated-p window))
                (null (window-parameter window 'window-side))
                (not (eq window (selected-window)))))
         (window-list nil 'no-minibuf))
        (lambda (a b)
          (> (* (window-total-width a) (window-total-height a))
             (* (window-total-width b) (window-total-height b))))))
      (selected-window)))

(defun my/visit-search-result-in-window (visit-fn)
  "Run VISIT-FN while forcing the target to reuse the main editing window."
  (let ((target-window (my/search-target-window))
        (result-buffer (current-buffer))
        (result-point (point)))
    (if (window-live-p target-window)
        (with-selected-window target-window
          (with-current-buffer result-buffer
            (goto-char result-point)
            (funcall visit-fn)))
      (funcall visit-fn))))

(defun my/compile-goto-error-same-window ()
  "Visit the current compilation-style result in the main editing window."
  (interactive)
  (my/visit-search-result-in-window #'compile-goto-error))

(defun my/xref-goto-same-window ()
  "Visit the current xref in the main editing window."
  (interactive)
  (my/visit-search-result-in-window #'xref-goto-xref))

(defun my/occur-goto-same-window ()
  "Visit the current occur result in the main editing window."
  (interactive)
  (my/visit-search-result-in-window #'occur-mode-goto-occurrence))

(with-eval-after-load 'compile
  (define-key compilation-mode-map (kbd "RET") #'my/compile-goto-error-same-window))

(with-eval-after-load 'xref
  (define-key xref--xref-buffer-mode-map (kbd "RET") #'my/xref-goto-same-window)
  (define-key xref--transient-buffer-mode-map (kbd "RET") #'my/xref-goto-same-window))

(with-eval-after-load 'replace
  (define-key occur-mode-map (kbd "RET") #'my/occur-goto-same-window))

;;; ============================================================================
;;; 窗口切换
;;; ============================================================================

(use-package windmove
  :ensure nil
  :config
  (windmove-default-keybindings)
  (global-set-key (kbd "C-h") #'windmove-left)
  (global-set-key (kbd "C-j") #'windmove-down)
  (global-set-key (kbd "C-k") #'windmove-up)
  (global-set-key (kbd "C-l") #'windmove-right))

;;; ============================================================================
;;; Side Tabs（site-lisp/sidetabs.el）
;;; ============================================================================

(autoload 'sidetabs-mode "sidetabs" nil t)
(autoload 'sidetabs-focus "sidetabs" nil t)

(provide 'init-windows)
;;; init-windows.el ends here

;;; init-lang-markdown.el --- Markdown / Pandoc -*- lexical-binding: t; -*-

(defun my-markdown-preview-output-file (input-file)
  "Return the HTML preview path for INPUT-FILE."
  (expand-file-name
   (format "emacs-markdown-preview-%s.html" (md5 (expand-file-name input-file)))
   temporary-file-directory))

(defun my-markdown-preview ()
  "Render the current Markdown buffer with pandoc and open it in a browser."
  (interactive)
  (unless (buffer-file-name)
    (user-error "Current buffer is not visiting a file"))
  (unless (executable-find "pandoc")
    (user-error "pandoc not found in PATH"))
  (when (buffer-modified-p)
    (save-buffer))
  (let* ((input-file (buffer-file-name))
         (output-file (my-markdown-preview-output-file input-file))
         (exit-code (call-process "pandoc" nil "*pandoc-preview*" t
                                  input-file
                                  "--standalone"
                                  "--from=gfm"
                                  "--to=html5"
                                  "--metadata" "title=Markdown Preview"
                                  "--output" output-file)))
    (unless (eq exit-code 0)
      (error "Pandoc preview failed; see *pandoc-preview*"))
    (if (display-graphic-p)
        (browse-url-of-file output-file)
      (eww-open-file output-file))
    (message "Markdown preview: %s" output-file)))

(defun my-markdown-mode-setup ()
  "Local setup shared by Markdown buffers."
  (visual-line-mode 1)
  ;; atom-one-dark 等主题下 markdown 正文会用偏暗的 comment 类 face，局部调亮。
  (face-remap-add-relative 'default '(:foreground "#ffffff"))
  (face-remap-add-relative 'font-lock-comment-face '(:foreground "#ffffff"))
  (face-remap-add-relative 'font-lock-comment-delimiter-face '(:foreground "#d0d7e2"))
  (face-remap-add-relative 'markdown-markup-face '(:foreground "#d0d7e2")))

(use-package markdown-mode
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init
  (setq markdown-command "pandoc")
  :hook ((markdown-mode . my-markdown-mode-setup)
         (gfm-mode . my-markdown-mode-setup))
  :bind (:map markdown-mode-map
              ("C-c C-p" . my-markdown-preview))
  :config
  (setq markdown-fontify-code-blocks-natively t
        markdown-enable-math t
        markdown-asymmetric-header t))

(use-package pandoc-mode
  :hook ((markdown-mode . pandoc-mode)
         (gfm-mode . pandoc-mode))
  :config
  (setq pandoc-data-dir (expand-file-name "pandoc/" user-emacs-directory)))

(provide 'init-lang-markdown)
;;; init-lang-markdown.el ends here

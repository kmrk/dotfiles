(defun highlight-indent-guides-custom-highlight (level responsive display)
  (if (> 1 level)
      nil
    (highlight-indent-guides--highlighter-default level responsive display)))


(use-package highlight-indent-guides
  :ensure t
  :diminish highlight-indent-guides-mode
  :config
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
  (set-face-foreground 'highlight-indent-guides-character-face "gray30")
  (set-face-foreground 'highlight-indent-guides-stack-character-face "#21618C")
  (set-face-foreground 'highlight-indent-guides-top-character-face "#3498DB")
  (setq highlight-indent-guides-bitmap-function 'highlight-indent-guides--bitmap-line)
  (setq highlight-indent-guides-auto-enabled nil)
  (setq highlight-indent-guides-method 'bitmap)
  (setq highlight-indent-guides-responsive 'stack)
  (setq highlight-indent-guides-highlighter-function 'highlight-indent-guides-custom-highlight))

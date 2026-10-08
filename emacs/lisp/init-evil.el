;;; init-evil.el --- Evil 及所有 evil 风格键位 -*- lexical-binding: t; -*-

;; 别的模块不直接碰 evil 的 keymap；各模式的 evil 键位都集中在这里，
;; 用 `with-eval-after-load' 等对应模式加载后再绑定。

(defun my/evil-keyboard-quit ()
  "Keyboard quit and force normal state."
  (interactive)
  (and evil-mode (evil-force-normal-state))
  (keyboard-quit))

(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil)
  :config
  (evil-mode 1)
  ;; visual 选区不要覆盖系统选区（必须在 evil 加载后覆盖）
  (fset 'evil-visual-update-x-selection #'ignore)

  ;; :q / :wq / :x 只关 buffer，不关窗口
  (evil-ex-define-cmd "q" (lambda () (interactive) (kill-current-buffer)))
  (evil-ex-define-cmd "quit" #'evil-quit)
  (evil-ex-define-cmd "wq" (lambda () (interactive) (save-buffer) (kill-current-buffer)))
  (evil-ex-define-cmd "x" (lambda () (interactive) (save-buffer) (kill-current-buffer)))

  (define-key evil-motion-state-map (kbd "C-z") #'suspend-frame)
  (define-key evil-normal-state-map (kbd "C-h") #'evil-window-left)
  (define-key evil-normal-state-map (kbd "C-j") #'evil-window-down)
  (define-key evil-normal-state-map (kbd "C-k") #'evil-window-up)
  (define-key evil-normal-state-map (kbd "C-l") #'evil-window-right)
  (define-key evil-normal-state-map (kbd "gt") #'next-buffer)
  (define-key evil-normal-state-map (kbd "gT") #'previous-buffer)
  (define-key evil-normal-state-map (kbd "]e") #'flymake-goto-next-error)
  (define-key evil-normal-state-map (kbd "[e") #'flymake-goto-prev-error)
  (dolist (map (list evil-normal-state-map evil-motion-state-map
                     evil-insert-state-map evil-window-map
                     evil-operator-state-map))
    (define-key map (kbd "C-g") #'my/evil-keyboard-quit))

  ;; Dired
  (with-eval-after-load 'dired
    (evil-define-key 'normal dired-mode-map
      (kbd "h") #'dired-up-directory
      (kbd "l") #'dired-find-file
      (kbd "a") #'dired-create-empty-file
      (kbd "A") #'dired-create-directory
      (kbd "D") #'dired-do-delete
      (kbd "r") #'dired-do-rename
      (kbd "R") #'revert-buffer
      (kbd "m") #'dired-mark
      (kbd ".") #'dired-omit-mode))

  ;; Ibuffer
  (evil-set-initial-state 'ibuffer-mode 'normal)
  (add-hook 'ibuffer-mode-hook #'evil-normal-state)
  (with-eval-after-load 'ibuffer
    (evil-define-key 'normal ibuffer-mode-map
      (kbd "j") #'ibuffer-forward-line
      (kbd "k") #'ibuffer-backward-line
      (kbd "RET") #'ibuffer-visit-buffer
      (kbd "<return>") #'ibuffer-visit-buffer
      (kbd "/") #'consult-line
      (kbd "gr") #'ibuffer-update
      (kbd "q") #'quit-window)))

(use-package evil-terminal-cursor-changer
  :after evil
  :config
  (setq evil-motion-state-cursor 'box
        evil-visual-state-cursor 'box
        evil-normal-state-cursor 'box
        evil-insert-state-cursor 'bar
        evil-replace-state-cursor 'hbar)
  (evil-terminal-cursor-changer-activate))

(provide 'init-evil)
;;; init-evil.el ends here

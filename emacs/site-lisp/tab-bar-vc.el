;;; tab-bar-vc.el --- Show buffer save/VC state in tab names -*- lexical-binding: t; -*-

;;; Commentary:

;; Tab names show the selected window's buffer name, a `*' when it is
;; modified and Git porcelain status markers such as [M] or [?].
;;
;; The Git status is computed once per buffer (on visit, save, revert and
;; frame focus) and cached, so redrawing the tab bar never spawns processes.

;;; Code:

(require 'subr-x)
(require 'tab-bar)
(require 'vc-hooks)

(defgroup tab-bar-vc nil
  "Show buffer save/VC state in tab names."
  :group 'tab-bar)

(defface tab-bar-vc-modified-face
  '((t (:inherit tab-bar-tab :foreground "#ff9e64" :weight bold)))
  "Face for modified VC state markers.")

(defface tab-bar-vc-unsaved-face
  '((t (:inherit tab-bar-tab :foreground "#7dcfff" :weight bold)))
  "Face for unsaved buffer markers.")

(defface tab-bar-vc-added-face
  '((t (:inherit tab-bar-tab :foreground "#9ece6a" :weight bold)))
  "Face for added VC state markers.")

(defface tab-bar-vc-untracked-face
  '((t (:inherit tab-bar-tab :foreground "#c0a36e" :weight bold)))
  "Face for untracked VC state markers.")

(defface tab-bar-vc-conflict-face
  '((t (:inherit tab-bar-tab :foreground "#f7768e" :weight bold)))
  "Face for conflicting VC state markers.")

(defface tab-bar-vc-generic-face
  '((t (:inherit tab-bar-tab :foreground "#7aa2f7" :weight bold)))
  "Face for generic VC state markers.")

(defvar-local tab-bar-vc--label nil
  "Cached propertized VC label for the current buffer.")

(defvar tab-bar-vc--previous-name-function nil
  "Value of `tab-bar-tab-name-function' before `tab-bar-vc-mode'.")

(defun tab-bar-vc--git-root (file)
  "Return the Git root for FILE, or nil when unavailable."
  (ignore-errors
    (locate-dominating-file (file-name-directory file) ".git")))

(defun tab-bar-vc--porcelain-status (file root)
  "Return Git porcelain XY status for FILE under ROOT, or nil."
  (let ((default-directory root))
    (with-temp-buffer
      (when (eq 0 (process-file "git" nil t nil
                                "status" "--porcelain" "--ignored=no" "--"
                                (file-relative-name file root)))
        (string-trim-right (buffer-string))))))

(defun tab-bar-vc--token (code)
  "Return a propertized token for a porcelain status CODE."
  (pcase code
    (?M (propertize "[M]" 'face 'tab-bar-vc-modified-face))
    (?A (propertize "[A]" 'face 'tab-bar-vc-added-face))
    (?? (propertize "[?]" 'face 'tab-bar-vc-untracked-face))
    (?U (propertize "[U]" 'face 'tab-bar-vc-conflict-face))
    ((or ?D ?R ?C ?!)
     (propertize (format "[%c]" code) 'face 'tab-bar-vc-generic-face))
    (_ nil)))

(defun tab-bar-vc--vc-state-label (file)
  "Return a label for FILE derived from `vc-state', or nil."
  (pcase (ignore-errors (vc-state file))
    ('edited (propertize "[M]" 'face 'tab-bar-vc-modified-face))
    ('added (propertize "[A]" 'face 'tab-bar-vc-added-face))
    ('removed (propertize "[D]" 'face 'tab-bar-vc-generic-face))
    ('missing (propertize "[!]" 'face 'tab-bar-vc-generic-face))
    ('conflict (propertize "[U]" 'face 'tab-bar-vc-conflict-face))
    ('needs-update (propertize "[O]" 'face 'tab-bar-vc-generic-face))
    ('ignored (propertize "[I]" 'face 'tab-bar-vc-generic-face))
    ('unregistered (propertize "[?]" 'face 'tab-bar-vc-untracked-face))
    (_ nil)))

(defun tab-bar-vc--compute-label (file)
  "Return propertized Git status markers for FILE, or nil."
  ;; 解析符号链接（如 ~/.emacs.d -> ~/.config/emacs），否则找不到外层的 .git。
  (let* ((file (file-truename file))
         (root (tab-bar-vc--git-root file))
         (status (and root (tab-bar-vc--porcelain-status file root))))
    (if (and status (>= (length status) 2))
        (let ((tokens (delq nil (list (tab-bar-vc--token (aref status 0))
                                      (tab-bar-vc--token (aref status 1))))))
          (and tokens (string-join tokens "")))
      (tab-bar-vc--vc-state-label file))))

(defun tab-bar-vc-refresh ()
  "Recompute the cached VC label of the current buffer and redraw."
  (interactive)
  (when (and buffer-file-name (not (file-remote-p buffer-file-name)))
    (ignore-errors (vc-refresh-state))
    (setq tab-bar-vc--label (tab-bar-vc--compute-label buffer-file-name))
    (force-mode-line-update t)))

(defun tab-bar-vc--refresh-visible ()
  "Refresh labels of buffers visible in the selected frame."
  (dolist (buf (delete-dups (mapcar #'window-buffer (window-list nil 'no-mini))))
    (with-current-buffer buf
      (tab-bar-vc-refresh))))

(defun tab-bar-vc--on-focus-change ()
  "Refresh visible buffers when a frame gains focus."
  (when (eq (frame-focus-state) t)
    (tab-bar-vc--refresh-visible)))

(defun tab-bar-vc-tab-name ()
  "Use the selected window's buffer name with save and VC status."
  (with-current-buffer (window-buffer (frame-selected-window))
    (concat (buffer-name)
            (if (buffer-modified-p)
                (concat " " (propertize "*" 'face 'tab-bar-vc-unsaved-face))
              "")
            (if tab-bar-vc--label (concat " " tab-bar-vc--label) ""))))

(defconst tab-bar-vc--hooks
  '(find-file-hook after-save-hook after-revert-hook)
  "Hooks that trigger a refresh of the current buffer's label.")

;;;###autoload
(define-minor-mode tab-bar-vc-mode
  "Show the selected buffer's save and VC state in tab names."
  :global t
  (if tab-bar-vc-mode
      (progn
        (setq tab-bar-vc--previous-name-function tab-bar-tab-name-function
              tab-bar-tab-name-function #'tab-bar-vc-tab-name)
        (dolist (hook tab-bar-vc--hooks)
          (add-hook hook #'tab-bar-vc-refresh))
        (add-function :after after-focus-change-function
                      #'tab-bar-vc--on-focus-change))
    (setq tab-bar-tab-name-function
          (or tab-bar-vc--previous-name-function #'tab-bar-tab-name-current))
    (dolist (hook tab-bar-vc--hooks)
      (remove-hook hook #'tab-bar-vc-refresh))
    (remove-function after-focus-change-function
                     #'tab-bar-vc--on-focus-change)))

(provide 'tab-bar-vc)
;;; tab-bar-vc.el ends here

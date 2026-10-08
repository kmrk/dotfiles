;;; sidetabs.el --- Browser-like buffer tabs in a normal window -*- lexical-binding: t; -*-

;;; Commentary:

;; A small fixed-width buffer list in a normal left window.

;;; Code:

(require 'seq)
(require 'windmove nil t)

(declare-function evil-window-left "evil-commands" ())
(declare-function evil-window-down "evil-commands" ())
(declare-function evil-window-up "evil-commands" ())
(declare-function evil-window-right "evil-commands" ())

(defgroup sidetabs nil
  "Browser-like buffer tabs in a normal window."
  :group 'convenience)

(defcustom sidetabs-width 28
  "Fallback width of the sidetabs window."
  :type 'integer
  :group 'sidetabs)

(defcustom sidetabs-min-width 18
  "Minimum width of the sidetabs window."
  :type 'integer
  :group 'sidetabs)

(defcustom sidetabs-max-width 44
  "Maximum width of the sidetabs window."
  :type 'integer
  :group 'sidetabs)

(defcustom sidetabs-padding 4
  "Extra columns around the longest tab title."
  :type 'integer
  :group 'sidetabs)

(defcustom sidetabs-buffer-name "*sidetabs*"
  "Name of the sidetabs buffer."
  :type 'string
  :group 'sidetabs)

(defcustom sidetabs-include-special-buffers nil
  "When non-nil, include star-named special buffers."
  :type 'boolean
  :group 'sidetabs)

(defvar sidetabs-mode)
(defvar sidetabs--return-window nil
  "Window to return to after selecting a tab.")

(defvar sidetabs--last-buffer-list nil
  "Last rendered list of buffers.")

(defvar sidetabs--buffers-order nil
  "Stable sidetabs buffer order.")

(defvar sidetabs--refreshing nil
  "Non-nil while sidetabs is refreshing.")

(defvar sidetabs--refresh-timer nil
  "Idle timer used to coalesce sidetabs refreshes.")

;; Clean up hooks from earlier experimental versions when this file is reloaded.
(remove-hook 'window-configuration-change-hook #'sidetabs-refresh)
(remove-hook 'buffer-list-update-hook #'sidetabs-refresh)
(remove-hook 'after-save-hook #'sidetabs-refresh)
(remove-hook 'kill-buffer-hook #'sidetabs-refresh)

(defface sidetabs-current
  '((t (:inherit highlight :weight bold)))
  "Face for the current buffer tab.")

(defface sidetabs-buffer
  '((t (:inherit default)))
  "Face for inactive buffer tabs.")

(defface sidetabs-directory-slash
  '((t (:inherit font-lock-constant-face :weight bold)))
  "Face for directory slash markers in sidetabs.")

(defvar sidetabs-list-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "RET") #'sidetabs-open-at-point)
    (define-key map (kbd "<return>") #'sidetabs-open-at-point)
    (define-key map (kbd "C-m") #'sidetabs-open-at-point)
    (define-key map (kbd "q") #'sidetabs-quit)
    (define-key map (kbd "g") #'sidetabs-refresh)
    (define-key map (kbd "j") #'next-line)
    (define-key map (kbd "k") #'previous-line)
    (define-key map (kbd "C-h") #'sidetabs-window-left)
    (define-key map (kbd "C-j") #'sidetabs-window-down)
    (define-key map (kbd "C-k") #'sidetabs-window-up)
    (define-key map (kbd "C-l") #'sidetabs-window-right)
    map)
  "Keymap for `sidetabs-list-mode'.")

(define-derived-mode sidetabs-list-mode fundamental-mode "SideTabs"
  "Major mode for the sidetabs buffer."
  (setq-local truncate-lines t
              cursor-type nil
              display-line-numbers nil
              buffer-read-only nil)
  (when (fboundp 'evil-local-set-key)
    (evil-local-set-key 'normal (kbd "RET") #'sidetabs-open-at-point)
    (evil-local-set-key 'normal (kbd "<return>") #'sidetabs-open-at-point)
    (evil-local-set-key 'normal (kbd "C-m") #'sidetabs-open-at-point)
    (evil-local-set-key 'normal (kbd "j") #'next-line)
    (evil-local-set-key 'normal (kbd "k") #'previous-line)
    (evil-local-set-key 'normal (kbd "q") #'sidetabs-quit)
    (evil-local-set-key 'normal (kbd "g") #'sidetabs-refresh)
    (evil-local-set-key 'normal (kbd "C-h") #'sidetabs-window-left)
    (evil-local-set-key 'normal (kbd "C-j") #'sidetabs-window-down)
    (evil-local-set-key 'normal (kbd "C-k") #'sidetabs-window-up)
    (evil-local-set-key 'normal (kbd "C-l") #'sidetabs-window-right))
  (display-line-numbers-mode -1))

(defun sidetabs--buffer ()
  "Return the sidetabs buffer."
  (let ((buffer (get-buffer-create sidetabs-buffer-name)))
    (with-current-buffer buffer
      (unless (derived-mode-p 'sidetabs-list-mode)
        (sidetabs-list-mode)))
    buffer))

(defun sidetabs--window ()
  "Return the sidetabs window, or nil."
  (get-buffer-window (sidetabs--buffer) t))

(defun sidetabs--main-window ()
  "Return the window sidetabs should operate on."
  (or (and (window-live-p sidetabs--return-window)
           (not (eq sidetabs--return-window (sidetabs--window)))
           (not (window-dedicated-p sidetabs--return-window))
           sidetabs--return-window)
      (seq-find (lambda (window)
                  (and (not (window-minibuffer-p window))
                       (not (eq window (sidetabs--window)))
                       (not (window-dedicated-p window))))
                (window-list nil 'no-minibuf))
      (let ((main (window-main-window)))
        (and (window-live-p main)
             (not (eq main (sidetabs--window)))
             (not (window-dedicated-p main))
             main))))

(defun sidetabs--buffer-visible-p (buffer)
  "Return non-nil when BUFFER should be shown."
  (let ((name (buffer-name buffer)))
    (and name
         (not (minibufferp buffer))
         (not (eq buffer (sidetabs--buffer)))
         (not (string-prefix-p " " name))
         (or sidetabs-include-special-buffers
             (not (string-prefix-p "*" name))
             (member name '("*scratch*" "*Messages*" "*shell*" "*eshell*"))))))

(defun sidetabs--buffers ()
  "Return buffers shown by sidetabs in stable tab order."
  (let ((visible (seq-filter #'sidetabs--buffer-visible-p (buffer-list))))
    (setq sidetabs--buffers-order
          (seq-filter (lambda (buffer)
                        (and (buffer-live-p buffer)
                             (memq buffer visible)))
                      sidetabs--buffers-order))
    (dolist (buffer visible)
      (unless (memq buffer sidetabs--buffers-order)
        (setq sidetabs--buffers-order
              (append sidetabs--buffers-order (list buffer)))))
    (or sidetabs--buffers-order
        (list (window-buffer (sidetabs--main-window))))))

(defun sidetabs--target-width (buffers)
  "Return target sidetabs width for BUFFERS."
  (let* ((longest (if buffers
                      (apply #'max (mapcar (lambda (buffer)
                                             (+ (string-width (buffer-name buffer))
                                                (if (sidetabs--directory-buffer-p buffer)
                                                    1
                                                  0)))
                                           buffers))
                    sidetabs-width))
         (wanted (+ longest sidetabs-padding)))
    (max sidetabs-min-width
         (min sidetabs-max-width wanted))))

(defun sidetabs--resize-window (window buffers)
  "Resize WINDOW to fit BUFFERS."
  (let* ((target (sidetabs--target-width buffers))
         (delta (- target (window-total-width window))))
    (unless (zerop delta)
      (ignore-errors
        (window-resize window delta t))))
  (let* ((target (sidetabs--target-width buffers))
         (body (window-body-width window t))
         (delta (- target body)))
    (when (> delta 0)
      (ignore-errors
        (window-resize window delta t)))))

(defun sidetabs--directory-buffer-p (buffer)
  "Return non-nil when BUFFER represents a directory."
  (with-current-buffer buffer
    (or (and buffer-file-name
             (file-directory-p buffer-file-name))
        (and (derived-mode-p 'dired-mode)
             default-directory
             (file-directory-p default-directory)))))

(defun sidetabs--display-name (buffer width selected)
  "Return propertized display name for BUFFER in WIDTH columns.
SELECTED means BUFFER is the active tab."
  (let* ((safe-width (max 1 (1- width)))
         (name (buffer-name buffer))
         (directory (sidetabs--directory-buffer-p buffer))
         (marker "  ")
         (suffix (if directory "/" ""))
         (prefix marker)
         (available (max 1 (- safe-width (string-width prefix))))
         (title-width (max 1 (- available (string-width suffix))))
         (title (truncate-string-to-width name title-width 0 ?\s "…"))
         (padding (make-string (max 0 (- safe-width
                                         (string-width prefix)
                                         (string-width title)
                                         (string-width suffix)))
                               ?\s))
         (base-face (if selected 'sidetabs-current 'sidetabs-buffer)))
    (concat
     (propertize prefix 'face base-face)
     (propertize title 'face base-face)
     (when directory
       (propertize suffix 'face 'sidetabs-directory-slash))
     (propertize padding 'face base-face))))

(defun sidetabs--line-keymap ()
  "Return a keymap for mouse interaction on a sidetabs line."
  (let ((map (make-sparse-keymap)))
    (define-key map [mouse-1] #'sidetabs-click-tab)
    map))

(defun sidetabs--prepare-window (window)
  "Prepare WINDOW for sidetabs display."
  (with-current-buffer (window-buffer window)
    (setq-local display-line-numbers nil
                truncate-lines t)
    (when (bound-and-true-p display-line-numbers-mode)
      (display-line-numbers-mode -1))))

(defun sidetabs-refresh (&optional _arg)
  "Refresh sidetabs contents."
  (interactive)
  (when (and sidetabs-mode (not sidetabs--refreshing))
    (let ((sidetabs--refreshing t))
      (let* ((window (sidetabs--window))
             (current (window-buffer (sidetabs--main-window)))
             (buffers (sidetabs--buffers))
             (_ (when window
                  (sidetabs--resize-window window buffers)))
             (width (max 1 (if window
                                (window-body-width window t)
                              sidetabs-width)))
             (line-map (sidetabs--line-keymap)))
        (setq sidetabs--last-buffer-list buffers)
        (with-current-buffer (sidetabs--buffer)
          (let ((inhibit-read-only t)
                (point-buffer (get-text-property (point) 'sidetabs-buffer)))
            (erase-buffer)
            (dolist (buffer buffers)
              (let* ((selected (eq buffer current))
                     (text (sidetabs--display-name buffer width selected))
                     (face (if selected 'sidetabs-current 'sidetabs-buffer)))
                (insert (propertize text
                                    'face face
                                    'mouse-face 'highlight
                                    'help-echo "mouse-1: switch buffer"
                                    'local-map line-map
                                    'sidetabs-buffer buffer)
                        "\n")))
            (goto-char (point-min))
            (when point-buffer
              (let ((pos (text-property-any (point-min) (point-max)
                                            'sidetabs-buffer point-buffer)))
                (when pos
                  (goto-char pos))))))))))

(defun sidetabs-schedule-refresh (&optional _arg)
  "Schedule a sidetabs refresh soon."
  (when sidetabs-mode
    (when (timerp sidetabs--refresh-timer)
      (cancel-timer sidetabs--refresh-timer))
    (setq sidetabs--refresh-timer
          (run-with-idle-timer 0.05 nil
                               (lambda ()
                                 (setq sidetabs--refresh-timer nil)
                                 (sidetabs-refresh))))))

(defun sidetabs--display-window ()
  "Display and return the sidetabs window as a normal left split."
  (let* ((buffer (sidetabs--buffer))
         (current (selected-window))
         (window (or (sidetabs--window)
                     (let ((new-window (split-window current nil 'left)))
                       (window-resize new-window
                                      (- sidetabs-width
                                         (window-total-width new-window))
                                      t)
                       new-window))))
    (set-window-buffer window buffer)
    (set-window-dedicated-p window nil)
    (set-window-parameter window 'window-fixed-size nil)
    (sidetabs--prepare-window window)
    window))

(defun sidetabs-focus ()
  "Focus the sidetabs window, enabling `sidetabs-mode' if needed."
  (interactive)
  (unless sidetabs-mode
    (sidetabs-mode 1))
  (let ((window (sidetabs--window)))
    (unless window
      (setq window (sidetabs--display-window)))
    (unless (eq (selected-window) window)
      (setq sidetabs--return-window (selected-window)))
    (sidetabs--prepare-window window)
    (select-window window)
    (sidetabs-refresh)))

(defalias 'sidetabs-select-window #'sidetabs-focus)

(defun sidetabs--buffer-at-point ()
  "Return the sidetabs buffer at point."
  (or (get-text-property (point) 'sidetabs-buffer)
      (get-text-property (line-beginning-position) 'sidetabs-buffer)
      (let ((pos (line-beginning-position))
            (end (line-end-position))
            buffer)
        (while (and (< pos end) (not buffer))
          (setq buffer (get-text-property pos 'sidetabs-buffer)
                pos (1+ pos)))
        buffer)))

(defun sidetabs--visit-buffer (buffer)
  "Visit BUFFER in the main editing window."
  (unless (buffer-live-p buffer)
    (user-error "Buffer is no longer live"))
  (let ((window (sidetabs--main-window)))
    (unless (window-live-p window)
      (user-error "No editable window available"))
    (setq sidetabs--return-window window)
    (select-window window)
    (switch-to-buffer buffer)
    (sidetabs-schedule-refresh)))

(defun sidetabs-click-tab (event)
  "Visit the tab clicked by EVENT."
  (interactive "e")
  (let* ((pos (posn-point (event-start event)))
         (buffer (and pos (get-text-property pos 'sidetabs-buffer))))
    (when buffer
      (sidetabs--visit-buffer buffer))))

(defun sidetabs-open-at-point ()
  "Open the buffer listed on the current sidetabs line."
  (interactive)
  (when-let ((buffer (sidetabs--buffer-at-point)))
    (sidetabs--visit-buffer buffer)))

(defun sidetabs-quit ()
  "Return focus to the main editing window."
  (interactive)
  (when-let ((window (sidetabs--main-window)))
    (select-window window)))

(defun sidetabs--call-window-command (evil-command windmove-command)
  "Call EVIL-COMMAND when available, otherwise WINDMOVE-COMMAND."
  (cond
   ((and (bound-and-true-p evil-mode)
         (fboundp evil-command))
    (call-interactively evil-command))
   ((fboundp windmove-command)
    (call-interactively windmove-command))
   (t
    (user-error "Window movement command is unavailable"))))

(defun sidetabs-window-left ()
  "Move to the window on the left using the user's normal movement command."
  (interactive)
  (sidetabs--call-window-command #'evil-window-left #'windmove-left))

(defun sidetabs-window-down ()
  "Move to the window below using the user's normal movement command."
  (interactive)
  (sidetabs--call-window-command #'evil-window-down #'windmove-down))

(defun sidetabs-window-up ()
  "Move to the window above using the user's normal movement command."
  (interactive)
  (sidetabs--call-window-command #'evil-window-up #'windmove-up))

(defun sidetabs-window-right ()
  "Move to the window on the right using the user's normal movement command."
  (interactive)
  (sidetabs--call-window-command #'evil-window-right #'windmove-right))

;;;###autoload
(define-minor-mode sidetabs-mode
  "Display browser-like buffer tabs in a fixed left window."
  :global t
  (if sidetabs-mode
      (progn
        (setq sidetabs--return-window (selected-window))
        (sidetabs--display-window)
        (add-hook 'buffer-list-update-hook #'sidetabs-schedule-refresh)
        (add-hook 'after-save-hook #'sidetabs-schedule-refresh)
        (add-hook 'kill-buffer-hook #'sidetabs-schedule-refresh)
        (sidetabs-refresh))
    (remove-hook 'buffer-list-update-hook #'sidetabs-schedule-refresh)
    (remove-hook 'after-save-hook #'sidetabs-schedule-refresh)
    (remove-hook 'kill-buffer-hook #'sidetabs-schedule-refresh)
    (when (timerp sidetabs--refresh-timer)
      (cancel-timer sidetabs--refresh-timer))
    (setq sidetabs--return-window nil
          sidetabs--last-buffer-list nil
          sidetabs--buffers-order nil
          sidetabs--refreshing nil
          sidetabs--refresh-timer nil)
    (when-let ((window (sidetabs--window)))
      (delete-window window))))

(provide 'sidetabs)

;;; sidetabs.el ends here

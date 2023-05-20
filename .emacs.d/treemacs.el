(defun treemacs-mode-handler()
       (set (make-local-variable 'face-remapping-alist)
            '((default :background "#303030"))))

(setq need-scale (and (not (eq ":0" (getenv "DISPLAY"))) (eq 'gnu/linux system-type)))
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (treemacs-modify-theme "Default"
    :config
    (progn
      (treemacs-create-icon :icon "- "   :fallback ""       :extensions (root-open))
      (treemacs-create-icon :icon "+ " :fallback ""       :extensions (root-closed))
      (treemacs-create-icon :icon "+ " :extensions (dir-closed)) ;+→
      (treemacs-create-icon :icon "- " :extensions (dir-open)))) ;-↓
  (progn
    (treemacs-resize-icons 12)
    (add-hook 'treemacs-mode-hook #'treemacs-hl-line)
    (add-hook 'treemacs-mode-hook 'treemacs-mode-handler)
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-directory-name-transformer    #'identity
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-extension-regex          treemacs-last-period-regex-value
          treemacs-file-follow-delay             0.2
          treemacs-file-name-transformer         #'identity
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   t
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-asc
          treemacs-space-between-root-nodes      nil
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-user-mode-line-format         nil
          treemacs-width                         35
          )
    (treemacs-follow-mode t)
   
   (dolist (face '(treemacs-root-face
                   treemacs-git-unmodified-face
                   treemacs-git-modified-face
                   treemacs-git-renamed-face
                   treemacs-git-ignored-face
                   treemacs-git-untracked-face
                   treemacs-git-added-face
                   treemacs-git-conflict-face
                   treemacs-directory-face
                   treemacs-directory-collapsed-face
                   treemacs-file-face
                   treemacs-tags-face))
      (set-face-attribute face nil :family "Noto Sans CJK HK" :height (if need-scale 100 100)))
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))


(defun treemacs-hl-line ()
  (face-remap-add-relative
   'hl-line '(:foreground "#f1f1f1" :background "#05445e")))

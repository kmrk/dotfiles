;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "kmrk"
      user-mail-address "kmrkgo@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)


(custom-theme-set-faces! 'doom-one
  '(font-lock-function-name-face :foreground "#98be65")
  '(font-lock-builtin-face :foreground "#da8548")
  '(font-lock-keyword-face :foreground "#ff6c6b")
  '(font-lock-variable-name-face :foreground "#51afef")
  '(font-lock-constant-face :foreground "#51afef")
  '(font-lock-string-face :foreground "#ECBE7B")
  '(font-lock-type-face :foreground "#51afef")
  )
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

                                        ;(load! "~/.config/.emacs.d.my/font.el")

(defcustom which-key-idle-delay 1.0
  "Delay (in seconds) for which-key buffer to popup. This
 variable should be set before activating `which-key-mode'.

A value of zero might lead to issues, so a non-zero value is
recommended
(see https://github.com/justbur/emacs-which-key/issues/134)."
  :group 'which-key
  :type 'float)


(setq org-roam-directory "~/org/roam/")
(setq org-roam-complete-everywhere t)
(use-package! lsp-tailwindcss :init (setq lsp-tailwindcss-add-on-mode t))


(after! org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (emacs-lisp . t)
     (js . t)
     (typescript . t)
     (shell . t))))

(setq scale (if (and (equal ":0" (getenv "DISPLAY")) (eq 'gnu/linux system-type)) 1.5 1))
(set-face-attribute 'default nil :font "JetBrains Mono" :height (round ( * scale 100)))
(defun set-font-face (family height)
  (face-remap-add-relative 'default `(:family ,family :height ,height)))

(add-hook 'org-mode-hook (lambda () (set-font-face "Iosevka Aile" (round (* scale 120)))))
(setq highlight-indent-guides-method 'column)

(map! "C-S-<right>" #'er/expand-region
      "C-S-<left>" #'er/contract-region
      )

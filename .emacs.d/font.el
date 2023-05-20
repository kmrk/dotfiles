(setq need-scale (and (not (eq ":0" (getenv "DISPLAY"))) (eq 'gnu/linux system-type)))

(set-face-attribute 'default nil :font "JetBrains Mono" :height (if need-scale 100 100))

(defun set-font-face (family height)
  (face-remap-add-relative 'default `(:family ,family :height ,height)))

(add-hook 'org-mode-hook (lambda () (set-font-face "Iosevka Aile"  (if need-scale 110 110))))
(add-hook 'prog-mode-hook (lambda () (set-font-face "Monaco"  (if need-scale 100 100))))
add-hook 'shell-mode-hook (lambda () (set-font-face "Fira Code Regular" (if need-scale 100 110)))

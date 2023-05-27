(setq scale (if (and (equal ":0" (getenv "DISPLAY")) (eq 'gnu/linux system-type)) 1.5 1))

(set-face-attribute 'default nil :font "JetBrains Mono" :height (round ( * scale 100)))

(defun set-font-face (family height)
  (face-remap-add-relative 'default `(:family ,family :height ,height)))

(add-hook 'org-mode-hook (lambda () (set-font-face "Iosevka Aile" (round (* scale 120)))))
(add-hook 'prog-mode-hook (lambda () (set-font-face "Monaco" (round (* scale 100)))))
(add-hook 'shell-mode-hook (lambda () (set-font-face "Fira Code Regular" (round (* scale 100)))))

;;; pair-highlight.el --- Extend show-paren highlighting to string delimiters -*- lexical-binding: t; -*-

;;; Commentary:

;; Mirror `show-paren-mode' highlighting for string delimiters.  Only
;; syntax-table string delimiters are highlighted so the result stays aligned
;; with what paredit/evil-paredit treat as string boundaries.

;;; Code:

(defvar pair-highlight--overlays nil
  "Overlays used to extend `show-paren-mode' highlighting to string delimiters.")

(defvar pair-highlight-mode)

(defun pair-highlight--clear ()
  "Clear overlays created by `pair-highlight-mode'."
  (mapc #'delete-overlay pair-highlight--overlays)
  (setq pair-highlight--overlays nil))

(defun pair-highlight--make-overlay (beg end face)
  "Highlight region from BEG to END with FACE."
  (when (< beg end)
    (let ((ov (make-overlay beg end nil t nil)))
      (overlay-put ov 'face face)
      (push ov pair-highlight--overlays))))

(defun pair-highlight--string-delimiter-p (pos)
  "Return non-nil when POS points at a string delimiter in the current syntax table."
  (and pos
       (<= (point-min) pos)
       (< pos (point-max))
       (eq (char-syntax (char-after pos)) ?\")))

(defun pair-highlight--delimiter-span (pos direction)
  "Return the delimiter span around POS following DIRECTION.
DIRECTION should be 1 for a forward scan and -1 for a backward scan."
  (let* ((char (and (pair-highlight--string-delimiter-p pos)
                    (char-after pos)))
         (limit 3)
         (beg pos)
         (end (1+ pos)))
    (when char
      (if (> direction 0)
          (while (and (< (- end beg) limit)
                      (eq (char-after end) char))
            (setq end (1+ end)))
        (while (and (< (- end beg) limit)
                    (> beg (point-min))
                    (eq (char-before beg) char))
          (setq beg (1- beg))))
      (cons beg end))))

(defun pair-highlight--bounds ()
  "Return bounds for string delimiters around point, or nil.
The result is a list: (OPEN-BEGIN OPEN-END CLOSE-BEGIN CLOSE-END FACE)."
  (let* ((ppss (syntax-ppss))
         (in-string (nth 3 ppss))
         (string-start (nth 8 ppss))
         (state-pos (point))
         string-end close-span open-span face)
    (when (and (not in-string)
               (> state-pos (point-min)))
      (let ((before-ppss (save-excursion
                           (syntax-ppss (1- state-pos)))))
        (when (nth 3 before-ppss)
          (setq ppss before-ppss
                in-string t
                string-start (nth 8 before-ppss)))))
    (when (and string-start
               (pair-highlight--string-delimiter-p string-start))
      (setq open-span (pair-highlight--delimiter-span string-start 1))
      (setq string-end (ignore-errors (scan-sexps string-start 1)))
      (setq face (if string-end 'show-paren-match 'show-paren-mismatch))
      (when string-end
        (setq close-span (pair-highlight--delimiter-span (1- string-end) -1)))
      (list (car open-span)
            (cdr open-span)
            (and close-span (car close-span))
            (and close-span (cdr close-span))
            face))))

(defun pair-highlight--update ()
  "Mirror `show-paren-mode' highlighting for string delimiters."
  (pair-highlight--clear)
  (when (and pair-highlight-mode
             (not (minibufferp))
             (not (nth 4 (syntax-ppss))))
    (pcase-let ((`(,open-beg ,open-end ,close-beg ,close-end ,face)
                 (pair-highlight--bounds)))
      (when open-beg
        (pair-highlight--make-overlay open-beg open-end face)
        (if close-beg
            (pair-highlight--make-overlay close-beg close-end face)
          (pair-highlight--make-overlay open-beg open-end face))))))

;;;###autoload
(define-minor-mode pair-highlight-mode
  "Extend `show-paren-mode' highlighting to string delimiters."
  :global t
  (if pair-highlight-mode
      (add-hook 'post-command-hook #'pair-highlight--update)
    (remove-hook 'post-command-hook #'pair-highlight--update)
    (pair-highlight--clear)))

(provide 'pair-highlight)
;;; pair-highlight.el ends here

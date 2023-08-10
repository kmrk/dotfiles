#!/usr/bin/guile \ 
-e main -s
!#
(use-modules (ice-9 rdelim))

(define zellij "zellij -l ~/.config/zellij/")

(define (main args)
  (system (string-append zellij (cadr args) ".kdl"))
  (newline))

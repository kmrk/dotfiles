(
 (plt:framework-pref:drracket:recent-language-names (("Determine language from source" #6(#t print mixed-fraction-e #f #t debug) (default) #0() #f #t #t ((test) (main)) #t)))
 (plt:framework-pref:drracket:language-settings ((-32768) (#6(#t print mixed-fraction-e #f #t debug) (default) #0() #f #t #t ((test) (main)) #t)))
 (plt:framework-pref:framework:verify-exit #f)
 (plt:framework-pref:framework:standard-style-list:font-name "JetBrainsMono Nerd Font Mono")
 (|plt:DrRacket 8.2-splash-max-width| 1010)
 (plt:framework-pref:framework:standard-style-list:smoothing smoothed)
 (plt:framework-pref:framework:standard-style-list:weight light)
 (plt:framework-pref:framework:exit-when-no-frames #t)
 (plt:framework-pref:framework:standard-style-list:font-size #2(#hash((((2560 1600)) . 12)) 12))
 (plt:framework-pref:framework:color-scheme |Modern|)
 (|plt:DrRacket 8.14-splash-max-width| 1029)
 (plt:framework-pref:plt:debug-tool:stack/variable-area 9/10)
 (plt:framework-pref:drracket:most-recent-lang-line "#lang racket\n")
 (plt:framework-pref:drracket:unit-window-size-percentage 1/2)
 (plt:framework-pref:drracket:window-size #hash((#f . (#f 1459 893)) (((0 0 2560 1600)) . (#f 1459 893))))
 (plt:framework-pref:drracket:window-position #hash((#f . (0 0 0)) (((0 0 2560 1600)) . (0 0 0))))
 (plt:framework-pref:drracket:recently-closed-tabs ())
 (plt:framework-pref:drracket:console-previous-exprs (("(+ 2 2)") ("(+ 3 3)") ("(+ 2 2 2 2)")))
 (readline-input-history
  (
   #"(define nvim (nvim-attach in out))"
   #"(define-values (in out) (unix-socket-connect \"/tmp/nvim.sock\"))"
   #"(require nvim racket/unix-socket)"
   #"(define-values (in out) (unix-socket-connect nvim-listen-address))"
   #";; \350\277\236\346\216\245\345\271\266\345\217\221\351\200\201\347\244\272\344\276\213\345\221\275\344\273\244\n  (let-values ([(in out) (connect-to-nvim)])\n    (define nvim (nvim-attach in out))\n    ((nvim \"echo 'Hello world!'\")))"
   #";; \345\217\221\351\200\201\345\221\275\344\273\244\n  (define (nvim-attach in out)\n    (lambda (command)\n      (write-bytes (string->bytes/utf-8 command) out)\n      (flush-output out)))"
   #";; \345\260\235\350\257\225\350\277\236\346\216\245\345\210\260 Neovim \347\232\204 Unix \345\245\227\346\216\245\345\255\227\n  (define (connect-to-nvim)\n    (define-values (in out) (unix-socket-connect \"/tmp/nvim.sock\"))\n    (if (and in out)\n        (values in out)\n        (error \"Failed to connect to Neovim socket\")))"
   #"(require racket/unix-socket)"
   #"(define-values (in out) (unix-socket-connect \"localhost:6666\"))"
  ))
)

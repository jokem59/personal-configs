;;; init-eglot-cpp.el --- C/C++ LSP via eglot + clangd  -*- lexical-binding: t; -*-

;; eglot ships with Emacs 29+, so just require it (no ELPA install needed).
(require 'eglot)

;; --- clangd server command, tuned for a very large C++ tree --------------
;; clangd auto-discovers <project-root>/compile_commands.json by walking up
;; from the visited file, so the DB path does not need to be hard-coded.
;; (Piece A: `gobot bucky compile_commands ...` links it at the repo root.)
(add-to-list 'eglot-server-programs
             '((c++-mode c-mode)
               . ("clangd"
                  "--background-index"       ; index the whole project in the background
                  "-j=8"                     ; parallel indexing workers
                  "--pch-storage=memory"     ; keep PCHs in RAM (you have 64 GB)
                  "--header-insertion=never" ; don't auto-insert #includes on completion
                  "--completion-style=detailed"
                  "--limit-results=100")))

;; --- performance tunings eglot/clangd need at this scale -----------------
;; Large clangd responses arrive in big chunks; the stock 4 KB read size and
;; low GC threshold make eglot feel sluggish otherwise.
(setq read-process-output-max (* 4 1024 1024))   ; 4 MB (default is 4 KB)
(setq gc-cons-threshold (* 100 1024 1024))       ; 100 MB — fewer GC pauses during LSP
(setq eglot-sync-connect nil)                    ; don't block Emacs while clangd starts
(setq eglot-autoshutdown t)                      ; stop clangd when its last buffer closes

;; Don't log every LSP event (variable was renamed in newer eglot).
(if (boundp 'eglot-events-buffer-config)
    (setq eglot-events-buffer-config '(:size 0 :format full))
  (setq eglot-events-buffer-size 0))

(add-hook 'c-mode-hook   #'eglot-ensure)
(add-hook 'c++-mode-hook #'eglot-ensure)

;; --- LSP keybindings under the `C-c l' prefix (lsp-mode-style) -----------
;; Active only in eglot-managed buffers. `C-c l' then wait shows the menu.
(with-eval-after-load 'eglot
  (define-prefix-command 'my/eglot-map)
  (keymap-set eglot-mode-map "C-c l" 'my/eglot-map)
  (dolist (b '(("d" . xref-find-definitions)      ; definition
               ("D" . eglot-find-declaration)     ; declaration
               ("i" . eglot-find-implementation)  ; implementation(s)
               ("t" . eglot-find-typeDefinition)  ; type definition
               ("r" . xref-find-references)        ; references
               ("s" . consult-imenu)               ; symbols in this file
               ("S" . consult-eglot-symbols)       ; symbols across the project
               ("n" . flymake-goto-next-error)     ; next diagnostic
               ("p" . flymake-goto-prev-error)     ; previous diagnostic
               ("e" . consult-flymake)             ; list all diagnostics
               ("R" . eglot-rename)                ; rename symbol
               ("a" . eglot-code-actions)          ; code actions / quick-fixes
               ("f" . eglot-format)))              ; format region/buffer
    (keymap-set my/eglot-map (car b) (cdr b))))

(provide 'init-eglot-cpp)
;;; init-eglot-cpp.el ends here

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

(provide 'init-eglot-cpp)
;;; init-eglot-cpp.el ends here

(require 'eglot)

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(cpp-mode . ("clangd" "--stdio"))))

(provide 'eglot-cpp)

(require 'eglot)

(use-package eglot :ensure t)
(add-to-list 'eglot-server-programs
               '((c++-mode c-mode) "clangd"))

(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)

(provide 'init-eglot-cpp)

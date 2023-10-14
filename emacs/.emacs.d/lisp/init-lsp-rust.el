(use-package eglot
  :hook ((rust-mode nix-mode) . eglot-ensure)
  :config (add-to-list 'eglot-server-programs
                       `(rust-mode . ("rust-analyzer" :initializationOptions
                                     ( :procMacro (:enable t)
                                       :cargo ( :buildScripts (:enable t)
                                                :features "all"))))))

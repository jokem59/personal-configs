(require 'lsp-mode)
(require 's)
(require 'f)

(setq lsp-trace 't)
(setq lsp-print-io 't)

(defvar lsp-cpp-exe "c:\\tools\\personal-configs\\emacs\\.emacs.d\\server\\Microsoft.VSCode.CPP.Extension.exe")

(defvar lsp-cpp-cache-dir (expand-file-name ".lsp-cpp" user-emacs-directory)
  "Path to directory where server will write cache files.  Must not nil.")

(defun lsp-cpp--extra-init-params ()
  "Return form describing parameters for language server."
  )

(defgroup lsp-cpp nil
  "Cpp language."
  :group 'lsp-mode
  :tag "Cpp language")

(defcustom lsp-cpp-diagnostics-enabled t
  "Enable diagnostics."
  :type 'boolean
  :group 'lsp-cpp)

(defcustom lsp-cpp-code-completion-enabled t
  "Enable code completion feature."
  :type 'boolean
  :group 'lsp-cpp)

(define-inline lsp-cpp--bool-to-json (val)
  (inline-quote (if ,val t :json-false)))

(defun lsp-cpp--make-init-options ()
  "Init options for cpp."
  `(:codeCompletionEnable ,(lsp-cpp--bool-to-json lsp-cpp-code-completion-enabled)
                          :diagnosticsEnabled ,lsp-cpp-diagnostics-enabled))

(defvar lsp-cpp--sess-id 0)

(defvar lsp-cpp--major-modes '(c++-mode))

(lsp-register-client
 (make-lsp-client
  :new-connection (lsp-stdio-connection "C:\\Users\\joskim\\.vscode\\extensions\\ms-vscode.cpptools-0.22.1\\bin\\Microsoft.VSCode.CPP.Extension.exe")
  :major-modes '(c-mode c++-mode objc-mode)
  :server-id 'cpp-ls
  :initialization-options 'lsp-cpp--make-init-options
  :priority -2
  ))

(provide 'lsp-cpp)

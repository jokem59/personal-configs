;;; init-eglot.el --- Start eglot automatically for every language  -*- lexical-binding: t; -*-

;; eglot runs one server per (project, major mode), so a mixed C++/Python/Lua
;; repo gets clangd, ty and lua-language-server side by side, each managing
;; its own buffers. `consult-eglot-symbols' (C-c l S) queries all of a
;; project's servers at once. Server commands and C-c l keys live in
;; init-eglot-cpp.el.

(require 'cl-lib)
(require 'eglot)
(require 'project)

;; --- Python: prefer the project's own .venv, then PATH -------------------
;; ty is what game-engine type-checks with; it lives in <root>/.venv/bin, which
;; isn't on the daemon's exec-path.
(defun my/eglot-python-contact (&optional _interactive project)
  "Return the first available Python LSP command for PROJECT."
  (let ((venv (and project (expand-file-name ".venv/bin/" (project-root project)))))
    (cl-loop for (prog . args) in '(("ty" "server")
                                    ("basedpyright-langserver" "--stdio")
                                    ("pyright-langserver" "--stdio")
                                    ("pylsp"))
             for local = (and venv (concat venv prog))
             for path = (if (and local (file-executable-p local))
                            local
                          (executable-find prog))
             when path return (cons path args))))

(add-to-list 'eglot-server-programs
             '((python-mode python-ts-mode) . my/eglot-python-contact))

;; --- modes eglot's built-in table doesn't cover -----------------------
;; .js opens in js3-mode, .html in mhtml-mode, .toml in conf-toml-mode.
(add-to-list 'eglot-server-programs
             '((js3-mode :language-id "javascript") . ("typescript-language-server" "--stdio")))
(add-to-list 'eglot-server-programs
             '(mhtml-mode . ("vscode-html-language-server" "--stdio")))
(add-to-list 'eglot-server-programs
             '((conf-toml-mode toml-ts-mode) . ("taplo" "lsp" "stdio")))

;; typescript-mode (MELPA) only claims .ts; route .tsx to it too.
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-mode))

;; --- auto-start ------------------------------------------------------------
(defun my/eglot-server-available-p ()
  "Non-nil if `eglot-server-programs' has an installed server for this mode."
  (when-let* ((contact (cdr (eglot--lookup-mode major-mode))))
    (pcase contact
      ((pred functionp) (ignore-errors (funcall contact nil (project-current))))
      (`(,(and prog (pred stringp)) . ,_) (executable-find prog))
      (_ t))))

(defun my/eglot-maybe-ensure ()
  "Start eglot for a project file whose language has an installed server.
Skips non-file and remote buffers, files outside any project (so a stray file
in $HOME doesn't make $HOME the workspace), and languages with no server."
  (when (and buffer-file-name
             (not (file-remote-p buffer-file-name))
             (project-current)
             (my/eglot-server-available-p))
    (eglot-ensure)))

;; Covers every major mode, not just prog-mode (yaml, toml, markdown, ...).
(add-hook 'after-change-major-mode-hook #'my/eglot-maybe-ensure)

(provide 'init-eglot)
;;; init-eglot.el ends here

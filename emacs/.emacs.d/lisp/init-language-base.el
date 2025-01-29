;(add-hook 'after-init-hook 'global-company-mode)
(autoload 'powershell-mode "powershell-mode" "A editing mode for Microsoft PowerShell." t)

;; So powershell-mode works from startup
(require 'powershell)

(setq counsel-grep-base-command
      "rg -i -M 120 --no-heading --line-number --color never '%s' .")

(setq c-default-style
      '((java-mode . "java")
        (awk-mode . "awk")
        (other . "k&r")))

(setq c-basic-offset 4)

;;
;; cc-mode c++-mode customize font locking
(global-font-lock-mode t)
(setq font-lock-maximum-decoration 2
	  font-lock-maximum-size nil)
(setq font-lock-support-mode 'jit-lock-mode)
(setq jit-lock-stealth-time 16
      jit-lock-defer-contextually t
      jit-lock-stealth-nice 0.5)
(setq-default font-lock-multiline t)

(setq auto-mode-alist
      (append '(
                ("\\.cs$" . csharp-mode)
                ("\\.js$" . js3-mode)
                ("\\.ps1$" . powershell-mode)
                ("\\.psm1$" . powershell-mode)
                ("\\.log$" . log4j-mode)
                ) auto-mode-alist ))

(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
              (flycheck-mode 0))))

;; Flycheck to check for inline errors
(use-package flycheck :ensure)

(provide 'init-language-base)

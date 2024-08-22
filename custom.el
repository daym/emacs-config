
(setq user-full-name "Danny Milosavljevic")
(setq user-mail-address "dannym@scratchpost.org")

(setq send-mail-function    'smtpmail-send-it
      smtpmail-smtp-server  "w0062d1b.kasserver.com"
      smtpmail-stream-type  'starttls
      smtpmail-smtp-service 587)

                                        ; argh
(setq python-shell-completion-native-disabled-interpreters '("python3" "pypy3"))

                                        ;(setq vc-handled-backends '("git"))
(setq message-send-mail-function 'smtpmail-send-it)
(setq user-mail-address "dannym@scratchpost.org")

                                        ;(lsp-register-client
                                        ; (make-lsp-client :new-connection (lsp-tramp-connection "clangd")
                                        ;                  :major-modes '(c-mode c++-mode)
                                        ;                  :remote? t
                                        ;                  :server-id 'clangd-remote))

;; Consider setting this to a negative number
                                        ;(setq mouse-autoselect-window t)


(setq visible-bell t)

(add-to-list 'load-path "~/.emacs.d/lisp/")
(load "~/.emacs.d/lisp/unbreak.el")
(load "modern-fringes.el")

(add-hook 'scheme-mode-hook 'guix-devel-mode)

                                        ;(straight-use-package
                                        ;  '(nano :type git :host github :repo "rougier/nano-emacs"))

;(setq nano-font-size 10)

                                        ;(add-to-list 'load-path "~/.emacs.d/nano-emacs/")
                                        ;(load "nano.el")

                                        ; Too new version requires svg-tag-mode which is dumb
(add-to-list 'load-path "~/.emacs.d/notebook-mode/")
(load "notebook.el")

                                        ;(setq org-ellipsis "▾")

                                        ; See https://magit.vc/manual/ghub/Storing-a-Token.html
(setq auth-sources '("~/.authinfo"))

;; Assuming the Guix checkout is in ~/src/guix.
;; Yasnippet configuration
(with-eval-after-load 'yasnippet
  (add-to-list 'yas-snippet-dirs "~/src/guix/etc/snippets/yas"))
;; Tempel configuration
(with-eval-after-load 'tempel
  ;; Ensure tempel-path is a list -- it may also be a string.
  (unless (listp 'tempel-path)
    (setq tempel-path (list tempel-path)))
  (add-to-list 'tempel-path "~/src/guix/etc/snippets/tempel/*"))

;; Assuming the Guix checkout is in ~/src/guix.
(load-file "~/src/guix/etc/copyright.el")

                                        ; super-g
(global-set-key (kbd "s-g") 'guix)

(add-hook 'shell-mode-hook 'guix-prettify-mode)
(add-hook 'dired-mode-hook 'guix-prettify-mode)

(add-to-list 'load-path "~/.emacs.d/combobulate/")
(load "combobulate.el")

;; Free version; see also https://github.com/WebFreak001/code-debug supports both gdb and lldb in case someone is interested.
                                        ; "gdb -i dap" is enough for DAP mode so no idea what all this is for here.
(add-to-list 'load-path "~/.emacs.d/dap-gdb/")
(load "dap-gdb.el")

(add-to-list 'load-path "~/.emacs.d/ssass-mode/")
(load "ssass-mode.el")

(add-to-list 'load-path "~/.emacs.d/vue-html-mode/")
(load "vue-html-mode.el")

(add-to-list 'load-path "~/.emacs.d/vue-mode/")
(load "vue-mode.el")

                                        ;(add-to-list 'load-path "~/src/dap-mode/")
;;(load "dap-mode.el")
                                        ;(require 'dap-cpptools)

(add-to-list 'load-path "~/.emacs.d/bar-cursor/")
;;(load "dap-mode.el")
(require 'bar-cursor)
(bar-cursor-mode 1)

(add-to-list 'load-path "~/.emacs.d/elfeed-tube/")
(require 'elfeed-tube)
(require 'elfeed-tube-mpv)

                                        ; Scheme IDE

(setq geiser-mode-auto-p nil)
(require 'arei)

                                        ; Latex

(add-to-list 'load-path "~/.emacs.d/xenops/lisp/")
(require 'xenops)
(add-hook 'LaTeX-mode-hook #'xenops-mode)

                                        ; Undefined
                                        ;(latex +cdlatex +latexmk +lsp)
                                        ;(latex +lsp)

(add-to-list 'load-path "~/.emacs.d/wakib-keys/")
(require 'wakib-keys)
(wakib-keys 1)

(load "/home/dannym/.emacs.d/lisp/copilot.el")
(global-set-key (kbd "C-.") 'copilot-complete)

(require 'opascal)

(add-hook 'opascal-mode-hook
          (lambda ()
            "Prettify Object Pascal"
            (push '("begin" . ?{) prettify-symbols-alist)
            (push '("end" . ?}) prettify-symbols-alist)
            (push '(":=" . "≝") prettify-symbols-alist) ; or ≔
            ))

(require 'python-django)

                    ; requires markchars.el which is not in Guix
                    ;(markchars-global-mode)
                    ;(defface markchars-heavy
                    ;  '((t :underline "magenta"))
                    ;  "Heavy face for `markchars-mode' char marking."
                    ;  :group 'markchars)

;; -*- lexical-binding: t -*-

                                        ; Gtk 3
(global-unset-key (kbd "<f10>"))

;; XXX test
                                        ;(save-place-mode 1) ; save cursor position
                                        ;(desktop-save-mode 1) ; save the desktop session
                                        ;(savehist-mode 1) ; save history

(pixel-scroll-precision-mode 1)
(global-auto-revert-mode 1) ; revert buffers when the underlying file has changed

;;; disable byte compilation would be: (setq load-suffixes '(".el"))

(setq
 backup-by-copying t      ; don't clobber symlinks
 backup-directory-alist
 '(("." . "~/backup/"))    ; don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)       ; use versioned backups

;; Don't use tabs to indent (by default).
;; Note: Major modes and minor modes are allowed to locally change the indent-tabs-mode variable, and a lot of them do.
(setq-default indent-tabs-mode nil)

(setq column-number-mode t)
(setq lsp-ui-doc-enable t)
(setq lsp-ui-doc-show-with-mouse t)
(setq tab-always-indent 'complete)
(setq rust-format-on-save t)
(setq lsp-enable-suggest-server-download nil)
                                        ; <https://github.com/thread314/intuitive-tab-line-mode>
(global-tab-line-mode 1)
(global-visual-line-mode 1)

(add-hook 'org-mode-hook 'variable-pitch-mode)
(add-hook 'rustic-mode-hook 'variable-pitch-mode)
                                        ;  (add-hook 'rust-ts-mode-hook 'variable-pitch-mode)
(add-hook 'treemacs-mode-hook 'variable-pitch-mode)
(add-hook 'nxml-mode-hook 'variable-pitch-mode)
(add-hook 'emacs-lisp-mode-hook 'variable-pitch-mode)
(add-hook 'js-mode-hook 'variable-pitch-mode)
(add-hook 'css-mode-hook 'variable-pitch-mode)
(add-hook 'html-mode-hook 'variable-pitch-mode)
(add-hook 'mhtml-mode-hook 'variable-pitch-mode)
(add-hook 'python-mode-hook 'variable-pitch-mode)
                                        ; Nope. (add-hook 'scheme-mode-hook 'variable-pitch-mode)

(tool-bar-mode 1)
					;(tool-bar-add-item "my-custom-action" 'my-custom-command "tooltip" 'my-custom-icon)

(require 'mh-e) ; mail

(setq display-buffer-alist
      '(
	("\\*messages.*"
	 (display-buffer-in-side-window)
	 (window-width . 0.25) ;; Side window takes up 1/4th of the screen
	 (side . right)
	 )
	("^\\*Projectile.*"
	 ((display-buffer-reuse-window display-buffer-at-top)
          (window-height . 0.25)))
	("^\\*scratch.*"
	 ((display-buffer-reuse-window display-buffer-at-bottom)
          (window-height . 0.1)))
	("\\*Warnings.*"
	 (display-buffer-reuse-window display-buffer-in-side-window)
	 (window-width . 0.25) ;; Side window takes up 1/4th of the screen
	 (side . right)
	 )
	))

(projectile-mode +1)

(setq inhibit-startup-message t)    ;; Hide the startup message
(global-prettify-symbols-mode 1)

(use-package pyvenv
  :ensure nil
  :config
  (pyvenv-mode nil))

(global-set-key (kbd "<mouse-8>") 'back-button-global-backward)
(global-set-key (kbd "<mouse-9>") 'back-button-global-forward)
(global-set-key (kbd "M-<Left>") 'back-button-global-backward)
(global-set-key (kbd "M-<Right>") 'back-button-global-forward)

(global-set-key (kbd "C-a") 'mark-whole-buffer)
(global-set-key (kbd "<XF86Search>") 'search-forward)
(global-set-key (kbd "<Search>") 'search-forward)
					;(global-set-key (kbd "<Launch1>") 'async-shell-command)
(global-set-key (kbd "<Launch1>") 'project-compile)

                                        ; TODO local; TODO override paragraphs.el forward-paragraph
                                        ;(global-set-key (kbd "C-<Down>") 'combobulate-navigate-logical-next)
                                        ;(global-set-key (kbd "C-<Up>") 'combobulate-navigate-logical-previous)

                                        ; (column-number-mode)
                                        ; (global-display-line-numbers-mode t)
                                        ;(global-display-line-numbers-mode 1) ; that includes treemacs and that's dumb
                                        ;(dolist (mode '(org-mode-hook term-mode-hook eshell-mode-hook treemacs-mode-hook))
                                        ;  (add-hook mode
                                        ;            (lambda ()
                                        ;              (display-line-numbers-mode 0))));
                                        ; Shouldn't those be context-dependent?

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(global-set-key (kbd "<f2>") 'save-buffer)
					; TODO: restart
					;(global-set-key (kbd "C-<f2>") ')

(global-set-key (kbd "<f3>") 'counsel-find-file)
(global-set-key (kbd "C-<f3>") 'find-file-at-point)
(global-set-key (kbd "M-<f3>") 'ff-get-other-file)

					; f4 exec to cursor
(global-set-key (kbd "<f4>") 'gud-until) ; dap-debug-restart-frame
(global-set-key (kbd "C-<f4>") 'gud-jump)

					; TODO: Shift-F7 step to next source line!
					;(global-set-key (kbd "<f7>") 'gud-step)
					; TODO: Evaluate/Modify...
					; (global-set-key (kbd "C-<f7>") 'gud-eval)
					;(global-set-key (kbd "<f8>") 'gud-next)

					; paredit was older than combobulate
					; next sibling; via combobulate
(global-set-key (kbd "C-M-<down>") 'forward-sexp)

					; user! ; gud-remove ?
(global-set-key (kbd "<f5>") 'dap-breakpoint-toggle)

					; TODO: C-<f5>: Add watch...
					; TODO: M-<end>: go to next floating window
					; TODO: Ctrl+R refactoring

					; TODO: Alt+[ / Ctrl+Q+[  find matching bracket
					; TODO: Alt+] / Ctrl+Q+]  find matching bracket
					; TODO: Alt+Page Down  next tab
					; TODO: Alt+Page Up  previous tab
					; TODO: Alt+Up Arrow / Ctrl+Right Click  go to declaration
					; TODO: Ctrl+/ comment toggle
					; TODO: Ctrl+Spacebar code completion
					; TODO: Ctrl+K+1 (or 2-9) set bookmark
					; TODO: Ctrl+0 (or 1-9) / Ctrl+Q+0 (or 1-9) go to bookmark
					; TODO: Shift+Ctrl+1 (or 2-9) remove bookmark
					; TODO: Ctrl+Alt+Down Arrow go to next method!!!
					; TODO: Ctrl+Alt+Mouse Scroll hop between methods!!!
					; TODO: Ctrl+Alt+Up Arrow go to previous method
					; TODO: Ctrl+Backspace delete word previous to cursor
					; TODO: Ctrl+Home / Ctrl+Q+R  cursor to top of file
					; TODO: Ctrl+F4   close current editor page
					; TODO: Ctrl+J  code template completion
					; TODO: Ctrl+K+N toupper block
					; TODO: Ctrl+K+O tolower block
					; TODO: Ctrl+O+U toggle case of block
					; TODO: Ctrl+K+U / Shift+Ctrl+U / Shift+Tab  outdent
					; TODO: Ctrl+K+W write block to file
					; TODO: Ctrl+O+C turn on column blocking
					; TODO: Ctrl+O+K turn off column blocking
					; TODO: Shift+Ctrl+B  display buffer list
					; TODO: Shift+Ctrl+Down Arrow jump between declaration and implementation section
					; TODO: Shift+Ctrl+K+C collapse all classes
					; [...]

					; f5 to f9 reserved for users

					; https://delphi.fandom.com/wiki/Default_IDE_Shortcut_Keys
					; FIXME: also run under debugger
(global-set-key (kbd "<f8>") 'dap-continue)
(global-set-key (kbd "<f9>") 'project-compile)
					; FIXME: Alt+F9 recompile all, Shift-F9 same
(global-set-key (kbd "C-<f9>") 'compile)
(global-set-key (kbd "<f11>") 'dap-step-in)
(global-set-key (kbd "C-<f11>") 'gud-stepi)
(global-set-key (kbd "S-<f11>") 'dap-step-out)
;; FIXME need to disable the menu opening then!
(global-set-key (kbd "<f10>") 'dap-next)
(global-set-key (kbd "C-<f10>") 'gud-nexti)
					; TODO: shift-ctrl-f find in files
					; TODO: ctrl-h search replace
					; Ctrl+Alt+B breakpoint list
					; Ctrl+Alt+S call stack
					; Ctrl+Alt+W watches
					; Ctrl+Alt+L local variables
					; Ctrl+Alt+T thread status
					; Ctrl+Alt+V event log
					; Ctrl+Alt+M modules window
					; Ctrl+Alt+C entire CPU pane
					; Ctrl+Alt+D disassembly
					; Ctrl+Alt+R registers
					; Ctrl+Alt+K stack
					; Ctrl+Alt+1 memory 1
					; Ctrl+Alt+2 memory 2
					; Ctrl+Alt+3 memory 3
					; Ctrl+Alt+4 memory 4
					; Ctrl+Alt+F fpu sse contents
					; Shift+Ctrl+H help insight at point (info about symbol at cursor)
					; F11 object inspector
					; Alt+0 display list of open windows
					; Shift+Ctrl+V declare variable... (popup)
					; Shift+Ctrl+D declare field... (popup)
					; Shift+Ctrl+M extract method
					; Shift+Ctrl+L resource string
					; Shift+Ctrl+X change params of method
					; Shift+Ctrl+Alt+F9 deploy project
					; Shift+Ctrl+F9 run without debugger

(global-set-key (kbd "C-f") 'find)


					; (global-set-key (kbd "<fx>") 'foo-imenu)

					; FIXME: treesit-language-source-alist

					; Writing a major mode with tree-sitter https://git.savannah.gnu.org/cgit/emacs.git/plain/admin/notes/tree-sitter/starter-guide?h=feature/tree-sitter
                                        ;(when (boundp 'treesit-extra-load-path)
(add-to-list 'treesit-extra-load-path "/home/dannym/.guix-home/profile/lib/tree-sitter/")
                                        ;)
					;(setq treesit-extra-load-path '())
					; void: treesit-parser-list

;;; CUA mode

(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-S-s") 'save-buffer)

                                        ;(cua-mode t) ; replaced by wakib-keys
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour

;;; Mouse in terminal

					; M-x xterm-mouse-mode
(xterm-mouse-mode 1)

;;; Virtual word wrapping

					;(add-hook 'text-mode-hook 'visual-line-mode)
(setq-default word-wrap t)
					; default: C-a (beginning-of-visual-line) moves to the beginning of the screen line, C-e (end-of-visual-line) moves to the end of the screen line, and C-k (kill-visual-line) kills text to the end of the screen line.
					;(bind-key* "cursor down" 'next-logical-line)
					;(bind-key* "cursor up" 'previous-logical-line)
					; TODO: only in text editor?
(global-set-key (kbd "<down>") 'next-logical-line)
(global-set-key (kbd "<up>") 'previous-logical-line)

;;; Packages

(require 'package)
(package-initialize)

;;; Magit "git-commit-* unavailable"

					;(require 'magit)
					;(kill-buffer "*scratch*")
					;(setq magit-status-buffer-switch-function 'switch-to-buffer)
					;(call-interactively 'magit-status)
					;(require 'magit-status)
					; FIXME: (magit-status)

;;; Git

					;(with-eval-after-load 'geiser-guile
					;  (add-to-list 'geiser-guile-load-path "~/src/guix"))

;; probably cargo-culted from somewhere
(update-glyphless-char-display 'glyphless-char-display-control '((format-control . empty-box) (no-font . empty-box)))

;; See https://emacs.stackexchange.com/questions/65108
(set-face-background 'glyphless-char "purple")

(require 'vc)

(global-diff-hl-mode 1)
(add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
(add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cua-mode t)
 '(elfeed-feeds
   '(("http://planet.emacslife.com/atom.xml" emacs) "https://lwn.net/headlines/rss" "https://subscribe.fivefilters.org/?url=http%3A%2F%2Fftr.fivefilters.net%2Fmakefulltextfeed.php%3Furl%3Dhttps%253A%252F%252Fhnrss.org%252Ffrontpage%26max%3D3%26links%3Dpreserve" "https://subscribe.fivefilters.org/?url=http%3A%2F%2Fftr.fivefilters.net%2Fmakefulltextfeed.php%3Furl%3Dhttps%253A%252F%252Fwww.nature.com%252Fnmat%252Fcurrent_issue%252Frss%252F%26max%3D3%26links%3Dpreserve" "https://subscribe.fivefilters.org/?url=http%3A%2F%2Fftr.fivefilters.net%2Fmakefulltextfeed.php%3Furl%3Dhttps%253A%252F%252Fwww.nature.com%252Fnphys%252Fcurrent_issue%252Frss%252F%26max%3D3%26links%3Dpreserve" "https://semianalysis.substack.com/feed" "https://slow-journalism.com/blog/feed" "http://ftr.fivefilters.net/makefulltextfeed.php?url=https%3A%2F%2Ffeeds.arstechnica.com%2Farstechnica%2Ffeatures&max=3"))
 '(format-all-debug nil)
 '(format-all-show-errors 'errors)
 '(frame-background-mode 'light)
 '(ignored-local-variable-values
   '((eval modify-syntax-entry 43 "'")
     (eval modify-syntax-entry 36 "'")
     (eval modify-syntax-entry 126 "'")
     (geiser-guile-binary "guix" "repl")
     (geiser-insert-actual-lambda)))
 '(lsp-rust-analyzer-rustc-source
   "/usr/local/rustup/toolchains/nightly-2024-08-03-x86_64-unknown-linux-musl/lib/rustlib/rustc-src/rust/compiler/rustc/Cargo.toml")
 '(package-selected-packages
   '(org-mime back-button counsel-projectile counsel-tramp magit-popup edit-indirect eat flycheck-rust typescript-mode go-mode git-timemachine web-mode rainbow-delimiters geiser-guile flycheck-guile clojure-mode envrc shackle vertico counsel pkg-info rustic magit-svn magit-gerrit agda2-mode tramp find-file-in-project elpy lsp-ui consult embark pg finalize org-roam eval-in-repl eval-in-repl-slime slime-company ts async ement crdt paredit))
 '(smtpmail-smtp-server "w0062d1b.kasserver.com" t)
 '(smtpmail-smtp-service 25 t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Noto Sans Mono" :foundry "GOOG" :slant normal :weight regular :height 110 :width normal))))
 '(lsp-ui-sideline-global ((t (:family "Dijkstra Italic" :italic t :weight regular :height 0.8)))))

(set-face-attribute 'default nil :height 110)
(setq tool-bar-button-margin (cons 7 1))

(with-eval-after-load 'treemacs
  (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action))

					;(treemacs-git-mode 'simple)

;; `M-x combobulate' (or `C-c o o') to start using Combobulate
(use-package treesit
  :preface
  ;; Optional, but recommended. Tree-sitter enabled major modes are
  ;; distinct from their ordinary counterparts.
  ;;
  ;; You can remap major modes with `major-mode-remap-alist'. Note
  ;; that this does *not* extend to hooks! Make sure you migrate them
  ;; also
					; See also https://github.com/renzmann/treesit-auto/blob/main/treesit-auto.el
  (dolist (mapping '((sh-mode . bash-ts-mode)
                                        ;(csharp-mode . csharp-ts-mode) ; doesn't work
                     (c-mode . c-ts-mode)
                     (clojure-mode . clojure-ts-mode)
                     (css-mode . css-ts-mode)
                     (go-mode . go-ts-mode) ; doesn't work
                     (go-mod-mode . go-mod-ts-mode) ; doesn't work
					;((mhtml-mode sgml-mode) . html-ts-mode) ; isn't found
                     (mhtml-mode . html-ts-mode) ; isn't found
                     (java-mode . java-ts-mode)
                     (javascript-mode . js-ts-mode)
                     (js-json-mode . json-ts-mode)
                     (python-mode . python-ts-mode)
                                        ;(rust-mode . rust-ts-mode)
                     (typescript-mode . tsx-ts-mode) ; or typescript-ts-mode
					;(js-mode . js-ts-mode)
                     (yaml-mode . yaml-ts-mode)))
    (add-to-list 'major-mode-remap-alist mapping))

  :config
  (setq treesit-extra-load-path (list "/home/dannym/.guix-home/profile/lib/tree-sitter/"))
  (setq treesit-auto-install 'prompt)
                                        ;					  (require 'tree-sitter-langs)
                                        ;					  (global-tree-sitter-mode)
                                        ;					  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)

  
					; no (mp-setup-install-grammars)
  ;; Do not forget to customize Combobulate to your liking:
  ;;
  ;;  M-x customize-group RET combobulate RET
  ;;
  (use-package combobulate
    ;; Optional, but recommended.
    ;;
    ;; You can manually enable Combobulate with `M-x
    ;; combobulate-mode'.
    :commands combobulate-mode ; XXX
    :hook ((python-ts-mode . combobulate-mode)
           (js-ts-mode . combobulate-mode)
           (css-ts-mode . combobulate-mode)
					;(html-ts-mode . combobulate-mode)
           (yaml-ts-mode . combobulate-mode)
           (typescript-ts-mode . combobulate-mode)
           (tsx-ts-mode . combobulate-mode)
           (rust . combobulate-mode))
    ;; Amend this to the directory where you keep Combobulate's source
    ;; code.
    :load-path ("/home/dannym/.emacs.d/combobulate")))

(add-hook 'scheme-mode-hook
          (lambda ()
            "Prettify Guile"
            (push '("lambda*" . "λ*") prettify-symbols-alist)
            (push '("lambda" . "λ") prettify-symbols-alist)
            ))

(add-hook 'python-mode-hook
          (lambda ()
            "Prettify Python"
            (push '("in" . "∈") prettify-symbols-alist)
            (push '("True" . "⊨") prettify-symbols-alist)
            (push '("False" . "⊭") prettify-symbols-alist)
            (push '("is" . "≡") prettify-symbols-alist)
            (push '("is not" . "≢") prettify-symbols-alist)
            (push '("__add__" . "+") prettify-symbols-alist)
            (push '("__sub__" . "-") prettify-symbols-alist)
            (push '("__mul__" . "*") prettify-symbols-alist)
            (push '("__mod__" . "%") prettify-symbols-alist)
            (push '("__truediv__" . "/") prettify-symbols-alist)
            (push '("__floordiv__" . "//") prettify-symbols-alist)
            (push '("__gt__" . ">") prettify-symbols-alist)
            (push '("__ge__" . ">=") prettify-symbols-alist)
            (push '("__lt__" . "<") prettify-symbols-alist)
            (push '("__le__" . "<=") prettify-symbols-alist)
            (push '("__eq__" . "==") prettify-symbols-alist)
            (push '("__ne__" . "!=") prettify-symbols-alist)
            (push '("issubset" . "⊆") prettify-symbols-alist)
            (push '("issuperset" . "⊇") prettify-symbols-alist)
					; U+2264 less than or equal ≤
					; U+2265 greater than or equal ≥
					; U+2216 set minus ∖
					; U+2229 intersection ∩
					; U+222A union ∪
					; TODO __or__ __pos__ __pow__ __r*__ __trunc__ __lshift__
					; TODO __xor__ __and__ __or__
					; TOOD __neg__
            ))

					; rust-format-buffer C-c C-f
					;(setq rust-format-on-save t)

					; FIXME html-mode-hook which un-awfuls <mi> etc
(add-hook 'rust-mode-hook
          (lambda ()
            "Prettify Rust"
            (push '("add" . "+") prettify-symbols-alist)
            (push '("sub" . "-") prettify-symbols-alist)
            (push '("mul" . "*") prettify-symbols-alist)
            (push '("div" . "/") prettify-symbols-alist)
            (push '("not" . "!") prettify-symbols-alist)
            (push '("gt" . ">") prettify-symbols-alist)
            (push '("ge" . ">=") prettify-symbols-alist)
            (push '("lt" . "<") prettify-symbols-alist)
            (push '("le" . "<=") prettify-symbols-alist)
            (push '("eq" . "==") prettify-symbols-alist)
            (push '("ne" . "!=") prettify-symbols-alist)
					;(prettify-symbols-mode t)
            ))

					;C-c C-c C-u rust-compile
					;C-c C-c C-k rust-check
					;C-c C-c C-t rust-test
					;C-c C-c C-r rust-run
					;rust-run-clippy runs Clippy, a linter. By default, this is bound to C-c C-c C-l.
					; rust-dbg-wrap-or-unwrap C-c C-d
					; rust-toggle-mutability

                                        ;(require 'gud)
(setq left-fringe-width 160)
(set-fringe-style (quote (20 . 12))) ; left right; 12 . 8

					; part of emacs 29
(require 'eglot)
(add-to-list 'eglot-server-programs
             `(rust-mode "rust-analyzer"))

					;;; rustic is based on rust-mode, extending it with other features such as integration with LSP and with flycheck.

                                        ;(use-package csharp-mode
                                        ;  :ensure t
                                        ;  :config
(add-to-list 'auto-mode-alist '("\\.cs\\'" . csharp-tree-sitter-mode))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(add-to-list 'auto-mode-alist '("\\.rs" . rustic-mode))
(add-to-list 'auto-mode-alist '("\\.cs" . csharp-mode))
(add-to-list 'auto-mode-alist '("\\.js" . js2-mode))
                                        ;(add-to-list 'auto-mode-alist '("\\.ts" . typescript-mode)) ; or combobulate-typescript-mode
                                        ;(add-to-list 'auto-mode-alist '("\\.rs" . rust-ts-mode))

                                        ;(add-to-list 'frames-only-mode-kill-frame-when-buffer-killed-buffer-list '(regexp . "\\*.*\\.po\\*"))
                                        ;(add-to-list 'frames-only-mode-kill-frame-when-buffer-killed-buffer-list "*Scratch*")

(elpy-enable)

(use-package lsp-mode
  :ensure nil
  :commands lsp
  :custom
  ;; what to use when checking on-save. "check" is default, I prefer clippy
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  ;; enable / disable the hints as you prefer:
  (lsp-inlay-hint-enable t)
  ;; These are optional configurations. See https://emacs-lsp.github.io/lsp-mode/page/lsp-rust-analyzer/#lsp-rust-analyzer-display-chaining-hints for a full list
  (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
  (lsp-rust-analyzer-display-chaining-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil)
  (lsp-rust-analyzer-display-closure-return-type-hints t)
  (lsp-rust-analyzer-display-parameter-hints nil)
  (lsp-rust-analyzer-display-reborrow-hints nil)
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)

  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

                                        ; <https://github.com/emacs-lsp/lsp-mode/issues/2583>
                                        ;(use-package lsp-mode
                                        ;  :hook (python-mode . lsp-deferred)
                                        ;  :commands (lsp lsp-deferred))

(use-package lsp-ui
  :ensure nil
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable nil))

(use-package company
  :ensure nil
  :custom
  (company-idle-delay 0.5) ;; how long to wait until popup
  ;; (company-begin-commands nil) ;; uncomment to disable popup
  :config
  (progn
    (add-hook 'after-init-hook 'global-company-mode))
  :bind
  (:map company-active-map
	("C-n". company-select-next)
	("C-p". company-select-previous)
	("M-<". company-select-first)
	("M->". company-select-last)))

(use-package yasnippet
  :ensure
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode))

(use-package flycheck :ensure)

                                        ;(use-package flycheck
                                        ;  :hook (prog-mode . flycheck-mode))

                                        ;(use-package company
                                        ;  :hook (prog-mode . company-mode)
                                        ;  :config
                                        ;   (global-company-mode))

                                        ;(use-package lsp-mode
                                        ;  :commands lsp
                                        ;  :custom
                                        ;  (lsp-rust-analyzer-cargo-watch-command "clippy"))

(require 'lsp-mode)
					;(with-eval-after-load 'lsp-rust
					;    (require 'dap-cpptools))
                                        ; (require 'dap-java) ; Requires eclipse jdt server--see lsp-install-server

(require 'dap-python)
;; if you installed debugpy, you need to set this
;; https://github.com/emacs-lsp/dap-mode/issues/306
(setq dap-python-debugger 'debugpy)

(with-eval-after-load 'dap-mode
                                        ; general
  (dap-tooltip-mode 1)
  (tooltip-mode 1)
  (dap-ui-controls-mode 1)

  ;;    ;; Make sure that terminal programs open a term for I/O in an Emacs buffer
  ;;    (setq dap-default-terminal-kind "integrated")
  ;;    (dap-auto-configure-mode +1)
  )

(use-package org-roam
  :ensure f
  :custom
  (org-roam-directory "~/doc/org-roam")
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert))
  :config
  (org-roam-setup))
(org-roam-db-autosync-mode)

					; Entry: M-x slime or M-x slime-connect
(require 'slime)
(slime-setup '(slime-fancy slime-quicklisp slime-asdf))

(setq gc-cons-threshold (* 100 1024 1024))
(setq gcmh-high-cons-threshold (* 1024 1024 1024))
(setq gcmh-idle-delay-factor 20)
(setq jit-lock-defer-time 0.05)
;; for lsp-mode
(setq read-process-output-max (* 1024 1024))
(setq package-native-compile t)

                                        ;(with-eval-after-load 'rustic
                                        ;  ; https://github.com/brotzeit/rustic/issues/211
                                        ;  (setq lsp-rust-analyzer-macro-expansion-method 'lsp-rust-analyzer-macro-expansion-default)
                                        ;  )


(setq solarized-termcolors 256)
(set-terminal-parameter nil 'background-mode 'light)
(load-theme 'solarized t)
					;(enable-theme)

					; To enable bidirectional synchronization of lsp workspace folders and treemacs projects.
					; FIXME disappeared (lsp-treemacs-sync-mode 1)

					; Vendored from https://raw.githubusercontent.com/Alexander-Miller/treemacs/master/src/extra/treemacs-projectile.el
(require 'treemacs-projectile)
					;(require 'treemacs-magit)
(treemacs-display-current-project-exclusively)

(require 'back-button)

(setq treemacs-width 25) ; Adjust the width of the treemacs window as needed

(setq doc-view-resolution 300)

(setq mu4e-get-mail-command "offlineimap"
      mu4e-maildir (expand-file-name "~/Mail")
      mu4e-update-interval 180
      message-kill-buffer-on-exit t
      mu4e-headers-skip-duplicates t
      mu4e-compose-signature-auto-include nil
      mu4e-view-show-images t
      mu4e-view-show-addresses t
      mu4e-attachment-dir "~/Downloads"
      mu4e-use-fancy-chars t
      mu4e-headers-auto-update t
      message-signature-file "~/.emacs.d/.signature"
      mu4e-compose-signature-auto-include nil
      mu4e-view-prefer-html t
      mu4e-compose-in-new-frame t
      mu4e-change-filenames-when-moving t
					;message-send-mail-function 'smtpmail-send-it
      starttls-use-gnutls t
      smtpmail-stream-type 'starttls
      ;;mu4e-html2text-command "w3m -T text/html"
      )

(require 'mu4e-context)

(setq mu4e-context-policy 'pick-first)
(setq mu4e-compose-context-policy 'always-ask)
(setq mu4e-contexts
      (list
       (make-mu4e-context
	:name "scratchpost.org"
	:enter-func (lambda () (mu4e-message "Entering scratchpost.org context"))
	:leave-func (lambda () (mu4e-message "Leaving scratchpost.org context"))
	:match-func (lambda (msg)
		      (when msg
			(mu4e-message-contact-field-matches
			 msg '(:from :to :cc :bcc) "dannym@scratchpost.org")))
	:vars '((user-mail-address . "dannym@scratchpost.org")
		(user-full-name . "Danny Milosavljevic")
		(mu4e-sent-folder . "/scratchpost.org/sent")
		(mu4e-drafts-folder . "/scratchpost.org/drafts")
		(mu4e-trash-folder . "/scratchpost.org/trash")
		(mu4e-refile-folder . "/scratchpost.org/Archives")
					;(smtpmail-queue-dir . "~/.email/gmail/queue/cur")
					;(smtpmail-smtp-user . "mail@xxx.com")
					;(smtpmail-starttls-credentials . (("mail.xxx.com" 587 nil nil)))
					;(smtpmail-auth-credentials . (expand-file-name "~/.authinfo.gpg"))
					;(smtpmail-default-smtp-server . "mail.xxx.com")
					;(smtpmail-smtp-server . "mail.xxx.com")
					;(smtpmail-smtp-service . 587)
		(mu4e-get-mail-command . "offlineimap -a dannym@scratchpost.org")
		(mu4e-sent-messages-behavior . sent)
		(mu4e-maildir-shortcuts . ( ("/scratchpost.org/inbox" . ?i)
					    ("/scratchpost.org/sent" . ?s)
					    ("/scratchpost.org/trash" . ?t)
					    ("/scratchpost.org/archives" . ?a)
					    ("/scratchpost.org/drafts" . ?d)
					    ("/scratchpost.org/Apartment" . ?p)
					    ("/scratchpost.org/Learning" . ?l)
					    ("/scratchpost.org/Astronomie_Uni" . ?u)
					    ("/scratchpost.org/TU_work" . ?w)
					    ("/scratchpost.org/Incoming-Invoice" . ?v)
					    ("/scratchpost.org/Software" . ?s)
					    ("/scratchpost.org/Software/mes" . ?m)
					    ("/scratchpost.org/Software/mes/tinycc" . ?c)
					    ("/scratchpost.org/Software/Oxide" . ?o)
					    ("/scratchpost.org/Software/bootstrappable" . ?b)
					    ("/scratchpost.org/Gesundheit" . ?g)
					    ("/scratchpost.org/Social" . ?i)
					    ("/scratchpost.org/Profession" . ?f)
					    ("/scratchpost.org/Hardware" . ?h)
					    ("/scratchpost.org/Hardware/A20" . ?a)
					    ("/scratchpost.org/Science" . ?s)
					    ("/scratchpost.org/News" . ?w)))))))
					;       (make-mu4e-context
					;    :name "friendly-machines.com"
					;    :enter-func (lambda () (mu4e-message "Entering friendly-machines.com context"))
					;    :leave-func (lambda () (mu4e-message "Leaving friendly-machines.com context"))
					;    :match-func (lambda (msg)
					;              (when msg
					;            (mu4e-message-contact-field-matches
					;             msg '(:from :to :cc :bcc) "dannym@friendly-machines.com")))
					;    :vars '((user-mail-address . "dannym@friendly-machines.com")
					;        (user-full-name . "Danny Milosavljevic")
					;        (mu4e-sent-folder . "/friendly-machines.com/sent")
					;        (mu4e-drafts-folder . "/friendly-machines.com/drafts")
					;        (mu4e-trash-folder . "/friendly-machines.com/trash")
					;        (mu4e-refile-folder . "/friendly-machines.com/refile")
					;        (mu4e-get-mail-command . "offlineimap -a dannym@friendly-machines.com")
					;        (mu4e-sent-messages-behavior . sent)
					;        (mu4e-maildir-shortcuts . ( ("/friendly-machines.com/inbox" . ?i)
					;                        ))))

(setq mu4e-change-filenames-when-moving t)

(setq mu4e-view-show-images t)
(setq mu4e-view-show-addresses t)

					;(defvar my-mu4e-account-alist
					;  '(("scratchpost.org"
					;     (user-mail-address  "dannym@scratchpost.org")
					;     (user-full-name     "Danny Milosavljevic")
					;     (mu4e-sent-folder   "/scratchpost.org/sent")
					;     (mu4e-drafts-folder "/scratchpost.org/drafts")
					;     (mu4e-trash-folder  "/scratchpost.org/trash")
					;     (mu4e-refile-folder "/scratchpost.org/archive"))
					;    ("friendly-machines.com"
					;     (user-mail-address  "dannym@friendly-machines.com")
					;     (mu4e-sent-folder   "/friendly-machines.com/sent")
					;     (mu4e-drafts-folder "/friendly-machines.com/drafts")
					;     (mu4e-trash-folder  "/friendly-machines.com/trash")
					;     (mu4e-refile-folder "/friendly-machines.com/archives"))))

					;(setq mu4e-user-mail-address-list
					;      (mapcar (lambda (account) (cadr (assq 'user-mail-address account)))
					;              my-mu4e-account-alist))

					; offlineimap offlineimap --dry-run -a dannym@scratchpost.org
(setq mu4e-context-policy 'pick-first)
(setq mu4e-compose-context-policy 'ask)

(setq org-mu4e-convert-to-html t)
(use-package org-mime
  :ensure t)

;;; Bookmarks
(setq mu4e-bookmarks
      `(
	("flag:unread AND NOT flag:trashed" "Unread messages" ?u)
	("flag:unread" "new messages" ?n)
        ("date:today..now" "Today's messages" ?t)
        ("date:7d..now" "Last 7 days" ?w)
        ("mime:image/*" "Messages with images" ?p)
        ))

(use-package vertico
  :ensure f
  :config
  (vertico-mode))

(use-package marginalia
  :ensure f
  :config
  (vertico-mode))

					;(use-package orderless
					;  :ensure f
					;  :config
					;  (setq completion-styles 'orderless))

(use-package magit
  :ensure f)

(use-package forge
  :ensure f
  :after magit)

                                        ;(use-package doom-modeline
                                        ;  :ensure f
                                        ;  :init (doom-modeline-mode 1)
                                        ;  :custom ((doom-modeline-height 15)))

(use-package which-key
  :ensure f
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.2))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(require 'format-all)

                                        ; not sure what that is (add-hook 'prog-mode-hook #'format-all-ensure-formatter)

(add-hook 'prog-mode-hook #'format-all-ensure-formatter)
(add-hook 'prog-mode-hook #'format-all-mode)

                                        ;(add-hook 'rustic-mode-hook #'format-all-ensure-formatter)
                                        ;(add-hook 'rustic-mode-hook #'format-all-mode)

                                        ;(add-hook 'mmm-mode-hook
                                        ;          (lambda ()
                                        ;            (set-face-background 'mmm-default-submode-face "#fafafa")))

(add-hook 'mmm-mode-hook
          (lambda ()
            (set-face-background 'mmm-default-submode-face nil)))

(use-package popper
  :ensure t ; or :straight t
  :bind (("C-`"   . popper-toggle)
         ("M-`"   . popper-cycle)
         ("C-M-`" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$"
          "\\*Async Shell Command\\*"
          help-mode
          compilation-mode))
  (popper-mode +1)
  (popper-echo-mode +1))

;; pinentry
(defvar epa-pinentry-mode)
(setq epa-pinentry-mode 'loopback)

;; Match eshell, shell, term and/or vterm buffers
;; Usually need both name and major mode
(setq popper-reference-buffers
      (append popper-reference-buffers
              '("^\\*eshell.*\\*$" eshell-mode ;eshell as a popup
                "^\\*shell.*\\*$"  shell-mode  ;shell as a popup
                "^\\*term.*\\*$"   term-mode   ;term as a popup
                "^\\*vterm.*\\*$"  vterm-mode  ;vterm as a popup
                )))

(load "auctex.el" nil t t)
                                        ;(load "preview-latex.el" nil t t)
(require 'auctex)

(autoload 'maxima-mode "maxima" "Maxima mode" t)
(autoload 'imaxima "imaxima" "Frontend for maxima with Image support" t)
(autoload 'maxima "maxima" "Maxima interaction" t)
(autoload 'imath-mode "imath" "Imath mode for math formula input" t)
(setq imaxima-use-maxima-mode-flag t)
(add-to-list 'auto-mode-alist '("\\.ma[cx]\\'" . maxima-mode))

;; Avoid problems with our shell
(with-eval-after-load 'tramp '(setenv "SHELL" "/bin/sh"))

(defun lsp-booster--advice-json-parse (old-fn &rest args)
  "Try to parse bytecode instead of json."
  (or
   (when (equal (following-char) ?#)
     (let ((bytecode (read (current-buffer))))
       (when (byte-code-function-p bytecode)
         (funcall bytecode))))
   (apply old-fn args)))
(advice-add (if (progn (require 'json)
                       (fboundp 'json-parse-buffer))
                'json-parse-buffer
              'json-read)
            :around
            #'lsp-booster--advice-json-parse)
(defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
  "Prepend emacs-lsp-booster command to lsp CMD."
  (let ((orig-result (funcall old-fn cmd test?)))
    (if (and (not test?)                             ;; for check lsp-server-present?
             (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
             lsp-use-plists
             (not (functionp 'json-rpc-connection))  ;; native json-rpc
             (executable-find "emacs-lsp-booster"))
        (progn
          (message "Using emacs-lsp-booster for %s!" orig-result)
          (cons "emacs-lsp-booster" orig-result))
      orig-result)))
(advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)

                                        ;(use-package exec-path-from-shell
                                        ;  :ensure f
                                        ;  :config
                                        ;  (dolist (var '("LSP_USE_PLISTS"))
                                        ;	(add-to-list 'exec-path-from-shell-variables var))
                                        ;  (when (memq window-system '(mac ns x))
                                        ;	(exec-path-from-shell-initialize)))

(setq lsp-tex-server 'digestif)
(setq TeX-electric-sub-and-superscript t)
(setq TeX-fold-mode t)

                                        ;(add-hook LaTeX-mode-hook #'xenops-mode)

(require 'mpv)
(load "~/.emacs.d/custom.el" t)

(setq envrc-debug t)
					; as late as possible:
(envrc-global-mode)

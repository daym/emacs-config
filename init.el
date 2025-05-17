;; -*- lexical-binding: t -*-

                                        ;(customize-set-variable 'lsp-treemacs-theme "Iconless")

(require 'nerd-icons)

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
                                        ;(setq-default indent-tabs-mode nil)

(setq tab-always-indent 'complete)
                                        ; <https://github.com/thread314/intuitive-tab-line-mode>
;(global-tab-line-mode 1)

(require 'lsp-treemacs)

(tool-bar-mode -1)

(global-prettify-symbols-mode 1)

;;; CUA mode

(cua-mode t) ; replaced by wakib-keys
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour
(define-key global-map (kbd "C-y") #'undo-redo)

;;; Virtual word wrapping

(setq-default word-wrap t)

;;; Packages

(require 'package)
(package-initialize)

(use-package rust-mode
  :custom
  (rust-format-on-save t))

(use-package projectile
  :config
  (projectile-mode +1))

(use-package pyvenv
  :ensure nil
  :config
  (pyvenv-mode nil))

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

                                        ; '(cua-mode t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LaTeX-command "lualatex -shell-escape")
 '(LaTeX-electric-left-right-brace t)
 '(TeX-engine 'luatex)
 '(back-button-no-wrap t)
 '(buffer-env-safe-files
   '(("/home/dannym/src/guix/manifest.scm" . "0b387290e9851813debd81b6e3aa5099f0f17fad1fade821ca1f0928262e56c4")
     ("/home/dannym/src/latex-ex/manifest.scm" . "5200b8ce405410acc7ad0e4baf5bfaa85b0160bff5815265a305bdc9a7fb70ed")))
 '(column-number-mode t)
 '(debbugs-browse-url-regexp
   "^https?://\\(debbugs\\.gnu\\.org\\|bugs\\.gnu\\.org\\|issues.guix.gnu.org\\)/\\(cgi/bugreport\\.cgi\\?bug=\\)?\\([[:digit:]]+\\)$")
 '(delete-by-moving-to-trash t)
 '(dtrt-indent-global-mode t)
 '(elfeed-feeds
   '("https://the-dam.org/rss.xml"
     ("http://planet.emacslife.com/atom.xml" emacs)
     "https://lwn.net/headlines/rss" "https://subscribe.fivefilters.org/?url=http%3A%2F%2Fftr.fivefilters.net%2Fmakefulltextfeed.php%3Furl%3Dhttps%253A%252F%252Fhnrss.org%252Ffrontpage%26max%3D3%26links%3Dpreserve" "https://subscribe.fivefilters.org/?url=http%3A%2F%2Fftr.fivefilters.net%2Fmakefulltextfeed.php%3Furl%3Dhttps%253A%252F%252Fwww.nature.com%252Fnmat%252Fcurrent_issue%252Frss%252F%26max%3D3%26links%3Dpreserve" "https://subscribe.fivefilters.org/?url=http%3A%2F%2Fftr.fivefilters.net%2Fmakefulltextfeed.php%3Furl%3Dhttps%253A%252F%252Fwww.nature.com%252Fnphys%252Fcurrent_issue%252Frss%252F%26max%3D3%26links%3Dpreserve" "https://semianalysis.substack.com/feed" "https://slow-journalism.com/blog/feed" "http://ftr.fivefilters.net/makefulltextfeed.php?url=https%3A%2F%2Ffeeds.arstechnica.com%2Farstechnica%2Ffeatures&max=3"))
 '(format-all-debug nil)
 '(format-all-show-errors 'errors)
 '(frame-background-mode 'light)
 '(grep-command "rg -nS --no-heading ")
 '(ignored-local-variable-values
   '((eval with-eval-after-load 'git-commit
           (add-to-list 'git-commit-trailers "Change-Id"))
     (eval progn
           (require 'lisp-mode)
           (defun emacs27-lisp-fill-paragraph
               (&optional justify)
             (interactive "P")
             (or
              (fill-comment-paragraph justify)
              (let
                  ((paragraph-start
                    (concat paragraph-start "\\|\\s-*\\([(;\"]\\|\\s-:\\|`(\\|#'(\\)"))
                   (paragraph-separate
                    (concat paragraph-separate "\\|\\s-*\".*[,\\.]$"))
                   (fill-column
                    (if
                        (and
                         (integerp emacs-lisp-docstring-fill-column)
                         (derived-mode-p 'emacs-lisp-mode))
                        emacs-lisp-docstring-fill-column fill-column)))
                (fill-paragraph justify))
              t))
           (setq-local fill-paragraph-function #'emacs27-lisp-fill-paragraph))
     (geiser-repl-per-project-p . t)
     (eval with-eval-after-load 'yasnippet
           (let
               ((guix-yasnippets
                 (expand-file-name "etc/snippets/yas"
                                   (locate-dominating-file default-directory ".dir-locals.el"))))
             (unless
                 (member guix-yasnippets yas-snippet-dirs)
               (add-to-list 'yas-snippet-dirs guix-yasnippets)
               (yas-reload-all))))
     (eval with-eval-after-load 'tempel
           (if
               (stringp tempel-path)
               (setq tempel-path
                     (list tempel-path)))
           (let
               ((guix-tempel-snippets
                 (concat
                  (expand-file-name "etc/snippets/tempel"
                                    (locate-dominating-file default-directory ".dir-locals.el"))
                  "/*.eld")))
             (unless
                 (member guix-tempel-snippets tempel-path)
               (add-to-list 'tempel-path guix-tempel-snippets))))
     (eval setq-local guix-directory
           (locate-dominating-file default-directory ".dir-locals.el"))
     (eval add-to-list 'completion-ignored-extensions ".go")
     (eval modify-syntax-entry 43 "'")
     (eval modify-syntax-entry 36 "'")
     (eval modify-syntax-entry 126 "'")
     (geiser-guile-binary "guix" "repl")
     (geiser-insert-actual-lambda)))
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(kiwix-default-browser-function 'eww-browse-url)
 '(kiwix-server-type 'kiwix-serve-local)
 '(kiwix-zim-dir "~/.local/zim")
 '(large-file-warning-threshold 100000000)
 '(line-move-visual nil)
 '(lsp-rust-analyzer-rustc-source
   "/usr/local/rustup/toolchains/nightly-2024-08-03-x86_64-unknown-linux-musl/lib/rustlib/rustc-src/rust/compiler/rustc/Cargo.toml")
 '(lsp-treemacs-theme "Iconless")
 '(mediainfo-mode-file-regexp
   "\\.\\(?:3gp\\|a\\(?:iff\\|vi\\)\\|flac\\|jpg\\|jpeg\\|png\\|gif\\|m\\(?:4a\\|kv\\|ov\\|p[34g]\\)\\|o\\(?:gg\\|pus\\)\\|vob\\|w\\(?:av\\|ebm\\|mv\\)\\)\\'")
 '(mouse-autoselect-window t)
 '(mu4e-compose-switch nil)
 '(org-export-exclude-tags '("confidential"))
 '(org-export-select-tags '("public"))
 '(org-format-latex-options
   '(:foreground default :background default :scale 0.5 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers
                 ("begin" "$1" "$" "$$" "\\(" "\\[")))
 '(org-id-link-to-org-use-id 'use-existing)
 '(org-latex-packages-alist
   '(("" "braket" t nil)
     ("" "esint" t nil)
     ("" "units" t nil)
     ("" "unicode-math" t nil)))
 '(org-msg-convert-citation t)
 '(org-msg-greeting-fmt "Hello%s,")
 '(org-msg-posting-style nil)
 '(org-noter-always-create-frame nil)
 '(org-noter-auto-save-last-location t)
 '(org-noter-notes-search-path '("~/doc/org-roam"))
 '(org-preview-latex-default-process 'dvisvgm)
 '(org-replace-disputed-keys t)
 '(org-startup-folded 'content)
 '(org-startup-with-inline-images t)
 '(org-sticky-header-always-show-header t)
 '(org-sticky-header-full-path 'reversed)
 '(org-support-shift-select t)
 '(package-selected-packages
   '(dired-launch lv concurrent org-mime org-noter org-pdftools back-button magit-popup eat flycheck-rust typescript-mode go-mode git-timemachine web-mode rainbow-delimiters geiser-guile flycheck-guile clojure-mode envrc shackle vertico pkg-info rustic magit-svn magit-gerrit agda2-mode tramp find-file-in-project lsp-ui consult embark pg finalize org-roam eval-in-repl eval-in-repl-slime slime-company ts async ement crdt gptel smartparens inheritenv buffer-env ob-async discover-my-major))
 '(read-mail-command 'mu4e)
 '(spacious-padding-subtle-mode-line t)
 '(spacious-padding-widths
   '(:internal-border-width 0 :header-line-width 4 :mode-line-width 6 :tab-width 5 :right-divider-width 10 :scroll-bar-width 8 :fringe-width 12))
 '(tab-line-close-tab-function 'kill-buffer)
 '(tool-bar-style 'image)
 '(vertico-preselect 'prompt)
 '(xref-search-program 'ripgrep))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Noto Sans Mono" :foundry "GOOG" :slant normal :weight regular :height 110 :width normal))))
 '(fixed-pitch ((t (:family "Noto Mono"))))
 '(lsp-ui-sideline-global ((t (:family "Dijkstra Italic" :italic t :weight regular :height 0.8))))
 '(mode-line-active ((t (:font "Noto Sans 8"))))
 '(mode-line-inactive ((t (:font "Noto Sans 8"))))
 '(org-table ((t (:foreground "#2aa198" :family "Atkinson Hyperlegible"))))
 '(tab-line ((t (:height 0.9 :foreground "black" :background "grey85" :inherit variable-pitch)))))

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
                     ;(mhtml-mode . html-ts-mode) ; isn't found
                     (java-mode . java-ts-mode)
                     (javascript-mode . js-ts-mode)
                     (js-json-mode . json-ts-mode)
                                        ; no redirect--so I can use C-M-x. (python-mode . python-ts-mode)
                                        ;(rust-mode . rust-ts-mode)
                     (typescript-mode . tsx-ts-mode) ; or typescript-ts-mode
					;(js-mode . js-ts-mode)
                     (yaml-mode . yaml-ts-mode)))
    (add-to-list 'major-mode-remap-alist mapping))

  :config
  (setq treesit-extra-load-path (list "~/.guix-home/profile/lib/tree-sitter/"))
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
    :hook ( ;(python-ts-mode . combobulate-mode)
           (js-ts-mode . combobulate-mode)
           (css-ts-mode . combobulate-mode)
					;(html-ts-mode . combobulate-mode)
           (yaml-ts-mode . combobulate-mode)
           (typescript-ts-mode . combobulate-mode)
           (tsx-ts-mode . combobulate-mode)
           (rust . combobulate-mode))
    ;; Amend this to the directory where you keep Combobulate's source
    ;; code.
    :load-path ("~/.emacs.d/combobulate")))

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

					; TODO: html-mode-hook which un-awfuls <mi> etc
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
                                        ;(add-to-list 'auto-mode-alist '("\\.vue\\'" . web-mode))  ; moved to custom.el

(add-to-list 'auto-mode-alist '("\\.jl" . julia-snail-mode))
(add-to-list 'auto-mode-alist '("\\.rs" . rustic-mode))
                                        ; automatic (add-to-list 'auto-mode-alist '("\\.R" . ess-mode))
(add-to-list 'auto-mode-alist '("\\.cs" . csharp-mode))
(add-to-list 'auto-mode-alist '("\\.js" . js2-mode))
                                        ;(add-to-list 'auto-mode-alist '("\\.ts" . typescript-mode)) ; or combobulate-typescript-mode
                                        ;(add-to-list 'auto-mode-alist '("\\.rs" . rust-ts-mode))

                                        ;(add-to-list 'frames-only-mode-kill-frame-when-buffer-killed-buffer-list '(regexp . "\\*.*\\.po\\*"))
                                        ;(add-to-list 'frames-only-mode-kill-frame-when-buffer-killed-buffer-list "*Scratch*")

(add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-view-mode))
(add-to-list 'auto-mode-alist '("\\.PDF\\'" . pdf-view-mode))
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
(add-to-list 'auto-mode-alist '("\\.c\\'" . c-ts-mode))
(add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-ts-mode))
(add-to-list 'auto-mode-alist '("\\.cc\\'" . c++-ts-mode))
(add-to-list 'auto-mode-alist '("\\.ixx\\'" . c++-ts-mode))

(require 'dap-python)
                                        ;(elpy-enable)

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
  (lsp-enable-suggest-server-download nil)
  :config
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
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
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-show-with-mouse t))

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


(require 'solarized-theme)
(setq solarized-termcolors 256)
(set-terminal-parameter nil 'background-mode 'light)
                                        ;(require 'solarized-theme)
                                        ; wrong solarized :P
                                        ;(solarized-create-theme-file-with-palette 'light 'solarized-solarized-light
                                        ;  '("#002b36" "#fdf6e3"
                                        ;    "#b58900" "#cb4b16" "#dc322f" "#d33682" "#6c71c4" "#268bd2" "#2aa198" "#859900"))

                                        ;(load-theme 'solarized-solarized-light t)
(load-theme 'solarized t)
					;(enable-theme)

					; To enable bidirectional synchronization of lsp workspace folders and treemacs projects.
					; FIXME disappeared (lsp-treemacs-sync-mode 1)

					;(require 'treemacs-magit)
(treemacs-display-current-project-exclusively)

(setq treemacs-width 25) ; Adjust the width of the treemacs window as needed

                                        ; bad
(setq doc-view-resolution 300)
(require 'pdf-tools)
                                        ;(use-package saveplace-pdf-view
                                        ;  :after pdf-tools
                                        ;  :config
                                        ;  (add-hook 'pdf-view-mode-hook 'pdf-view-restore-mode))
(require 'bookmark)
(require 'saveplace-pdf-view)
(save-place-mode 1)

;; Die, Doc-View-mode! die!
                                        ;(defalias 'doc-view-mode #'pdf-view-mode)

(use-package org-mime
  :ensure t)

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

                                        ;(use-package forge
                                        ;  :ensure f
                                        ;  :after magit)

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

(defun my/eshell-hook ()
  "Set up eshell hook for completions."
  (interactive)
  (setq-local completion-styles '(basic partial-completion))
                                        ;(setq-local corfu-auto t)
                                        ;?! (corfu-mode) or company
                                        ;(setq-local completion-at-point-functions
                                        ;            (list (cape-capf-super
                                        ;                   #'pcomplete-completions-at-point
                                        ;                   #'cape-history)))
  (define-key eshell-hist-mode-map (kbd "M-r") #'consult-history))

(use-package eshell
  :config
                                        ;(setq eshell-scroll-to-bottom-on-input t)
  (setq-local tab-always-indent 'complete)
  (setq eshell-history-size 100000)
  (setq eshell-save-history-on-exit t) ;; Enable history saving on exit
  (setq eshell-hist-ignoredups t) ;; Ignore duplicates
  :hook
  (eshell-mode . my/eshell-hook))


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


;; This ensures that pressing Enter will insert a new line and indent it.
                                        ;(global-set-key (kbd "RET") #'newline-and-indent)

;; Indentation based on the indentation of the previous non-blank line.
                                        ;(setq-default indent-line-function #'indent-relative-first-indent-point)

;; In modes such as `text-mode', calling `newline-and-indent' multiple times
;; removes the indentation. The following fixes the issue and ensures that text
;; is properly indented using `indent-relative' or
;; `indent-relative-first-indent-point'.
                                        ;(setq-default indent-line-ignored-functions '())

                                        ;The outline-indent.el Emacs package provides a minor mode that enables code folding based on indentation levels for various
                                        ;indentation-based text files, such as YAML, Python, and any other indented text files.

;;In addition to code folding, outline-indent allows moving indented subtrees up and down, promoting and demoting sections to adjust indentation levels, customizing the ellipsis, and inserting a new line with the same indentation level as the current line, among other features.
(use-package outline-indent
  :ensure f
  :commands (outline-indent-minor-mode
             outline-indent-insert-heading)
  :hook ((yaml-mode . outline-indent-minor-mode)
         (yaml-ts-mode . outline-indent-minor-mode)
         (python-mode . outline-indent-minor-mode)
         (python-ts-mode . outline-indent-minor-mode))
  :custom
  (outline-indent-ellipsis " ▼ "))

;; Python
(add-hook 'python-mode-hook #'outline-indent-minor-mode)
(add-hook 'python-ts-mode-hook #'outline-indent-minor-mode)

;; YAML
(add-hook 'yaml-mode-hook #'outline-indent-minor-mode)
(add-hook 'yaml-ts-mode-hook #'outline-indent-minor-mode)

;; The dtrt-indent provides an Emacs minor mode that detects the original indentation offset used in source code files and automatically adjusts Emacs settings accordingly, making it easier to edit files created with different indentation styles.
                                        ;(use-package dtrt-indent
                                        ;  :ensure t
                                        ;  :commands (dtrt-indent-global-mode
                                        ;             dtrt-indent-mode
                                        ;             dtrt-indent-adapt
                                        ;             dtrt-indent-undo
                                        ;             dtrt-indent-diagnosis
                                        ;             dtrt-indent-highlight)
                                        ;  :config
                                        ;  (dtrt-indent-global-mode))

(require 'mpv)
                                        ;(require 'howm) ; not right now

(load (locate-user-emacs-file "custom.el")
      :no-error-if-file-is-missing)
(load (locate-user-emacs-file "email.el")
      :no-error-if-file-is-missing)
                                        ;(load (locate-user-emacs-file "git-protected-branches.el")
                                        ;      :no-error-if-file-is-missing)
(load (locate-user-emacs-file "git-commit-message.el")
      :no-error-if-file-is-missing)
(load (locate-user-emacs-file "autoresize.el")
      :no-error-if-file-is-missing)
(load (locate-user-emacs-file "wolfram.el")
      :no-error-if-file-is-missing)
                                        ;(load (locate-user-emacs-file "straico.el")
                                        ;       :no-error-if-file-is-missing)
(load (locate-user-emacs-file "mcphas.el")
      :no-error-if-file-is-missing)
(load (locate-user-emacs-file "ada.el")
      :no-error-if-file-is-missing)

;; Otherwise half the icons are from the wrong set.
(treemacs-refresh)

(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)                 ; optional

                                        ;(setq envrc-debug t)
					; as late as possible:
                                        ;(envrc-global-mode)
(add-hook 'hack-local-variables-hook #'buffer-env-update)
(add-hook 'comint-mode-hook #'buffer-env-update)

(recentf-mode 1)
(setq recentf-max-menu-items 25)

;; -*- lexical-binding: t -*-

;;; Code:

;; See <https://github.com/meedstrom/org-node/issues/98#issuecomment-2900747119>.
;; This causes abbreviate-file-name to cache the (correct) homedir as a regexp.
(abbreviate-file-name "~")

(add-hook 'comint-mode-hook #'capf-autosuggest-mode)

;; That's actually kinda annoying?  Company should be enough.
;; Maybe set it up so I have to type at least one character somehow?
;; Note: Emacs 30 has completion-preview-mode built-in !!!
(add-hook 'eshell-mode-hook #'capf-autosuggest-mode)
                                        ;(setq capf-autosuggest-minimum-input 1) ; does not exist

                                        ; "Failed to define function popper-toggle"
                                        ;(use-package popper
                                        ;   :init
                                        ;   (setq popper-reference-buffers
                                        ;     '("\\*eshell.*"
                                        ;        flymake-diagnostics-buffer-mode
                                        ;        help-mode
                                        ;        compilation-mode))
                                        ;   (popper-mode 1)
                                        ;   (popper-echo-mode 1)
                                        ;   :custom
                                        ;   (popper-window-height 15))
                                        ;(bind-key* (kbd "C-;") #'popper-toggle)

(require 'org-protocol)
(require 'window-tool-bar)
                                        ;(setq-default header-line-format `(:eval (window-tool-bar-string)))

;; <https://github.com/chaosemer/window-tool-bar/issues/33>
                                        ;(global-unset-key (kbd "<tool-bar> <S-back-button>"))
                                        ;(global-unset-key (kbd "<tool-bar> <S-forward-button>"))

(add-to-list 'image-load-path (expand-file-name "~/.emacs.d/icons"))

                                        ;(prefer-coding-system 'utf-8)
                                        ;(set-default-coding-systems 'utf-8)
                                        ;(set-terminal-coding-system 'utf-8)
                                        ;(set-keyboard-coding-system 'utf-8)
                                        ;(set-selection-coding-system 'utf-8)
                                        ;(set-file-name-coding-system 'utf-8)
                                        ;(set-clipboard-coding-system 'utf-8)
                                        ; ;(set-w32-system-coding-system 'utf-8)
                                        ;(set-buffer-file-coding-system 'utf-8)

(defun my-media-text-handler (mime-type data)
  (insert (decode-coding-string data 'utf-8)))

                                        ;(defun my-smart-yank (&optional arg)
                                        ;  "Intelligent yank that handles both text and media content."
                                        ;  (interactive "*P")
                                        ;  (if (and (gui-backend-selection-exists-p 'CLIPBOARD)
                                        ;           (let ((types (gui-backend-selection-supported-formats)))
                                        ;             (seq-find (lambda (type)
                                        ;                        (string-match-p "image/" type))
                                        ;                      types)))
                                        ;      (yank-media)
                                        ;    (yank arg)))
(global-set-key [remap yank] #'yank-media)

;; Allow pasting regular text using yank-media.
(setq-default yank-media--registered-handlers
              '(("text/plain;charset=utf-8" . my-media-text-handler)))
                                        ;(defun original-yank (&optional arg)
                                        ;  (yank arg))
(defun yank (&optional arg)
  (yank-media))

                                        ;(setq interprogram-paste-function (lambda () nil))

(defun my-permanent-tool-bar-items ()
  "Add permanent items to tool bar."
  (tool-bar-add-item "ripgrep"
                     #'consult-ripgrep
                     'consult-ripgrep
                     :label "consult-ripgrep"
                     :help "Consult ripgrep...")
  (tool-bar-add-item "embark-act"
                     #'embark-act
                     'embark-act
                     :label "embark-act"
                     :help "Embark act")
  (tool-bar-add-item "magit"
                     #'magit
                     'magit
                     :label "magit"
                     :help "Magit (git)")
  (tool-bar-add-item "org-store-link"
                     #'org-store-link
                     'org-store-link
                     :label "org-store-link"
                     :help "Store Org link")
                                        ;    (define-key-after tool-bar-map [separator-2] menu-bar-separator)
                                        ; Subsumed by org-node-find for my workflow!
                                        ;(tool-bar-add-item "org-capture"
                                        ;                   #'org-capture
                                        ;                   'org-capture :label "org-capture"
                                        ;                   :help "Capture Org node...")
  (tool-bar-add-item "org-capture"
                     #'org-node-find
                     'org-node-find
                     :label "org-node-find"
                     :help "Find or make Org node...")
  (tool-bar-add-item "org-node-grep"
                     #'org-node-grep
                     'org-node-grep
                     :label "org-node-grep"
                     :help "Grep Org node...")
  (tool-bar-add-item "org-agenda"
                     #'org-agenda
                     'org-agenda
                     :label "org-agenda"
                     :help "Show Org agenda...")
  nil)

(defun merge-permanent-toolbar-items ()
  "Add permanent items to tool bar."
  (my-permanent-tool-bar-items))

(add-hook 'after-init-hook #'merge-permanent-toolbar-items)
(merge-permanent-toolbar-items)
                                        ;(setq-default tool-bar-map (merge-permanent-toolbar-items))

                                        ;(add-hook 'after-change-major-mode-hook #'merge-permanent-toolbar-items)
                                        ;(add-hook 'pre-redisplay-functions #'merge-permanent-toolbar-items-w) ; nil 'local ; overkill
                                        ;(add-hook 'info-mode-hook #'merge-permanent-toolbar-items)

(add-hook 'org-mode-hook 'variable-pitch-mode)
(add-hook 'rustic-mode-hook 'variable-pitch-mode)
                                        ;  (add-hook 'rust-ts-mode-hook 'variable-pitch-mode)
(add-hook 'treemacs-mode-hook 'variable-pitch-mode)
(add-hook 'nxml-mode-hook 'variable-pitch-mode)
                                        ;(add-hook 'emacs-lisp-mode-hook 'variable-pitch-mode)
(add-hook 'js-mode-hook 'variable-pitch-mode)
(add-hook 'css-mode-hook 'variable-pitch-mode)
(add-hook 'html-mode-hook 'variable-pitch-mode)
(add-hook 'mhtml-mode-hook 'variable-pitch-mode)
(add-hook 'python-mode-hook 'variable-pitch-mode)
                                        ;(dolist (mode '(scheme-mode-hook term-mode-hook))  ; org-mode-hook term-mode-hook eshell-mode-hook treemacs-mode-hook
                                        ;  (add-hook mode
                                        ;    (lambda ()
                                        ;      (display-line-numbers-mode 0))))

                                        ; Nope. (add-hook 'scheme-mode-hook 'variable-pitch-mode)

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
(add-hook 'prog-mode-hook 'comment-tags-mode)

(use-package spacious-padding
  :config
  (spacious-padding-mode 1)
  ;; TODO on frame hook
  (custom-set-faces
   '(mode-line-active ((t (:font "Noto Sans 8"))))
   '(mode-line-inactive ((t (:font "Noto Sans 8"))))))

                                        ;(custom-set-faces
                                        ;       '(tab-line-tab-current ((t (:box (:line-width 1 :style released-button))

(require 'eshell)
(require 'em-unix)

;; You've GOT to be kidding me: "If initial-buffer-choice is non-nil, then if you specify any files on the command line, Emacs still visits them, but does not display them initially."
                                        ;(setq initial-buffer-choice
                                        ;      (lambda ()
                                        ;        (eshell t)))

;; The ~/.config/autostart/emacs.desktop (emacs --daemon) for some reason doesn't have the environment variables set in ~/.bash_profile .
;; I use gdm autologin.  That uses /run/current-system/profile/share/wayland-sessions/sway.desktop and that calls sway WITHOUT a shell.
;; Sway config has: exec --no-startup-id bash --login -c 'exec dex --autostart --environment i3'
;; Sway has .local/bin in PATH
;; Emacs --daemon has .local/bin in PATH
                                        ;(setenv "PATH" (concat (getenv "PATH") ":/sw/bin"))
                                        ;(setq exec-path (append exec-path '("/sw/bin")))

;; Custom "e" command in eshell
(defun eshell/e (&rest args)
  "Open one or more files in Emacs, similar to the `find-file' function.  ARGS will be evaluated by eshell."
  (eshell-eval-using-options
   "e" args
   '((?f "file" nil nil "file")
     (?h "help" nil nil "help"))
   (if (and (not args) (not eshell-current-argument))
       (error "Usage: e FILE [FILE2 ...]")
     (dolist (file (or args (list eshell-current-argument)))
       (with-current-buffer (find-file-noselect file)
         (switch-to-buffer (current-buffer)))))))
(put 'eshell/e 'eshell-no-numeric-conversions t)

(defun eshell/nd (args)
  "Create a directory (and its parents) if they don't exist.
Warn if the directory already exists.  ARGS will be evaluated by eshell."
  (eshell-eval-using-options
   "nd" args
   '((?v "verbose" nil verbose-flag "verbose output")
     (?h "help" nil nil "show this usage information"))
   (let ((dir (car args)))
     (progn
       (if (file-exists-p dir)
           (message "Directory already exists: %s" dir)
         (progn
           (make-directory dir t)
           (if verbose-flag
               (message "Created directory: %s" dir))))
       (eshell/cd dir)))))

(put 'eshell/nd 'eshell-no-numeric-conversions t)

;;; Keybindings

(global-unset-key (kbd "<f10>"))

(global-set-key (kbd "<mouse-8>") 'back-button-global-backward)
(global-set-key (kbd "<mouse-9>") 'back-button-global-forward)
(global-set-key (kbd "M-<Left>") 'back-button-global-backward)
(global-set-key (kbd "M-<Right>") 'back-button-global-forward)

(with-eval-after-load 'nov
  (define-key nov-mode-map (kbd "<mouse-8>") #'nov-history-back)
  (define-key nov-mode-map (kbd "<mouse-9>") #'nov-history-forward)
  (define-key nov-mode-map (kbd "M-<Left>") #'nov-history-back)
  (define-key nov-mode-map (kbd "M-<Right>") #'nov-history-forward))

(global-set-key (kbd "C-a") 'mark-whole-buffer)
(global-set-key (kbd "<Search>") 'consult-line)
(with-eval-after-load 'pdf-tools
  (define-key pdf-view-mode-map (kbd "<Search>") #'pdf-occur)
  ;; Will probably not work again:
  (define-key pdf-view-mode-map (kbd "C-f") #'pdf-occur))

                                        ; pixel-scroll-interpolate-down
                                        ;(define-key isearch-mode-map (kbd "<next>") #'isearch-repeat-forward)
                                        ; pixel-scroll-interpolate-?
                                        ;(define-key isearch-mode-map (kbd "<prior>") #'isearch-repeat-backward))

(global-set-key (kbd "M-<Search>") #'consult-ripgrep)


                                        ;(global-set-key (kbd "<Launch1>") 'async-shell-command)
(global-set-key (kbd "<Launch1>") 'embark-act)


(global-set-key (kbd "<f2>") 'save-buffer)
                                        ; TODO: restart
                                        ;(global-set-key (kbd "C-<f2>") ')

(global-set-key (kbd "<f3>") 'find-file)
(global-set-key (kbd "C-<f3>") 'find-file-at-point)
(global-set-key (kbd "M-<f3>") 'ff-get-other-file)

(defun define-debug-key (mode-map key gud-command &optional dap-command)
  "In MODE-MAP, bind KEY to GUD-COMMAND when GUD is active, or DAP-COMMAND when DAP is active.
KEY should be like (key \"<f8>\").
GUD-COMMAND and DAP-COMMAND should be quoted command symbols."
  (define-key mode-map key
              (lambda ()
                (interactive)
                (cond
                 ((bound-and-true-p gud-minor-mode)
                  (command-execute gud-command))
                 ((bound-and-true-p dap-tooltip-mode)
                  (and dap-command (command-execute dap-command)))
                 (t
                  (message "No debugger active"))))))

                                        ; TODO: <f12>: Compiler messages


(eval-after-load 'prog-mode
  '(progn
     (define-debug-key prog-mode-map (kbd "C-<f7>") #'gud-eval #'dap-eval)
     (define-debug-key prog-mode-map (kbd "C-<f3>") #'gud-where #'dap-ui-stackframe)
     (define-debug-key prog-mode-map (kbd "C-<f2>") #'gud-kill #'dap-disconnect)
     (define-debug-key prog-mode-map (kbd "C-<f8>") #'gud-break #'dap-breakpoint-toggle)
     (define-debug-key prog-mode-map (kbd "C-b") #'gud-break #'dap-breakpoint-toggle) ; Chromium
     (define-debug-key prog-mode-map (kbd "<f5>") #'gud-break #'dap-breakpoint-toggle)
     (define-debug-key prog-mode-map (kbd "<f11>") #'gud-step #'dap-step-in)
     (define-debug-key prog-mode-map (kbd "<f10>") #'gud-next #'dap-next)
     (define-debug-key prog-mode-map (kbd "C-<f11>") #'gud-stepi)
     (define-debug-key prog-mode-map (kbd "C-<f10>") #'gud-nexti)
                                        ;(define-debug-key prog-mode-map (kbd "s-<f11>") #'gud-finish #'dap-step-out)
     (define-debug-key prog-mode-map (kbd "<f8>") #'gud-cont #'dap-continue)
     (define-debug-key prog-mode-map (kbd "C-<f11>") #'gud-watch #'dap-ui-expressions-add)
                                        ;(define-debug-key prog-mode-map (kbd "<?>") #'gud-up)
                                        ;(define-debug-key prog-mode-map (kbd "<?>") #'gud-down)
                                        ;(define-debug-key prog-mode-map (kbd "<?>") #'gud-refresh)
                                        ;(define-debug-key prog-mode-map (kbd "<?>") #'gud-print)
                                        ;(define-debug-key prog-mode-map (kbd "<?>") #'gud-tbreak)
                                        ;(define-debug-key prog-mode-map (kbd "<?>") #'gud-kill)
     (define-debug-key prog-mode-map (kbd "C-<f4>") #'gud-jump)
     (define-debug-key prog-mode-map (kbd "<?>") #'gud-remove)
     (define-debug-key prog-mode-map (kbd "<f4>") #'gud-until) ; dap-debug-restart-frame
                                        ;(define-debug-key prog-mode-map (kbd "<?>") #'gud-goto-traceback)
                                        ;(define-debug-key prog-mode-map (kbd "<?>") #'gud-list-breakpoints)
                                        ;gud-sentinel gud-statement-end
                                        ;(define-debug-key prog-mode-map (kbd "<?>") #'gud-pp)

                                        ; TODO: Shift-F7 step to next source line!
                                        ;(global-set-key (kbd "<f7>") 'gud-step)
                                        ;(global-set-key (kbd "<f8>") 'gud-next)
                                        ; user! ; gud-remove ?
     ))

(eval-after-load 'dap-mode
  '(progn
     ;; Basic debugging
     ;; FIXME need to disable the menu opening then!
                                        ;(define-key dap-mode-map (kbd "C-c C-k") 'dap-disconnect)

     ;; Breakpoint related
                                        ;(define-key dap-mode-map (kbd "C-c C-b c") 'dap-breakpoint-condition)
                                        ;(define-key dap-mode-map (kbd "C-c C-b h") 'dap-breakpoint-hit-condition)
                                        ;(define-key dap-mode-map (kbd "C-c C-b l") 'dap-breakpoint-log-message)
                                        ;(define-key dap-mode-map (kbd "C-c C-b d") 'dap-breakpoint-delete)
                                        ;(define-key dap-mode-map (kbd "C-c C-b D") 'dap-breakpoint-delete-all)

     ;; Debug windows
                                        ;(define-key dap-mode-map (kbd "C-c C-r") 'dap-ui-repl)
                                        ;(define-key dap-mode-map (kbd "C-c C-l") 'dap-ui-locals)
                                        ;(define-key dap-mode-map (kbd "C-c C-b") 'dap-ui-breakpoints)
                                        ;(define-key dap-mode-map (kbd "C-c C-t") 'dap-ui-sessions)
                                        ;(define-key dap-mode-map (kbd "C-c C-v") 'dap-eval)
                                        ;(define-key dap-mode-map (kbd "C-c C-w") 'dap-ui-expressions)
                                        ;(define-key dap-mode-map (kbd "C-c C-i") 'dap-step-in)
                                        ;(define-key dap-mode-map (kbd "C-c C-u") 'dap-up-stack-frame)
                                        ;(define-key dap-mode-map (kbd "C-c C-d") 'dap-down-stack-frame)

     ;; Additional commands
                                        ;(define-key dap-mode-map (kbd "C-c C-p") 'dap-debug-restart-frame)
                                        ;(define-key dap-mode-map (kbd "C-c C-a") 'dap-ui-inspect)
                                        ;(define-key dap-mode-map (kbd "C-c C-m") 'dap-mouse-eval)
                                        ;(define-key dap-mode-map (kbd "C-c C-e e") 'dap-eval-thing-at-point)
                                        ;(define-key dap-mode-map (kbd "C-c C-e r") 'dap-eval-region)
                                        ;(define-key dap-mode-map (kbd "C-c C-h") 'dap-hydra)

     ;; Launch/terminate
                                        ;(define-key dap-mode-map (kbd "C-c C-x") 'dap-start-debugging)
                                        ;(define-key dap-mode-map (kbd "C-c C-q") 'dap-disconnect)
                                        ;(define-key dap-mode-map (kbd "C-c C-g") 'dap-debug-restart)
     ))

                                        ; paredit was older than combobulate
                                        ; next sibling; via combobulate
(global-set-key (kbd "C-M-<down>") 'forward-sexp)

                                        ;(eval-after-load 'emacs-lisp-mode
                                        ;  '(progn
;; overwrites down-mouse-1 that would do mouse-buffer-menu
(define-key emacs-lisp-mode-map (kbd "C-<down-mouse-1>") #'xref-find-definitions-at-mouse)
                                        ;))

;; FIXME also C-<f8> maybe
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
(global-set-key (kbd "<f9>") #'projectile-compile-project)
                                        ; FIXME: Alt+F9 recompile all, Shift-F9 same
(global-set-key (kbd "C-<f9>") #'projectile-run-project)
(global-set-key (kbd "C-S-<f9>") #'projectile-test-project)
(global-set-key (kbd "M-<f9>") #'compile) ; for mcphas
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

(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-S-s") 'save-buffer)

;; keys for moving to prev/next code section (Form Feed; ^L)
(global-set-key (kbd "<C-M-prior>") 'backward-page) ; Ctrl+Alt+PageUp
(global-set-key (kbd "<C-M-next>") 'forward-page)   ; Ctrl+Alt+PageDown

(keymap-set global-map "C-M-s" #'org-node-series-dispatch)

(require 'smartparens-config)
;;; Execute sp-beginning-of-sexp. I bound it to C-M-a.
;;; Execute sp-end-of-sexp. I bound it to C-M-e.
;;; Execute sp-down-sexp. I bound it to C-down.
;;; Execute sp-up-sexp. I bound it to C-up.
;;; Execute sp-backward-down-sexp. I bound it to M-down.
;;; Execute sp-backward-up-sexp. I bound it to M-up.
;;; Execute sp-forward-sexp. I bound it to C-M-f.
;;; Execute sp-backward-sexp. I bound it to C-M-b.
;;; Execute sp-next-sexp. I bound it to C-M-n.
;;; Execute sp-previous-sexp. I bound it to C-M-p.
;;; Execute sp-backward-symbol. I bound it to C-S-b.
;;; Execute sp-forward-symbol. I bound it to C-S-f.
;;; Pressing C-M-Space or ESC C-Space followed by [ will make the whole region become surrounded by matching [ and ]. It also applies to keys like (, {, ", ', *, _

;; Those conflict with move to previous word, move to next word, respectively.
;; They have alternative bindings anyway--so kill these here.
                                        ;(eval-after-load "paredit"
                                        ;  '(progn
                                        ;     (define-key paredit-mode-map (kbd "C-<left>") 'paredit-backward) ; alternative: C-} ; new alternative: M-b
                                        ;     (define-key paredit-mode-map (kbd "C-<right>") 'paredit-forward) ; alternative: C-) ; new alternative: M-f
                                        ;     (define-key paredit-mode-map (kbd "C-<up>") 'paredit-backward-up)
                                        ;     (define-key paredit-mode-map (kbd "C-<down>") 'paredit-backward-down)))

;;; ======================

(require 'pulsar)
(setq pulsar-face 'pulsar-blue)
;; Pulse when minibuffer shows up
(add-hook 'minibuffer-setup-hook #'pulsar-pulse-line)

;; Improve contrast
(add-to-list 'default-frame-alist '(foreground-color . "#505050"))

(require 'treemacs-nerd-icons)
(treemacs-load-theme "nerd-icons")

(setq display-buffer-alist
      '(
        ("\\*messages.*"
         (display-buffer-in-side-window)
         (window-width . 0.25) ;; Side window takes up 1/4th of the screen
         (side . right)
         )
        ("^\\*Projectile.*"
         ((display-buffer-in-side-window)
          (window-height . 0.25)))
        ("^\\*scratch.*"
         (display-buffer-in-side-window)
         (window-width . 0.25) ;; Side window takes up 1/4th of the screen
         (side . right))
        ("\\*Warnings.*"
         (display-buffer-reuse-window display-buffer-in-side-window)
         (window-width . 0.25) ;; Side window takes up 1/4th of the screen
         (side . right)
         )
        ("\\*.*[Ss]hell.*\\*" ; especially "*Async Shell Command*"
         (display-buffer-same-window)
         (reusable-frames . visible))
        ))

;; Don't bother user with emacs warnings
(add-to-list 'display-buffer-alist
             '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
               (display-buffer-no-window)
               (allow-no-window . t)))

(require 'mh-e) ; mail

(add-to-list 'treesit-extra-load-path "/home/dannym/.guix-home/profile/lib/tree-sitter/")

                                        ; argh
(setq python-shell-completion-native-disabled-interpreters '("python3" "pypy3"))

                                        ;(setq vc-handled-backends '("git"))


                                        ;(lsp-register-client
                                        ; (make-lsp-client :new-connection (lsp-tramp-connection "clangd")
                                        ;                  :major-modes '(c-mode c++-mode)
                                        ;                  :remote? t
                                        ;                  :server-id 'clangd-remote))

;; Consider setting this to a negative number
                                        ;(setq mouse-autoselect-window t)


(setq visible-bell t)

(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp/"))
(load (expand-file-name "~/.emacs.d/lisp/unbreak.el"))
(load "modern-fringes.el")

                                        ; Vendored from https://raw.githubusercontent.com/Alexander-Miller/treemacs/master/src/extra/treemacs-projectile.el
(require 'treemacs-projectile)

;(add-hook 'scheme-mode-hook 'guix-devel-mode)

                                        ;(straight-use-package
                                        ;  '(nano :type git :host github :repo "rougier/nano-emacs"))

                                        ;(setq nano-font-size 10)

                                        ;(add-to-list 'load-path (expand-file-name "~/.emacs.d/nano-emacs/"))
                                        ;(load "nano.el")

                                        ; Too new version requires svg-tag-mode which is dumb
                                        ;(add-to-list 'load-path (expand-file-name "~/.emacs.d/notebook-mode/"))
                                        ;(load "notebook.el")

                                        ;(setq org-ellipsis "▾")

                                        ; See https://magit.vc/manual/ghub/Storing-a-Token.html
(use-package auth-source
  :defer t
  :config
  (setq auth-sources
        (list (expand-file-name ".authinfo.gpg" user-emacs-directory))))

;; Assuming the Guix checkout is in ~/src/guix.
;; Yasnippet configuration
(with-eval-after-load 'yasnippet
  (add-to-list 'yas-snippet-dirs (expand-file-name "~/src/guix/etc/snippets/yas")))
;; Tempel configuration
(with-eval-after-load 'tempel
  ;; Ensure tempel-path is a list -- it may also be a string.
  (unless (listp 'tempel-path)
    (setq tempel-path (list tempel-path)))
  (add-to-list 'tempel-path (expand-file-name "~/src/guix/etc/snippets/tempel/*"))) ; FIXME check

;; Assuming the Guix checkout is in ~/src/guix.
(load-file (expand-file-name "~/src/guix/etc/copyright.el"))

                                        ; super-g
(global-set-key (kbd "s-g") 'guix)

                                        ; Doesn't work.
                                        ;(add-hook 'shell-mode-hook 'guix-prettify-mode)
                                        ;(add-hook 'dired-mode-hook 'guix-prettify-mode)

(add-to-list 'load-path (expand-file-name "~/.emacs.d/combobulate/"))
(load "combobulate.el")

;; Free version; see also https://github.com/WebFreak001/code-debug supports both gdb and lldb in case someone is interested.
                                        ; "gdb -i dap" is enough for DAP mode so no idea what all this is for here.
(add-to-list 'load-path (expand-file-name "~/.emacs.d/dap-gdb/"))
(load "dap-gdb.el")

(add-to-list 'load-path (expand-file-name "~/.emacs.d/ssass-mode/"))
(load "ssass-mode.el")

(require 'bar-cursor)
(bar-cursor-mode 1)

(add-to-list 'load-path (expand-file-name "~/.emacs.d/elfeed-tube/"))
(require 'elfeed-tube)
(require 'elfeed-tube-mpv)

                                        ; Scheme IDE

(setq geiser-mode-auto-p nil)
(require 'arei)

                                        ; Latex

(add-to-list 'load-path (expand-file-name "~/.emacs.d/xenops/lisp/"))
(require 'xenops)
(setq-default xenops-math-image-scale-factor 0.6)
                                        ; (setq-default xenops-reveal-on-entry t) ; unreveal in org mode is buggy
(require 'ob-python) ; optional
(add-hook 'LaTeX-mode-hook #'xenops-mode)
(add-hook 'org-mode-hook #'xenops-mode)

                                        ; (add-hook 'org-mode-hook #'xenops-mode) ; fucks up begin_src and end_src (lowercase) handling maybe

                                        ; Undefined
                                        ;(latex +cdlatex +latexmk +lsp)
                                        ;(latex +lsp)

(require 'wakib-keys)
(wakib-keys 1)
(define-key wakib-keys-overriding-map (kbd "C-f") #'consult-line) ; Note: someone overwrites this.

(load (expand-file-name "~/.emacs.d/lisp/copilot.el"))
(global-set-key (kbd "C-.") 'gptel-send)

(require 'opascal)

                                        ; TODO: Python ∈

(add-hook 'c-ts-mode-hook
          (lambda ()
            "Prettify C"
            (push '("<=" . ?≤) prettify-symbols-alist)
            (push '(">=" . ?≥) prettify-symbols-alist)
            (push '("==" . "⩵") prettify-symbols-alist) ; or ≟
            (push '("=" . "≝") prettify-symbols-alist) ; or ≔
            (push '("&&" . "∧") prettify-symbols-alist)
            (push '("||" . "∨") prettify-symbols-alist)
            (push '("!" . "¬") prettify-symbols-alist)
            (push '("!=" . "≠") prettify-symbols-alist)
            (push '("void" . "⊥") prettify-symbols-alist)
            (push '("->" . "→") prettify-symbols-alist)
                                        ;(push '("for" . "∀") prettify-symbols-alist)
            (push '("*" . "·") prettify-symbols-alist)))

(add-hook 'c++-ts-mode-hook
          (lambda ()
            "Prettify C++"
            (push '("<=" . ?≤) prettify-symbols-alist)
            (push '(">=" . ?≥) prettify-symbols-alist)
            (push '("==" . "⩵") prettify-symbols-alist)
            (push '("=" . "≝") prettify-symbols-alist) ; or ≔
            (push '("&&" . "∧") prettify-symbols-alist)
            (push '("||" . "∨") prettify-symbols-alist)
            (push '("!" . "¬") prettify-symbols-alist)
            (push '("void" . "⊥") prettify-symbols-alist)
            (push '("->" . "→") prettify-symbols-alist)
                                        ;(push '("for" . "∀") prettify-symbols-alist)
            (push '("*" . "·") prettify-symbols-alist)))

(add-hook 'opascal-mode-hook
          (lambda ()
            "Prettify Object Pascal"
            (push '("begin" . ?{) prettify-symbols-alist)
            (push '("end" . ?}) prettify-symbols-alist)
            (push '(":=" . "≝") prettify-symbols-alist) ; or ≔
            ))

(add-hook 'rust-mode-hook
          (lambda ()
            "Prettify Rust more"
            (push '("==" . "⩵") prettify-symbols-alist) ; or ≟
            (push '("=" . "≝") prettify-symbols-alist) ; or ≔
            (push '("&&" . "∧") prettify-symbols-alist)
            (push '("||" . "∨") prettify-symbols-alist)
            (push '("!" . "¬") prettify-symbols-alist)
            (push '("!=" . "≠") prettify-symbols-alist)
                                        ;(push '("->" . "→") prettify-symbols-alist)
                                        ;(push '("for" . "∀") prettify-symbols-alist)
            (push '("*" . "·") prettify-symbols-alist)))

(require 'python-django)

                                        ; requires markchars.el which is not in Guix
                                        ;(markchars-global-mode)
                                        ;(defface markchars-heavy
                                        ;  '((t :underline "magenta"))
                                        ;  "Heavy face for `markchars-mode' char marking."
                                        ;  :group 'markchars)

                                        ;(setq org-agenda-deadline-lead-time 7) ;; Notify 7 days before deadlines
                                        ;(setq org-agenda-scheduled-lead-time 1) ;; Notify 1 day before scheduled items
                                        ;   <2021-07-14 Wed 14:40 -1d>  with lead time; https://github.com/orgzly/orgzly-android/issues/636

;; When a TODO is set to a done state, record a timestamp
(setq org-log-done 'time)

;; Follow the links
(setq org-return-follows-link  t)

;; Associate all org files with org mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

;; Make the indentation look nicer
(add-hook 'org-mode-hook 'org-indent-mode)
(add-hook 'org-mode-hook 'org-sticky-header-mode) ; would kill window tool bar; so I could set org-sticky-header-prefix (to 'window-tool-bar-string); TODO: org-sticky-header--indent-prefix

                                        ; TODO: Maybe (bind-key* "C-M-&" 'override-global-mode)
(with-eval-after-load 'org
  ;; Was org-metaleft (Calls ‘org-do-promote’, ‘org-outdent-item’ or ‘org-table-move-column’, depending on context.  Otherwise, calls the Emacs default ‘backward-word’).
  (define-key org-mode-map [M-left] nil)
  ;; Was org-metaright. (Calls ‘org-do-demote’, ‘org-indent-item’, ‘org-table-move-column’, ‘org-indent-drawer’ or ‘org-indent-block’. Otherwise calls the Emacs default `forward-word').
  ;(define-key org-mode-map [M-right] nil)
;;; There's also S-M-<Up> but that's maybe okay.
  ;; Was org-shiftcontrolleft (switches to the previous todo set).  I want to be able to mark things so fuck off.
  (define-key org-mode-map [C-S-left] nil)
  ;; Was org-shiftcontrolright (switches to the next todo set).
  (define-key org-mode-map [C-S-right] nil)
  ;; Was (org-shiftup &optional ARG).  Context dependent.  Call ‘org-timestamp-up’ or ‘org-priority-up’, or `org-previous-item’, or ‘org-table-move-cell-up’.
  (define-key org-mode-map [S-up] nil)
  ;; Was (org-shiftdown &optional ARG).  Context dependent.
  (define-key org-mode-map [S-down] nil)
)

;; Hide the markers so you just see bold text as BOLD-TEXT and not *BOLD-TEXT*
(setq org-hide-emphasis-markers t)

                                        ;(setq org-roam-node-display-template
                                        ;      (concat "${title:*} " (propertize "${tags}" 'face 'org-tag)))

;; Wrap the lines in org mode so that things are easier to read ; FIXME how to make tables work correctly then?
                                        ;(add-hook 'org-mode-hook 'visual-line-mode)
(add-hook 'text-mode-hook #'visual-line-mode)
(with-current-buffer "*Messages*"
  (visual-line-mode))
                                        ;(with-current-buffer "*scratch*"
                                        ;  (visual-line-mode))

;;; Make elfeed store-link store the link to the ORIGINAL article, not to the feed.

(org-link-set-parameters "elfeed"
                         :follow #'elfeed-link-open
                         :store #'elfeed-link-store-link
                         :export #'elfeed-link-export-link)

(defun elfeed-link-export-link (link desc format _protocol)
  "Export `org-mode' `elfeed' LINK with DESC for FORMAT."
  (if (string-match "\\([^#]+\\)#\\(.+\\)" link)
      (if-let* ((entry
                 (elfeed-db-get-entry
                  (cons (match-string 1 link)
                        (match-string 2 link))))
                (url
                 (elfeed-entry-link entry))
                (title
                 (elfeed-entry-title entry)))
          (pcase format
            ('html (format "<a href=\"%s\">%s</a>" url desc))
            ('md (format "[%s](%s)" desc url))
            ('latex (format "\\href{%s}{%s}" url desc))
            ('texinfo (format "@uref{%s,%s}" url desc))
            (_ (format "%s (%s)" desc url)))
        (format "%s (%s)" desc url))
    (format "%s (%s)" desc link)))

;;; Pandoc

(setq pandoc-data-dir (expand-file-name "~/.emacs.d/etc/pandoc/"))

(defun efe/export-to-docx ()
  "Output to docx using `pandoc-mode'."
  (interactive)
  (pandoc-mode)
  (execute-kbd-macro (kbd "C-c / O W d b b r"))
  (setq pandoc-mode nil))

(defun insert-html-blog-template ()
  "Insert HTML_HEAD lines at the first empty line and html code at the end of the buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((empty-line (progn (re-search-forward "^$" nil t) (point))))
      (goto-char empty-line)
      (insert "\n#+HTML_HEAD: <link rel=\"webmention\" href=\"https://webmention.io/ismailefe.org/webmention\" />\n")
      (insert "#+HTML_HEAD: <link rel=\"stylesheet\" type=\"text/css\" href=\"/templates/style.css\" />\n")
      (insert "#+HTML_HEAD: <link rel=\"apple-touch-icon\" sizes=\"180x180\" href=\"/favicon/apple-touch-icon.png\">\n")
      (insert "#+HTML_HEAD: <link rel=\"icon\" type=\"image/png\" sizes=\"32x32\" href=\"/favicon/favicon-32x32.png\">\n")
      (insert "#+HTML_HEAD: <link rel=\"icon\" type=\"image/png\" sizes=\"16x16\" href=\"/favicon/favicon-16x16.png\">\n")
      (insert "#+HTML_HEAD: <link rel=\"manifest\" href=\"/favicon/site.webmanifest\">\n")))
  (goto-char (point-max))
  (insert "\n\n")
  (insert "#+BEGIN_EXPORT html\n")
  (insert "<div class=\"bottom-header\">\n")
  (insert "  <a class=\"bottom-header-link\" href=\"/\">Home</a>\n")
  (insert "  <a href=\"mailto:ismailefetop@gmail.com\" class=\"bottom-header-link\">Mail Me</a>\n")
  (insert "  <a class=\"bottom-header-link\" href=\"/feed.xml\" target=\"_blank\">RSS</a>\n")
  (insert "  <a class=\"bottom-header-link\" href=\"https://github.com/Ektaynot/ismailefe_org\" target=\"_blank\">Source</a>\n")
  (insert "</div>\n")
  (insert "<div class=\"firechickenwebring\">\n")
  (insert "  <a href=\"https://firechicken.club/efe/prev\">←</a>\n")
  (insert "  <a href=\"https://firechicken.club\">🔥⁠🐓</a>\n")
  (insert "  <a href=\"https://firechicken.club/efe/next\">→</a>\n")
  (insert "</div>\n")
  (insert "#+END_EXPORT\n"))

                                        ; With these snippets added, all I have to do is run the 'org-pandoc-export-to-html5' function in Emacs (this function comes with ox-pandoc). This creates a html file with the same name as the original file.

(require 'request)
(require 'dom)
                                        ;(require 'simpleclip)

(defun google-search-first-result (query)
  "Search Google for QUERY and return the first search result."
  (interactive "sSearch Query: ")
  (let ((url (concat "https://www.google.com/search?q=" (url-hexify-string query)))
        (user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"))
    (request url
      :headers `(("User-Agent" . ,user-agent))
      :parser 'buffer-string
      :success (cl-function
                (lambda (&key data &allow-other-keys)
                  (let* ((dom (with-temp-buffer
                                (insert data)
                                (libxml-parse-html-region (point-min) (point-max))))
                         (first-result (car (dom-by-class dom "tF2Cxc"))))
                    (if first-result
                        (let ((link (dom-attr (car (dom-by-tag first-result 'a)) 'href)))
                          (when link
                            (message "First search result: %s" link)
                                        ;(simpleclip-set-contents link)
                            (kill-new link)
                            ))
                      (message "No results found."))))))))

(defun google-first-result-at-point ()
  "Get the first url from a Google search from the word at point."
  (interactive)
  (let ((word (thing-at-point 'word)))
    (if word
        (google-search-first-result word)
      (message "No word found at point."))))

(setq scroll-preserve-screen-position nil)

                                        ; Unbreak image scrolling

                                        ;(add-to-list 'load-path (expand-file-name "~/.emacs.d/iscroll/"))
                                        ;(require 'iscroll)
                                        ; Note: Only enable in text modes, not prog modes
                                        ;(iscroll-mode)

                                        ;(add-hook 'elfeed-show-mode-hook 'iscroll-mode)

;;; Org mode

(setq org-todo-keywords
      '((sequence "TODO(t)" "PLANNING(p)" "IN-PROGRESS(i@/!)" "VERIFYING(v!)" "BLOCKED(b@)"  "|" "DONE(d!)" "OBE(o@!)" "WONT-DO(w@/!)" )))

(setq my-org-header (concat "#+DATE: %<%Y-%m-%d>
#+AUTHOR: " user-full-name "
#+FILETAGS: :internal:

%?"))

(defun transform-square-brackets-to-round-ones (string-to-transform)
  "Convert `[' into `(' and `]' into `)' of STRING-TO-TRANSFORM.  That's especially for arxiv."
  (concat (mapcar #'(lambda (c) (if (equal c ?\[) ?\( (if (equal c ?\]) ?\) c))) string-to-transform)))

(setq org-capture-templates
      `(("i" "Capture into ID node"
         plain (function org-node-capture-target)
         ,my-org-header
         :empty-lines-after 1)

        ("j" "Jump to ID node"
         plain (function org-node-capture-target)
         ,my-org-header
         :jump-to-captured t
         :immediate-finish t)

        ;; Sometimes handy after `org-node-insert-link' to
        ;; make a stub you plan to fill in later
        ("q" "Make quick stub ID node"
         plain (function org-node-capture-target)
         ,my-org-header
         :immediate-finish t)

        ("n" "Note"
         entry (file+headline (expand-file-name "~/doc/org/notes.org") "Random Notes")
         "** %?"
         :empty-lines 0)
        ("g" "General To-Do"
         entry (file+headline (expand-file-name "~/doc/org/todos.org") "General Tasks")
         "* TODO [#B] %?\n:Created: %T\n "
         :empty-lines 0)
        ("c" "Code To-Do" ; execute this on the line of code you want to link it to
         entry (file+headline (expand-file-name "~/doc/org/todos.org") "Code Related Tasks")
         "* TODO [#B] %?\n:Created: %T\n%i\n%a\nProposed Solution: "
         :empty-lines 0)
        ("m" "Meeting"
         entry (file+datetree (expand-file-name "~/doc/org/meetings.org"))
         "* %? :meeting:%^g \n:Created: %T\n** Attendees\n*** \n** Notes\n** Action Items\n*** TODO [#A] "
         :tree-type week
         :clock-in t
         :clock-resume t
         :empty-lines 0)

        ;; org-protocol by chrome org-capture extension.
        ("p" "Protocol" entry (file+headline ,(concat org-directory "notes.org") "Inbox") ; WTF?
         "* %^{Title}\nSource: %u, %c\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%?")
        ;; org-protocol by chrome org-capture extension.
        ("L" "Protocol Link" entry (file+headline ,(concat org-directory "notes.org") "Inbox") ; WTF?
         "* %? [[%:link][%(transform-square-brackets-to-round-ones \"%:description\")]]\nCaptured On: %U")

        ;; org-protocol-html bookmarklet.
        ("w" "Web site" entry (file "") ; or (file+olp ,(concat org-directory "inbox.org" "Web"))
         "* %a :website:\n\n%U %?\n\n%:initial")

        ))

;; Tags
(setq org-tag-alist '(
                      ;; Ticket types (exclusive)
                      (:startgroup . nil)
                      ("@bug" . ?b)
                      ("@feature" . ?u)
                      ("@spike" . ?j)
                      (:endgroup . nil)

                      ("WAITING" . ?w)
                      ("HOLD" . ?h)
                      ("CANCELLED" . ?c)
                      ("FLAGGED" . ??)

                      ;; Ticket flags
                      ("@write_future_ticket" . ?w)
                      ("@emergency" . ?e)
                      ("@research" . ?r)

                      ;; Meeting types (exclusive)
                      (:startgroup . nil)
                      ("big_sprint_review" . ?i)
                      ("cents_sprint_retro" . ?n)
                      ("dsu" . ?d)
                      ("grooming" . ?g)
                      ("sprint_retro" . ?s)
                      (:endgroup . nil)

                      ;; Code TODOs tags
                      ("QA" . ?q)
                      ("backend" . ?k)
                      ("broken_code" . ?c)
                      ("frontend" . ?f)

                      ;; Special tags
                      ("CRITICAL" . ?x)
                      ("obstacle" . ?o)

                      ;; Meeting tags
                      ("HR" . ?h)
                      ("general" . ?l)
                      ("meeting" . ?m)
                      ("misc" . ?z)
                      ("planning" . ?p)

                      ;; Work Log Tags
                      ("accomplishment" . ?a)
                      ))

;; The ones without "t" are cleared..
(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
              ("WAITING" ("WAITING" . t))
              ("HOLD" ("WAITING") ("HOLD" . t))
              (done ("WAITING") ("HOLD"))
              ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
              ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
              ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

;; Tag colors
(setq org-tag-faces
      '(("planning" . (:foreground "mediumPurple1" :weight bold))
        ("backend" . (:foreground "royalblue1" :weight bold))
        ("frontend" . (:foreground "forest green" :weight bold))
        ("QA" . (:foreground "sienna" :weight bold))
        ("meeting" . (:foreground "yellow1" :weight bold))
        ("CRITICAL" . (:foreground "red1" :weight bold))))

;; Agenda View "d"
(defun air-org-skip-subtree-if-priority (priority)
  "Skip an agenda subtree if it has a priority of PRIORITY.

  PRIORITY may be one of the characters ?A, ?B, or ?C."
  (let ((subtree-end (save-excursion (org-end-of-subtree t)))
        (pri-value (* 1000 (- org-lowest-priority priority)))
        (pri-current (org-get-priority (thing-at-point 'line t))))
    (if (= pri-value pri-current)
        subtree-end
      nil)))

(setq org-agenda-skip-deadline-if-done t)

(setq org-agenda-custom-commands
      '(
        ;; Daily Agenda & TODOs
        ("d" "Daily agenda and all TODOs"

         ;; Display items with priority A
         ((tags "PRIORITY=\"A\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "High-priority unfinished tasks:")))

          ;; View 7 days in the calendar view
          (agenda "" ((org-agenda-span 7)))

          ;; Display items with priority B (really it is view all items minus A & C)
          (alltodo ""
                   ((org-agenda-skip-function '(or (air-org-skip-subtree-if-priority ?A)
                                                   (air-org-skip-subtree-if-priority ?C)
                                                   (org-agenda-skip-if nil '(scheduled deadline))))
                    (org-agenda-overriding-header "ALL normal priority tasks:")))

          ;; Display items with pirority C
          (tags "PRIORITY=\"C\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Low-priority Unfinished tasks:")))
          )

         ;; Don't compress things (change to suite your tastes)
         ((org-agenda-compact-blocks nil)))

        ;; James's Super View
        ("j" "James's Super View"
         ((agenda "" ( (org-agenda-remove-tags t) (org-agenda-span 7)))
          (alltodo ""  (;; Remove tags to make the view cleaner
                        (org-agenda-remove-tags t)
                        (org-agenda-prefix-format "  %t  %s")
                        (org-agenda-overriding-header "CURRENT STATUS")
                        ;; Define the super agenda groups (sorts by order)
                        (org-super-agenda-groups
                         '(;; Filter where tag is CRITICAL
                           (:name "Critical Tasks"  :tag "CRITICAL" :order 0)
                           ;; Filter where TODO state is IN-PROGRESS
                           (:name "Currently Working" :todo "IN-PROGRESS" :order 1)
                           ;; Filter where TODO state is PLANNING
                           (:name "Planning Next Steps" :todo "PLANNING" :order 2 )
                           ;; Filter where TODO state is BLOCKED or where the tag is obstacle
                           (:name "Problems & Blockers" :todo "BLOCKED" :tag "obstacle" :order 3)
                           ;; Filter where tag is @write_future_ticket
                           (:name "Tickets to Create" :tag "@write_future_ticket" :order 4)
                           ;; Filter where tag is @research
                           (:name "Research Required" :tag "@research" :order 7)
                           ;; Filter where tag is meeting and priority is A (only want TODOs from meetings)
                           (:name "Meeting Action Items" :and (:tag "meeting" :priority "A") :order 8)
                           ;; Filter where state is TODO and the priority is A and the tag is not meeting
                           (:name "Other Important Items" :and (:todo "TODO" :priority "A" :not (:tag "meeting")) :order 9)
                           ;; Filter where state is TODO and priority is B
                           (:name "General Backlog" :and (:todo "TODO" :priority "B") :order 10)
                           ;; Filter where the priority is C or less (supports future lower priorities)
                           (:name "Non Critical" :priority<= "C" :order 11)
                           ;; Filter where TODO state is VERIFYING
                           (:name "Currently Being Verified" :todo "VERIFYING" :order 20)))))
          ))
        ))

;; Work around envrc and julia-snail sillyness:
;; envrc, correctly, changes the buffer-local process-environment PATH to whatever was specified in the .envrc file.
;; But then, most of the REPLs you start up don't notice the PATH change. That means that you will have the wrong Julia.
;; Therefore, every time buffer process environment is changed we update the REPL executable names.

(defun update-repl-executable-from-env (repl-config)
  "Update the REPL executable based on the current `process-environment'.
REPL-CONFIG is a cons cell where the car is the local variable and
the cdr is the executable name."
  (let ((variable-name (car repl-config))
        (executable-name (cdr repl-config)))
    (make-local-variable variable-name)
                                        ;(message (executable-find executable-name))
    (set variable-name (or (executable-find executable-name) executable-name))))

                                        ; TODO inferior-js-program-command ?
                                        ; TODO could also intercept (make-comint comint-program-command) and change comint-program-command there--but that's maybe a little magical.
(defvar repl-env-configurations
  '((julia-snail-executable . "julia")
    (inferior-lisp-program . "sbcl")
    (python-shell-interpreter . "python3")
    (geiser-guile-binary . "guile")
    (geiser-racket-binary . "racket")
    (geiser-chicken-binary . "chicken")
    (haskell-process-path-ghci . "ghci")
    (js-comint-program-command . "node"))
  "A list of REPL environment configurations.  Each item is (name of the local variable to `setq-local' . name of the executable program to search for (searched-for in PATH)).")

(defun update-repl-commands (&rest _args)
  "Update all REPL executable names for the current `process-environment'."
  (when (bound-and-true-p envrc-mode)
    (mapc 'update-repl-executable-from-env repl-env-configurations)))

(advice-add 'envrc--update :after #'update-repl-commands)

(defun get-projectile-project-root ()
  "Get the root directory of the project according to Projectile."
  (when (and (featurep 'projectile) (projectile-project-p))
    (projectile-project-root)))

(defun get-builtin-project-root ()
  "Get the root directory of the project according to Emacs' built-in `project.el'."
  (when-let ((project (project-current)))
    (project-root project)))

(defun my/ensure-line-in-file (line file-path)
  "Open FILE-PATH in a buffer and ensure that a specific LINE exists. Does not save the buffer automatically."
  (let* ((file (expand-file-name file-path))
         (buffer (find-file-noselect file)))
    (with-current-buffer buffer
      (goto-char (point-min))
      ;; Check if line exists; if not, insert it at the end
      (unless (search-forward (concat line "\n") nil t)
        (goto-char (point-max))
        (unless (bolp) (insert "\n"))  ; Ensure newline before inserting
        (insert line "\n")
        ;; Make the buffer visible for the user to review
        (switch-to-buffer-other-window buffer)
        (message "Review the changes and save the buffer if they are correct.")))))

(defun my/envrc-root-directory ()
  "Attempt to get the envrc root directory for the current buffer."
  (when (featurep 'envrc)
    (envrc--find-env-dir)))

(defun my/update-guix-shell-authorized ()
  "Ensure the current buffer's project or its directory is listed in '~/.config/guix/shell-authorized-directories'."
  (let ((project-dir (my/envrc-root-directory)))
    (when project-dir
      ;; Ensure there's no trailing slash to keep consistency in shell-authorized-directories
      (setq project-dir (directory-file-name project-dir))
      (my/ensure-line-in-file project-dir
                              (expand-file-name "~/.config/guix/shell-authorized-directories")))))

;; envrc-allow also allows `guix shell' to do its thing
(advice-add 'envrc-allow :before #'my/update-guix-shell-authorized)

(defun my-notdeft-import-web-page (url &optional ask-dir)
  "Import the web page at URL into NotDeft.
Query for the target directory if ASK-DIR is non-nil.
Interactively, query for a URL, and set ASK-DIR if a prefix
argument is given.  Choose a file name based on any document
<title>, or generate some unique name."
  (interactive "sPage URL: \nP")
  (let* ((s (shell-command-to-string
             (concat "curl --silent " (shell-quote-argument url) " | "
                     "pandoc" " -f html-native_divs-native_spans"
                     " -t org"
                     " --wrap=none --smart --normalize --standalone")))
         (title
          (and
           (string-match "^#\\+TITLE:[[:space:]]+\\(.+\\)$" s)
           (match-string 1 s))))
    (notdeft-create-file
     (and ask-dir 'ask)
     (and title `(title, title))
     "org" s)))


(defun wrap-with-global-env (func-symbol)
  "Wrap function named by FUNC-SYMBOL to ensure it uses global environment values."
  (let* ((original-func (symbol-function func-symbol))
         (is-interactive (commandp original-func))
         (interactive-form (and is-interactive (interactive-form original-func)))
         (new-func
          `(lambda (&rest args)
             ,@(when interactive-form
                 (list interactive-form))
             (let ((process-environment (default-value 'process-environment))
                   (exec-path (default-value 'exec-path)))
               (apply ',original-func args)))))
    (fset func-symbol (eval new-func))))

                                        ; TODO: https://tero.hasu.is/blog/transient-directories-in-notdeft/

(with-eval-after-load 'buffer-env
  (setq buffer-env-script-name '("manifest.scm" "environment-variables" ".env" ".envrc"))
  ;; guix failed build.
  (add-to-list 'buffer-env-command-alist
               `(,(rx "/environment-variables" eos)
                 . "set -a && >&2 . \"$1\" && env -0")))

;; Original wakib binding would save and quit emacs (using save-buffers-kill-terminal).  Who wants that?
(keymap-set wakib-keys-overriding-map "C-q" #'quoted-insert)

(use-package org-notify
  :after org
  :config
  (wrap-with-global-env #'org-notify-process))

(use-package org-node
  :after org
  :config
  (org-node-cache-mode)

  (keymap-set global-map "C-<Search>" #'org-node-find)
  (keymap-set global-map "M-<Search>" #'org-node-grep) ; Requires consult

  (add-hook 'org-mode-hook #'org-node-backlink-mode)
  (setq org-node-creation-fn #'org-capture)
  (setq org-node-alter-candidates t)

  ;; Prefer visiting node with URL in ROAM_REFS property instead of opening URL in web browser.
  (add-hook 'org-open-at-point-functions
            #'org-node-try-visit-ref-node)

  (setq org-directory (expand-file-name "~/doc/org"))
  (setq org-default-notes-file (concat org-directory "/notes.org"))


  (setq org-node-extra-id-dirs
        (list (expand-file-name "~/doc/org-roam/")))
                                        ;Do a M-x org-node-reset and see if it can find your notes now.
                                        ; Then org-id-update-id-locations

  (setq org-node-series-defs
        (list
         '("d" :name "Daily-files"
           :version 2
           :classifier (lambda (node)
                         (let ((path (org-node-get-file-path node)))
                           (when (string-search (expand-file-name "~/doc/org/daily") path) ; FIXME
                             (let ((ymd (org-node-helper-filename->ymd path)))
                               (when ymd
                                 (cons ymd path))))))
           :whereami (lambda ()
                       (org-node-helper-filename->ymd buffer-file-name))
           :prompter (lambda (key)
                       (let ((org-node-series-that-marks-calendar key))
                         (org-read-date)))
           :try-goto (lambda (item)
                       (org-node-helper-try-visit-file (cdr item)))
           :creator (lambda (sortstr key)
                      (let ((org-node-datestamp-format "")
                            (org-node-ask-directory (expand-file-name "~/doc/org/daily")))
                        (org-node-create sortstr (org-id-new) key))))

         ;; Obviously, this series works best if you have `org-node-put-created' on
         ;; `org-node-creation-hook'.
         '("a" :name "All ID-nodes by property :CREATED:"
           :version 2
           :capture "n"
           :classifier (lambda (node)
                         (let ((time (cdr (assoc "CREATED" (org-node-get-props node)))))
                           (when (and time (not (string-blank-p time)))
                             (cons time (org-node-get-id node)))))
           :whereami (lambda ()
                       (let ((time (org-entry-get nil "CREATED" t)))
                         (and time (not (string-blank-p time)) time)))
           :prompter (lambda (key)
                       (let ((series (cdr (assoc key org-node-built-series))))
                         (completing-read "Go to: " (plist-get series :sorted-items))))
           :try-goto (lambda (item)
                       (when (org-node-helper-try-goto-id (cdr item))
                         t))
           :creator (lambda (sortstr key)
                      (org-node-create sortstr (org-id-new) key)))))

                                        ;(setq tramp-verbose 9)
                                        ; (tramp-cleanup-all-connections)
                                        ; check tramp/foo* and debug tramp/foo*


;  (wrap-with-global-env #'el-job-launch)
  (wrap-with-global-env #'org-node-find)
)

(setq org-src-tab-acts-natively t)
(add-hook 'org-mode-hook #'mixed-pitch-mode)

                                        ;(add-to-list 'load-path (expand-file-name "~/.emacs.d/qemu/"))
                                        ;(require 'qemu-qmp)
                                        ;(require 'qemu-dap)

(require 'org-notify)
(org-notify-start)

                                        ; Autoinsert

(require 'autoinsert)
(auto-insert-mode t)
(setq auto-insert 'other)
(setq auto-insert-query nil)

;; Java File Template
(define-auto-insert '(".*\\.java\\'" . "Java program")
  '("Java"
    "// SPDX-License-Identifier: GPL-3.0-or-later" \n
    "/*" \n
    " * " (file-name-nondirectory (buffer-file-name)) \n
    " *" \n
    " * TODO: Describe." \n
    " */" \n
    "public class " (file-name-sans-extension (file-name-nondirectory (buffer-file-name))) " {" > \n
    "public static void main(String[] args) {" > \n
    > _ \n
    "}" > \n
    "}" > \n))

;; Vala File Template
(define-auto-insert '(".*\\.vala\\'" . "Vala program")
  '("Vala program"
    "// SPDX-License-Identifier: GPL-3.0-or-later" > \n
    "/*" > \n
    " * " (file-name-nondirectory (buffer-file-name)) > \n
    " *" > \n
    " * TODO: Describe." > \n
    " */" > \n
    "using Gtk;" > \n
    "" > \n
    "int main (string[] args) {" > \n
    "    Gtk.init (ref args);" > \n
    "    var window = new Window ();" > \n
    "    window.title = \"First GTK+ Program\";" > \n
    "    window.border_width = 10;" > \n
    "    window.window_position = WindowPosition.CENTER;" > \n
    "    window.set_default_size (350, 70);" > \n
    "    window.destroy.connect (Gtk.main_quit);" > \n
    "    var button = new Button.with_label (\"Click me!\");" > \n
    "    button.clicked.connect (() => {" > \n
    "        button.label = \"Thank you\";" > \n
    "    });" > \n
    "    window.add (button);" > \n
    "    window.show_all ();" > \n
    > _ \n
    "    Gtk.main ();" > \n
    "    return 0;" > \n
    "}" > \n))

;; Guix Package Template
(define-auto-insert '(".*\\.scm\\'" . "Guix package")
  '("Guix package"
    "; Guix package definition." \n
    "(use-modules (guix packages))" \n
    "(use-modules (guix gexp))" \n
    "(use-modules (guix build-system glib-or-gtk))" \n
    "(use-modules (guix build-system gnu))" \n
    ";(use-modules (guix build-system maven))" \n
    ";(use-modules (guix build-system node))" \n
    "(use-modules ((guix licenses) #:prefix license:))" \n
    \n
    ";(define %source-dir (getcwd))" \n
    "(define " (file-name-sans-extension (file-name-nondirectory (buffer-file-name))) "\n"
    "  (package\n"
    "    (name \"" (file-name-sans-extension (file-name-nondirectory (buffer-file-name))) "\")\n"
    "    (version \"0.1\")\n"
    "    (source " _ "(origin\n"
    "              (method url-fetch)\n"
    "              (uri (string-append \"TODO:\" name \"-\" version \".tar.gz\"))\n"
    "              (sha256 (base32 \"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\"))))\n"
    "    (build-system gnu-build-system)\n"
    "    (native-inputs (list))\n"
    "    (inputs (list))\n"
    "    (synopsis \"TODO: A brief description of the package.\")\n"
    "    (description \"TODO: A longer description of the package.\"))\n"
    "    (home-page \"TODO: url\")\n"
    "    (license #f)) ; TODO: Put license.\n"
    (file-name-sans-extension (file-name-nondirectory (buffer-file-name))) \n))

;; Guix Manifest Template
(define-auto-insert '("manifest\\.scm\\'" . "Guix manifest")
  '("Guix manifest"
    ";;; Guix manifest definition." \n
    "(specifications->manifest" \n
    " (list \"rust-analyzer\" \"ccls\" \"ocaml-lsp-server\" \"gcc-toolchain\" \"gdb\" \"rr\" \"texlive-minted\" \"texlive-latex-bin\" \"dvisvgm\" \"python-lsp-server\" \"emacs-ediprolog\" \"tidy-html\"))" \n))

(add-to-list 'load-path (expand-file-name "~/.emacs.d/kiwix.el"))
(require 'kiwix)
                                        ; duplicate
(setq kiwix-default-browser-function 'eww-browse-url)

(defun youtube-url-p (url)
  "Return t if URL points to YouTube."
  (string-match-p "https://\\(www.\\)?youtube.com\\|https://youtu.be" url))

(require 'mpv)
(defun browse-youtube-url-with-mpv (url &optional new-window)
  "Open URL using mpv.  mpv will use yt-dlp to fetch it."
  (mpv-start url "--fs")) ; was: --full-screen ?!!?!

(push '(youtube-url-p . browse-youtube-url-with-mpv) browse-url-handlers)

(defun video-url-p (url)
  "Return t if URL points to YouTube."
  (or (string-match-p ".*[.]mp4" url)
      (string-match-p ".*[.]wmv" url)))

(defun browse-video-url-with-mpv (url &optional new-window)
  "Open URL using mpv."
  (mpv-start url "--fs")) ; was: --full-screen ?!!?!

(push '(video-url-p . browse-video-url-with-mpv) browse-url-handlers)

                                        ; TODO: Use which-key instead.
                                        ;(require 'discover-my-major)
                                        ;(global-set-key (kbd "C-h C-m") 'discover-my-major)

                                        ;(setq which-key-persistent-popup t)

(add-to-list 'load-path (expand-file-name "~/.emacs.d/shr-tag-math"))
(require 'shr-tag-math)
                                        ;(add-hook 'nov-mode-hook #'xenops-mode) ; so we render <math>; unfortunately, that fucks up all the other formatting. Also, the size of the rendered images is much too big here.

(use-package emms
  :config
  (require 'emms-setup)
  (emms-all)
  (setq emms-player-list '(emms-player-mpv))
                                        ;(setq emms-browser-info-title-format "%i%n %cM")
                                        ;(setq emms-browser-playlist-info-title-format emms-browser-info-title-format)
  (setq emms-tag-editor-pipe-config
        '(("mid3iconv <file>"
           :command "mid3iconv"
           :arguments (name))))
  (require 'emms-info-libtag)
  (setq emms-info-functions '(emms-info-libtag))

  (setq emms-browser-covers #'emms-browser-cache-thumbnail)

  (require 'org-emms)
  (add-hook 'after-init-hook
            (lambda ()
              (emms-add-directory-tree (expand-file-name "~/Music")))))

(use-package mediainfo-mode
  :config
  (require 'emms)
  (setq mediainfo-mode-open-method #'emms-play-file)
  (defun my-mediainfo-setup-toolbar ()
    "Add mediainfo-specific items to the global toolbar for `mediainfo-mode'."
    (easy-menu-define mediainfo-mode-menu mediainfo-mode-map
      "Menu for mediainfo"
      '("Mediainfo"
        ["Play" mediainfo-mode-open :help "Play"]
        ))
    (let ((my-tool-bar-map (copy-keymap tool-bar-map)))  ; Start with copy of global toolbar
      (tool-bar-local-item "mpc/play" 'mediainfo-mode-open 'mediainfo-mode-open my-tool-bar-map :label "Play" :help "Play")
      ;; Making a buffer local
      (setq-local tool-bar-map my-tool-bar-map)))
  (add-hook 'mediainfo-mode-hook #'my-mediainfo-setup-toolbar)

  )

(defun elfeed-search-print-entry (entry)
  "Print ENTRY to the buffer."
  (let* ((date (elfeed-search-format-date (elfeed-entry-date entry)))
         (title (or (elfeed-meta entry :title) (elfeed-entry-title entry) ""))
         (title-faces (elfeed-search--faces (elfeed-entry-tags entry)))
         (feed (elfeed-entry-feed entry))
         (feed-title
          (when feed
            (or (elfeed-meta feed :title) (elfeed-feed-title feed))))
         (tags (mapcar #'symbol-name (elfeed-entry-tags entry)))
         (tags-str (mapconcat
                    (lambda (s) (propertize s 'face 'elfeed-search-tag-face))
                    tags ","))
         (title-width (- (window-width) 10 elfeed-search-trailing-width))
         (title-column (elfeed-format-column
                        title (elfeed-clamp
                               elfeed-search-title-min-width
                               title-width
                               elfeed-search-title-max-width)
                        :left)))
    (insert (propertize date 'face 'elfeed-search-date-face) " ")
    (insert (propertize title-column 'face title-faces 'kbd-help title) "\t")
    (when feed-title
      (insert (propertize feed-title 'face 'elfeed-search-feed-face) " "))
    (when tags
      (insert "(" tags-str ")"))))

(setq elfeed-search-print-entry-function #'elfeed-search-print-entry)

(setq gptel-backend
      (gptel-make-openai "llama-cpp"
        :stream t
        :protocol "http"
        :host "localhost:8080"
        :models '(llama)))  ; Any names, doesn't matter for Llama

(setq gptel-model 'llama)
(setq gptel-default-mode 'org-mode)

                                        ; see also org-disputed-keys for CUA mode.
                                        ;(setq org-replace-disputed-keys t)

(setq-default line-spacing 0.2) ; compromise between Rust source code and org mode
;; TODO: Scala; PHP; C++; Kotlin; Swift
(add-hook 'perl-mode-hook #'form-feed-mode)
(add-hook 'python-mode-hook #'form-feed-mode)
(add-hook 'python-ts-mode-hook #'form-feed-mode)
(add-hook 'scheme-mode-hook #'form-feed-mode)
(add-hook 'lisp-mode-hook #'form-feed-mode)
(add-hook 'fortran-mode-hook #'form-feed-mode)
                                        ;(add-hook 'js-mode-hook #'form-feed-mode)
                                        ;(add-hook 'js-ts-mode-hook #'form-feed-mode)
(add-hook 'js-base-mode-hook #'form-feed-mode)
(add-hook 'c-ts-base-mode-hook #'form-feed-mode)
(add-hook 'ruby-mode-hook #'form-feed-mode)
(add-hook 'ruby-ts-mode-hook #'form-feed-mode)
(add-hook 'typescript-mode-hook #'form-feed-mode)
(add-hook 'typescript-ts-mode-hook #'form-feed-mode)
(add-hook 'java-mode-hook #'form-feed-mode)
(add-hook 'go-mode-hook #'form-feed-mode)
(add-hook 'go-ts-mode-hook #'form-feed-mode)
(add-hook 'go-mod-ts-mode-hook #'form-feed-mode)
(add-hook 'haskell-mode-hook #'form-feed-mode)
(add-hook 'csharp-mode-hook #'form-feed-mode)
(add-hook 'csharp-ts-mode-hook #'form-feed-mode)
(add-hook 'bash-ts-mode-hook #'form-feed-mode)
(add-hook 'objc-mode-hook #'form-feed-mode)
(add-hook 'rustic-mode-hook #'form-feed-mode)
(add-hook 'rust-mode-hook #'form-feed-mode)
(add-hook 'julia-mode-hook #'form-feed-mode)
(add-hook 'org-mode-hook #'form-feed-mode) ; looks weird and sometimes disappears on save
(add-hook 'elisp-mode-hook #'form-feed-mode)
(add-hook 'elisp-mode-hook #'smartparens-mode)
(add-hook 'scheme-mode-hook #'smartparens-mode)

(use-package savehist
  :ensure nil ; it is built-in
  :hook (after-init . savehist-mode))

(use-package vertico
  :ensure nil
  :hook (after-init . vertico-mode))

;;; (setq completion-category-overrides '((file (styles basic))))
                                        ;(keymap-set vertico-map "<Return>" #'vertico-exit-input)

(use-package marginalia
  :ensure nil
  :hook (after-init . marginalia-mode))

(use-package orderless
  :ensure f
  :config
  (setq completion-styles '(orderless basic))
  (setq completion-category-defaults nil)
  (setq completion-category-overrride nil))

(global-set-key (kbd "C-c r") 'gptel-rewrite-menu)
                                        ; gptel-add-file	 C-u gptel-send	 transient menu

                                        ;(add-hook 'vala-mode-hook #'lsp)  ;; Enable LSP for Vala mode
                                        ;(add-hook 'vala-mode-hook #'lsp-mode) ; disconnects immediately

;; DAP Python Configuration
                                        ;(with-eval-after-load 'dap-mode
                                        ;  (dap-register-debug-template "Python :: Uvicorn (FastAPI)"
                                        ;    (list :type "python"
                                        ;          :request "launch"
                                        ;          :name "Python :: Uvicorn (FastAPI)"
                                        ;          :program "${workspaceFolder}/main.py"  ;; Path to your FastAPI app
                                        ;          :args ["run" "main:app" "--reload" "--host" "127.0.0.1" "--port" "8000"]
                                        ;          :env (list (cons "PYTHONPATH" "${workspaceFolder}"))
                                        ;          :justMyCode t
                                        ;          :console "integratedTerminal")))

(with-eval-after-load 'dap-mode
  (dap-register-debug-template "Python :: Attach via port 5678"
                               (list :type "python"
                                     :request "attach"
                                     :name "Python :: Attach to Running"
                                     :hostName "127.0.0.1"  ;; Address of the Python process
                                     :port 5678             ;; Port that debugpy is listening on
                                        ; :justMyCode t          ;; Optional: Only debug your code, not external libraries
                                     :env (list (cons "PYTHONPATH" "${workspaceFolder}"))
                                     :console "integratedTerminal")))

                                        ;(which-key-setup-side-window-right-bottom)
(which-key-setup-side-window-bottom)


;; Display which-key keybindings in the right margin
                                        ;(setq which-key-side-window-location 'right) ; Set position to right margin
                                        ;(setq which-key-side-window-max-width 0.25)  ; Set maximum width of the side window (25% of the frame width)
                                        ; what? (setq which-key-side-window-slot -10)        ; Slot for side window
                                        ;(setq which-key-show-early-on-C-h t)         ; Show key hints when pressing C-h
                                        ;(setq which-key-idle-delay 0.5)              ; Delay before the keybindings show up
                                        ;(setq which-key-idle-secondary-delay 0.05)   ; Delay for showing secondary hints
;; Allow the margin window to take up multiple lines
                                        ;(setq which-key-side-window-multi-line-p t)   ; Allow multi-line keybindings
                                        ;(setq which-key-side-window-max-height 0.5)    ; Max height of the side window (50% of the frame height)

                                        ;(custom-set-faces
                                        ; '(which-key-key-face ((t (:foreground "yellow")))) ; Key face color
                                        ; '(which-key-command-description-face ((t (:foreground "green")))) ; Command description color
                                        ; '(which-key-group-description-face ((t (:foreground "cyan"))))) ; Group description color

                                        ; Eventually provided by manifest.scm
(setq lsp-clients-clangd-executable "ccls")

                                        ;(setq dired-launch-default-launcher '("xdg-open"))
(setf dired-launch-extensions-map
      '(("xlsx" ("libreofficedev5.3"))
        ("odt" ("libreofficedev5.3" "abiword"))
        ("jvx" ("/home/dannym/src/mcphas/wrapper/javaview"))))

(add-hook 'python-mode-hook 'eglot-ensure)
;; Tab Completion: Use company-mode for completion, integrating company-capf with eglot.
;; elpy or something.
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-hook 'python-mode-hook 'flycheck-mode)
                                        ;(add-hook 'python-mode-hook (lambda () (add-to-list 'company-backends 'company-jedi)))

                                        ;(require 'company-lsp)
                                        ;(with-eval-after-load 'company
                                        ;                                        ; missing (push 'company-robe company-backends)
                                        ;  (push 'company-lsp company-backends));  broken

(require 'vlf-setup) ; very large files

(projectile-register-project-type 'npm '("package.json")
                                  :project-file "package.json"
				  :compile "npm run build" ; or "npm install" or something
				  :test "npm test"
				  :run "npm start"
				  :test-suffix ".test")

;; Rails & RSpec
(projectile-register-project-type 'rails-rspec '("Gemfile") ; "app" "lib" "db" "config" "spec"
                                  :project-file "Gemfile"
                                  :compile "bundle exec rails server"
                                  :src-dir "lib/"
                                  :test "bundle exec rspec"
                                  :test-dir "spec/"
                                  :test-suffix "_spec")

;; fp
(projectile-register-project-type 'fp '("fp.cfg")
                                  :project-file '("fp.cfg")
                                  :compile "fpcmake"
                                  :run "fpc" ; FIXME
                                  :test "fpc") ; FIXME

;; Lazarus
(defun projectile-lazarus-project-p (&optional dir)
  "Check if a project contains a Lazarus project marker.
When DIR is specified it checks DIR's project, otherwise
it acts on the current project."
  (projectile-verify-file-wildcard "?*.lpi" dir))

(defun my/lazarus-compile-command ()
  "Return the compile command to run."
  (let* ((root (projectile-acquire-root))
         (project-file (when root
                         (cl-loop for file in (directory-files root t "?*.lpi")
                                  when (file-exists-p file)
                                  return (file-name-nondirectory file)))))
    (concat "lazbuild " project-file)))
(defun my/lazarus-test-command ()
  "Return the test command to run."
  ;; See "FPCUnitApplication" project type.
  ;; See also <https://github.com/bbatsov/projectile/pull/1790/files>.
  "laztest")

(projectile-register-project-type 'lazarus #'projectile-lazarus-project-p
                                  :project-file '("?*.lpi")
                                  :compile #'my/lazarus-compile-command
                                  :run "lazrun" ; FIXME
                                  :test #'my/lazarus-test-command)

(setq org-agenda-files (list (expand-file-name "~/doc/org-agenda")))
(setq org-agenda-file-regexp "\\`[^.].*\\.org\\'")

(defun fix-org-indent-form-feed ()
  "I'm using `org-indent-mode' together with `form-feed-mode': `org-indent-mode' interprets the form feed character as part of the previous section and indents it--which is not what I want.  I use the form feed for sections.  So the form feed should belong to no section."
  (setq-local org-outline-regexp "\\*+ \\|\\(^\f$\\)"))

(add-hook 'org-mode-hook #'fix-org-indent-form-feed)

;; See <https://www.naiquev.in/recurring-checklists-using-org-mode-in-emacs.html>.
(use-package org-contrib
  :ensure t
  :config
  (require 'org-checklist))

;; Doesn't work. Sigh.
                                        ;(defun fix-org-indent-form-feed ()
                                        ;  (setq-local org-heading-regexp "^\\(\f?\\*+\\)\\(?: +\\(.*?\\)\\)?[ 	]*$"))
                                        ;(add-hook 'org-mode-hook #'fix-org-indent-form-feed)

;; Skip flyspell on code blocks

                                        ; See https://endlessparentheses.com/ispell-and-org-mode.html
(defun endless/org-ispell ()
  "Configure `ispell-skip-region-alist' for `org-mode'."
  (make-local-variable 'ispell-skip-region-alist)
  (add-to-list 'ispell-skip-region-alist '(org-property-drawer-re))
  (add-to-list 'ispell-skip-region-alist '("~" "~"))
  (add-to-list 'ispell-skip-region-alist '("=" "="))
  (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_SRC" . "^#\\+END_SRC")))
(add-hook 'org-mode-hook #'endless/org-ispell)

;;; Shortcuts for storing links, viewing the agenda, and starting a capture should work whereever you are.

;; "Queues" a link-to-point for later.
(define-key global-map (kbd "C-c m") 'org-store-link)
(define-key global-map (kbd "C-c a") 'org-agenda)
(define-key global-map (kbd "C-c c") 'org-capture)
                                        ; with-eval-after-load org wouldn't work!
(progn
  (define-key org-mode-map (kbd "<home>") #'move-beginning-of-line) ; ignored
  (define-key org-mode-map (kbd "<end>") #'move-end-of-line)
  (define-key org-mode-map (kbd "C-c <up>") #'org-priority-up)
  (define-key org-mode-map (kbd "C-c <down>") #'org-priority-down)
  ;; Inserts a link to a queued item into the current doc.
  (define-key org-mode-map (kbd "C-c l") #'org-insert-link)
  ;; When you want to change the level of an org item, use SMR
  (define-key org-mode-map (kbd "C-c C-g C-r") #'org-shiftmetaright))

(defun my/unset-line-move-visual ()
  "Fix up `org-mode' so it lets me have logical lines."
  (define-key org-mode-map [remap move-beginning-of-line] nil)
  (define-key org-mode-map [remap move-end-of-line] nil)
  (setq line-move-visual nil))

(add-hook 'org-mode-hook #'my/unset-line-move-visual)

                                        ;(with-eval-after-load 'web-mode ...)
(require 'lsp-mode)
(require 'lsp-volar)
(require 'lsp-vetur)
                                        ;(add-hook 'web-mode-hook #'lsp-vue-mmm-enable) ; missing.

(require 'web-mode)
(define-derived-mode genehack-vue-mode web-mode "ghVue"
  "A major mode derived from `web-mode', for editing .vue files with LSP support.")
(add-to-list 'auto-mode-alist '("\\.vue\\'" . genehack-vue-mode))
                                        ;(add-hook 'genehack-vue-mode-hook #'eglot-ensure)
(add-hook 'genehack-vue-mode-hook #'lsp)

(require 'mmm-auto)
(setq mmm-global-mode 'maybe)
(mmm-add-mode-ext-class 'html-mode "\\.php\\'" 'html-php)
                                        ; (mmm-add-mode-ext-class 'html-mode "\\.html\\'" 'html-js) ; maybe automatic?
                                        ;just modify mmm-mode-ext-classes-alist directly
                                        ;     (add-to-list 'mmm-mode-ext-classes-alist
                                        ;                  '(rpm-spec-mode "\\.spec\\'" rpm-sh))

(add-to-list 'auto-mode-alist '("\\.gp\\'" . gnuplot-mode))
(add-to-list 'auto-mode-alist '("\\.plot\\'" . gnuplot-mode))

(require 'ox-publish)
(setq org-publish-project-alist
      '(("friendly-machines.com"
         :base-directory (expand-file-name "~/doc/org-roam")
         :publishing-directory (expand-file-name "~/friendly-machines.com/www/mirror/public/blog/")
         :base-extension "org"
         :recursive t
         :publishing-function org-html-publish-to-html
         :html-doctype "html5"
         :with-toc nil
         :section-numbers nil
         :html-head "<link rel=\"stylesheet\" href=\"/css/org.css\" type=\"text/css\"/>"
         :html-preamble nil
         :html-postamble nil
         :exclude ".*-private.org\\|.*-confidential.org\\|.*-internal.org"
         :select-tags ("public"))))

(setq org-src-fontify-natively t)
(setq org-confirm-babel-evaluate nil)

;; Disambiguate /home/user/project1/main.cpp and /home/user/project2/main.cpp
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

(defun other-window-mru ()
  "Select the most recently used window on this frame."
  (interactive)
  (when-let ((mru-window
              (get-mru-window
               nil nil 'not-this-one-dummy)))
    (select-window mru-window)))

(keymap-global-set "M-o" 'other-window-mru)

(when (daemonp)
                                        ;(global-set-key (kbd "C-d C-c") 'handle-delete-frame-without-kill-emacs)
                                        ;(define-key global-map [delete-frame] 'handle-delete-frame)
  (define-key special-event-map [delete-frame]
              (lambda (event)
                (interactive "e")
                (let ((frame (posn-window (event-start event))))
                  (select-frame frame)
                  ;; (save-some-buffers) returns t on "q", nil if there's nothing to save. So that's not useful :P
                  ;; But if I press Esc, it quits and doesn't continue. Good, I guess.
                  (save-some-buffers)
                  (dolist (win (window-list frame))
                    (with-selected-window win
                      ;; You could (kill-buffer x) instead--but it would have a potential TOCTOU.
                      (kill-buffer-if-not-modified (current-buffer))))
                  (delete-frame frame)))))

;; Align the current prompt with the BOTTOM of the window.
;; That way the area before that prompt (which is the previous response) is maximized.
                                        ;(setq eshell-show-maximum-output t)

                                        ; better maybe: Add eshell-smart to eshell-modules-list
                                        ; that assumes that you keep editing existing commands because you got them wrong. I really don't. (add-to-list 'eshell-modules-list 'eshell-smart)

(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer
        (delq (current-buffer)
              (remove-if-not 'buffer-file-name (buffer-list)))))

;; Stop asking "Autosave file on local temporary directory, do you want to continue? (yes or no)" for files on remote hosts owned by root
;; This will just put the autosave files on that same host instead of localhost.
(setq auto-save-file-name-transforms nil)
                                        ; (setq tramp-auto-save-directory (expand-file-name "~/.emacs/tramp-autosave"))

;; This is an lsp-ui workaround for <https://github.com/emacs-lsp/lsp-ui/issues/607>.
(let ((areas '("mode-line" "left-margin" "left-fringe" "right-fringe" "header-line" "vertical-scroll-bar" "tool-bar" "menu-bar"))
      loc)
  (while areas
    (setq loc (pop areas))
    (global-set-key
     (kbd (concat "<" loc "> <mouse-movement>")) #'ignore)))

(defun tab-line-tab-name-format-default (tab tabs)
  "Default function to use as `tab-line-tab-name-format-function'.  Show a tooltip with the full path if you hover on TAB, and show a window tool bar inside TAB."
  (let* ((buffer-p (bufferp tab))
         (selected-p (if buffer-p
                         (eq tab (window-buffer))
                       (cdr (assq 'selected tab))))
         (name (if buffer-p
                   (funcall tab-line-tab-name-function tab tabs)
                 (cdr (assq 'name tab))))
         (face (if selected-p
                   (if (mode-line-window-selected-p)
                       'tab-line-tab-current
                     'tab-line-tab)
                 'tab-line-tab-inactive)))
    (dolist (fn tab-line-tab-face-functions)
      (setf face (funcall fn tab tabs face buffer-p selected-p)))
    (apply 'propertize
           (concat (propertize (string-replace "%" "%%" name) ;; (bug#57848)
                               'keymap tab-line-tab-map
                               'help-echo (let ((buffer (if buffer-p tab (cdr (assq 'buffer tab)))))
                                            (if selected-p
                                                (buffer-file-name buffer)
                                              (buffer-file-name buffer)))
                               ;; Don't turn mouse-1 into mouse-2 (bug#49247)
                               'follow-link 'ignore)
                   (if selected-p (window-tool-bar-string) "")
                   (or (and (or buffer-p (assq 'buffer tab) (assq 'close tab))
                            tab-line-close-button-show
                            (not (eq tab-line-close-button-show
                                     (if selected-p 'non-selected 'selected)))
                            tab-line-close-button)
                       ""))
           `(tab ,tab
                 ,@(if selected-p '(selected t))
                 face ,face
                 mouse-face tab-line-highlight))))

;; TODO: bind it to a key in magit-mode-map to make it easier.
(defun mes/pr-review-via-forge ()
  (interactive)
  (if-let* ((target (forge--browse-target))
            (url (if (stringp target) target (forge-get-url target)))
            (rev-url (pr-review-url-parse url)))
      (pr-review url)
    (user-error "No PR to review at point")))

;; FIXME: org-store-link (C-c l); "queues" links to where you are now.
;; FIXME: org-node-insert-link (C-c i)
                                        ; [[help:x]]
                                        ; [[info:blub#blah]]
;; org-id-store-link-maybe

(use-package org-noter
  :config
  ;; Your org-noter config ........
  (require 'org-noter-pdftools))

(use-package org-pdftools
  :hook (org-mode . org-pdftools-setup-link))

;; [[pdf:~/file.pdf::3][Link to page 3]]
(use-package org-noter-pdftools
  :after org-noter
  :config
  ;; Add a function to ensure precise note is inserted
  (defun org-noter-pdftools-insert-precise-note (&optional toggle-no-questions)
    (interactive "P")
    (org-noter--with-valid-session
     (let ((org-noter-insert-note-no-questions (if toggle-no-questions
                                                   (not org-noter-insert-note-no-questions)
                                                 org-noter-insert-note-no-questions))
           (org-pdftools-use-isearch-link t) ; FIXME: consult-line
           (org-pdftools-use-freepointer-annot t))
       (org-noter-insert-note (org-noter--get-precise-info)))))

  ;; fix <https://github.com/weirdNox/org-noter/pull/93/commits/f8349ae7575e599f375de1be6be2d0d5de4e6cbf>
  (defun org-noter-set-start-location (&optional arg)
    "When opening a session with this document, go to the current location.
With a prefix ARG, remove start location."
    (interactive "P")
    (org-noter--with-valid-session
     (let ((inhibit-read-only t)
           (ast (org-noter--parse-root))
           (location (org-noter--doc-approx-location (when (called-interactively-p 'any) 'interactive))))
       (with-current-buffer (org-noter--session-notes-buffer session)
         (org-with-wide-buffer
          (goto-char (org-element-property :begin ast))
          (if arg
              (org-entry-delete nil org-noter-property-note-location)
            (org-entry-put nil org-noter-property-note-location
                           (org-noter--pretty-print-location location))))))))
  (with-eval-after-load 'pdf-annot
    (add-hook 'pdf-annot-activate-handler-functions #'org-noter-pdftools-jump-to-note)))

;; Or: Switch to line mode in the Terminal menu.
                                        ;(eval-after-load 'term
                                        ;  '(define-key term-raw-map (kbd "M-x") #'execute-extended-command))


(defun org-noter--get-location-top (location)
  "Get the top coordinate given a LOCATION.
... when LOCATION has form (page top . left) or (page . top)."
  (cond
   ((org-noter-pdftools--location-p location) 0)
   ((listp (cdr location)) (cadr location))
   (t (cdr location))))

(defun org-noter--get-location-page (location)
  "Get the page number given a LOCATION of form (page top . left) or (page . top)."
  (if (listp location)
      (car location)
    location))

(defun org-noter--get-location-left (location)
  "Get the left coordinate given a LOCATION.
... when LOCATION has form (page top . left) or (page . top).  If
later form of vector is passed return 0."
  (cond
   ((org-noter-pdftools--location-p location) 0)
   ((listp (cdr location))
    (if (listp (cddr location))
        (caddr location)
      (cddr location)))
   (t 0)))

;; based on <http://emacsredux.com/blog/2013/04/03/delete-file-and-buffer/>
(defun delete-file-and-buffer ()
  "Kill the current buffer and delete the file it was visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if filename
        (if (y-or-n-p (concat "Do you really want to delete file " filename " ?"))
            (progn
              (delete-file filename)
              (message "Deleted file %s." filename)
              (kill-buffer)))
      (message "Not a file visiting buffer!"))))

(global-set-key (kbd "s-<delete>") #'delete-file-and-buffer)

                                        ;(pixel-scroll-precision-mode 1)
(eval
 `(use-package ultra-scroll
    :load-path ,(expand-file-name "ultra-scroll" user-emacs-directory)
    :init
    (setq scroll-conservatively 101 ; important!
          scroll-margin 0)
    :config
    (ultra-scroll-mode 1)))

(require 'mu4e)
                                        ; Hmm. (add-hook 'mu4e-compose-mode-hook 'turn-off-auto-fill)
(add-hook 'message-mode-hook 'turn-off-auto-fill) ; maybe that covers both mu4e and gnus ?

;; Patch mu4e user-unfriendliness.  TODO: Upstream.
(defvar mu4e-view-tool-bar-map
  (let ((tool-bar-map (make-sparse-keymap)))
                                        ;    (tool-bar-local-item
                                        ;     "mail/reply-all"
                                        ;     (lambda () (interactive) (mu4e-compose-reply t))
                                        ;     'reply-all
                                        ;     tool-bar-map
                                        ;     :label "Reply All"
                                        ;     :help "Reply to all recipients")

    (tool-bar-local-item-from-menu
     'mu4e-compose-wide-reply
     "mail/reply-all" tool-bar-map mu4e-view-mode-map
     :label "Reply to all"
     :help "Reply to all recipients")

    (tool-bar-local-item-from-menu
     'mu4e-compose-reply
     "mail/reply" tool-bar-map mu4e-view-mode-map
     :label "Reply"
     :help "Reply to sender")

    (tool-bar-local-item-from-menu
     'mu4e-compose-forward
     "mail/forward" tool-bar-map mu4e-view-mode-map
     :label "Forward"
     :help "Forward this message")

    (tool-bar-local-item-from-menu
     'mu4e-view-mark-for-move
     "mail/move" tool-bar-map mu4e-view-mode-map
     :label "Move"
     :help "Mark this message for moving")

    (tool-bar-local-item-from-menu
     'mu4e-view-mark-for-flag
     "mail/flag-for-followup" tool-bar-map mu4e-view-mode-map
     :label "Flag for followup"
     :help "Mark this message for followup")

    (tool-bar-local-item-from-menu
     'mu4e-view-mark-for-trash
     "delete" tool-bar-map mu4e-view-mode-map
     :label "Trash"
     :help "Mark this message for trashing")

    ;;;(tool-bar-local-item-from-menu
    ;;; 'mu4e-view-mark-for-delete
    ;;; "delete" tool-bar-map mu4e-view-mode-map
    ;;; :label "Delete"
    ;;; :help "Mark this message for deletion")

    (tool-bar-local-item
     "mpc/play"
     'mu4e-view-marked-execute
     'mu4e-view-marked-execute ; id
     tool-bar-map
     :label "Commit marks"
     :help "Commit marks")

;;;    (tool-bar-local-item-from-menu
;;;     'mu4e-view-marked-execute
;;;     "mpc/play" tool-bar-map mu4e-view-mode-map
;;;     :label "Commit marks"
;;;     :help "Commit marks")

    ;; TODO: compose !!!!

    ;; TODO: copy [?]
    ;; TODO: repack [?]
    ;; TODO: reply-to [?]
    ;; TODO: save-draft [?]
    ;; TODO: save [?]
    ;; TODO: send [?]
    ;; TODO: not-spam [?]
    ;; TODO: spam [?]

    (tool-bar-local-item
     "left-arrow"
     'mu4e-view-headers-prev
     'mu4e-view-headers-prev
     tool-bar-map
     :label "Go to previous message"
     :help "Go to previous message")

    (tool-bar-local-item
     "right-arrow"
     'mu4e-view-headers-next
     'mu4e-view-headers-next
     tool-bar-map
     :label "Go to next message"
     :help "Go to next message")

    ;;;(tool-bar-local-item-from-menu
    ;;; 'mu4e-view-headers-next
    ;;; "right-arrow" tool-bar-map mu4e-view-mode-map
    ;;; :label "Next"
    ;;; :help "Go to next message")

    ;;;(tool-bar-local-item-from-menu
    ;;; 'mu4e-view-headers-prev
    ;;; "left-arrow" tool-bar-map mu4e-view-mode-map
    ;;; :label "Previous"
    ;;; :help "Go to previous message")

    tool-bar-map))

(defun my-mu4e-view-setup-toolbar ()
  "Set up the toolbar for `mu4e-view-mode'."
  (setq-local tool-bar-map mu4e-view-tool-bar-map)
                                        ; we don't need that: (tool-bar-mode 1)
  )

(add-hook 'mu4e-view-mode-hook #'my-mu4e-view-setup-toolbar)
                                        ;(my-mu4e-view-setup-toolbar)

(defun my-mu4e-headers-setup-toolbar ()
  "Add mu4e-specific items to the global toolbar for `mu4e-headers-mode'."
  (let ((my-tool-bar-map (copy-keymap tool-bar-map)))  ; Start with copy of global toolbar
    ;; Add mu4e-specific items

    ;; (tool-bar-local-item-from-menu 'mu4e-compose-new "mail/compose" my-tool-bar-map mu4e-headers-mode-map :label "Compose new mail" :help "Compose a new mail")
    ;; (tool-bar-local-item "mail/compose" 'compose-mail 'mu4e-compose-new my-tool-bar-map :label "Compose new mail" :help "Compose a new mail")
    (tool-bar-local-item "mail/compose" 'compose-mail 'compose-mail my-tool-bar-map :label "Compose new mail" :help "Compose a new mail")

    (tool-bar-local-item-from-menu 'mu4e-compose-wide-reply "mail/reply-all" my-tool-bar-map mu4e-headers-mode-map :label "Reply to all" :help "Reply to all recipients")
    (tool-bar-local-item-from-menu 'mu4e-compose-reply "mail/reply" my-tool-bar-map mu4e-headers-mode-map :label "Reply" :help "Reply to sender")
    (tool-bar-local-item-from-menu 'mu4e-compose-forward "mail/forward" my-tool-bar-map mu4e-headers-mode-map :label "Forward" :help "Forward this message")
    (tool-bar-local-item-from-menu 'mu4e-headers-mark-for-move "mail/move" my-tool-bar-map mu4e-headers-mode-map :label "Move" :help "Mark this message for moving")
                                        ; BROKEN (tool-bar-local-item-from-menu 'mu4e-headers-mark-for-flag "mail/flag-for-followup" my-tool-bar-map mu4e-headers-mode-map :label "Flag for followup" :help "Mark this message for followup")


    ;; Commit marks
    ;; (tool-bar-local-item-from-menu 'mu4e-mark-execute-all "mpc/play" my-tool-bar-map mu4e-headers-mode-map :label "Commit marks" :help "Commit marks") ; broken
    (tool-bar-local-item
     "mpc/play"
     'mu4e-mark-execute-all
     'mu4e-mark-execute-all ; id
     my-tool-bar-map
     :label "Commit marks"
     :help "Commit marks")

    ;; Mark for trash
    ;; (tool-bar-local-item-from-menu 'mu4e-headers-mark-for-trash "delete" my-tool-bar-map mu4e-headers-mode-map :label "Trash" :help "Mark this message for trashing") ; broken
    (tool-bar-local-item
     "delete"
     'mu4e-headers-mark-for-trash
     'mu4e-headers-mark-for-trash ; id
     my-tool-bar-map
     :label "Mark for trashing"
     :help "Mark for trashing")

    ;; Mark as read
    ;;(tool-bar-local-item-from-menu
    ;; 'mu4e-headers-mark-as-read
    ;; "mail/read" my-tool-bar-map mu4e-headers-mode-map
    ;; :label "Read"
    ;; :help "Mark as read")
                                        ;(tool-bar-local-item
                                        ; "mail/read"
                                        ; 'mu4e-headers-mark-as-read
                                        ; 'mu4e-headers-mark-as-read ; id
                                        ; my-tool-bar-map
                                        ; :label "Mark as read"
                                        ; :help "Mark as read")

    ;;; Mark as unread
    ;;;(tool-bar-local-item-from-menu
    ;;; 'mu4e-headers-mark-as-unread
    ;;; "mail/unread" my-tool-bar-map mu4e-headers-mode-map
    ;;; :label "Unread"
    ;;; :help "Mark as unread")
                                        ;(tool-bar-local-item
                                        ; "mail/unread"
                                        ; 'mu4e-headers-mark-as-unread
                                        ; 'mu4e-headers-mark-as-unread ; id
                                        ; my-tool-bar-map
                                        ; :label "Mark as unread"
                                        ; :help "Mark as unread")

    ;; Refresh
    ;;(tool-bar-local-item-from-menu
    ;; 'mu4e-headers-rerun-search
    ;; "refresh" my-tool-bar-map mu4e-headers-mode-map
    ;; :label "Refresh"
    ;; :help "Refresh headers")
    (tool-bar-local-item
     "refresh"
     'mu4e-headers-rerun-search
     'mu4e-headers-rerun-search ; id
     my-tool-bar-map
     :label "Refresh"
     :help "Rerun search")

    ;; Making a buffer local
    (setq-local tool-bar-map my-tool-bar-map)))

(add-hook 'mu4e-headers-mode-hook #'my-mu4e-headers-setup-toolbar)

;;; Composer has a very good toolbar already.
;;; The major mode is mu4e:compose mode defined in mu4e-compose.el.

(use-package arei
  :config
  nil
  ;; - `sesman-start' (C-c C-s s) to connect to nrepl server.
  ;; - `universal-argument' (C-u) to select a connection endpoint (host and port).
  ;; - `sesman-quit' (C-c C-s q) to close the connection.
  ;; Development related and other commands:
  ;; - `arei-evaluate-last-sexp' (C-d C-e) to evaluate expression before point.
  ;; - `arei-evaluate-buffer' (C-d C-k) to evaluate buffer.
  ;; - `arei-evaluate-sexp' (M-x ... RET) to interactively evaluate an expression you input.
;;;  "C-c C-b" #'arei-interrupt-evaluation   wtf? Why not C-g ? Or C-d C-c ?
;;;  "C-c C-z" #'arei-switch-to-connection-buffer
;;;  "C-M-x" #'arei-evaluate-defun
;;;  "C-c C-c" #'arei-evaluate-defun
;;;arei-mode-map
  )

(defun my-scheme-setup-toolbar ()
  "Add mu4e-specific items to the global toolbar for `scheme-mode'."
  (let ((tool-bar-map (copy-keymap tool-bar-map)))  ; Start with copy of global toolbar
    ;; Add scheme-specific items

    ;;; (async-shell-command COMMAND &optional OUTPUT-BUFFER ERROR-BUFFER)
    ;;; TODO: Add button for "build guix package at point" like C-M-x.
    ;;; TODO: Use some arei-like scheme thing to send package to REPL.
    ;;; M-x "arei" to connect to nREPL server.

                                        ;(tool-bar-local-item-from-menu 'mu4e-compose-wide-reply "mail/reply-all" tool-bar-map scheme-mode-map :label "Reply to all" :help "Reply to all recipients")
                                        ;(tool-bar-local-item-from-menu 'mu4e-compose-reply "mail/reply" tool-bar-map scheme-mode-map :label "Reply" :help "Reply to sender")
                                        ;(tool-bar-local-item-from-menu 'mu4e-compose-forward "mail/forward" tool-bar-map scheme-mode-map :label "Forward" :help "Forward this message")
                                        ;(tool-bar-local-item "delete" 'mu4e-headers-mark-for-trash 'mu4e-headers-mark-for-trash tool-bar-map :label "Mark for trashing" :help "Mark for trashing")
    nil))
(add-hook 'scheme-mode-hook #'my-scheme-setup-toolbar)

(use-package elfeed-tube
                                        ;:ensure t ;; or :straight t
  :after elfeed
  :demand t
  :config
  ;; (setq elfeed-tube-auto-save-p nil) ; default value
  ;; (setq elfeed-tube-auto-fetch-p t)  ; default value
  (elfeed-tube-setup)

  :bind (:map elfeed-show-mode-map
              ("F" . elfeed-tube-fetch)
              ([remap save-buffer] . elfeed-tube-save)
              :map elfeed-search-mode-map
              ("F" . elfeed-tube-fetch)
              ([remap save-buffer] . elfeed-tube-save)))

(use-package elfeed-tube-mpv
                                        ;:ensure t ;; or :straight t
  :bind (:map elfeed-show-mode-map
              ("C-c C-f" . elfeed-tube-mpv-follow-mode)
              ("C-c C-w" . elfeed-tube-mpv-where)))

;; Minor mode to render bug references in emails (this includes mu4e)
(add-hook 'gnus-summary-mode-hook 'bug-reference-mode)
;; Minor mode to render bug references in emails (this includes mu4e)
(add-hook 'gnus-article-mode-hook 'bug-reference-mode)

(use-package debbugs
  :config
  (defun my-debbugs-setup-toolbar ()
    (easy-menu-define debbugs-org-mode-menu debbugs-org-mode-map
      "Menu for debbugs"
      '("Debbugs"
        ["Change bug status..." debbugs-gnu-send-control-message :help "Send control message"]
        ["Display bug status" debbugs-gnu-display-status :help "Display bug status"])))
  (add-hook 'debbugs-org-mode-hook #'my-debbugs-setup-toolbar))

(require 'debbugs)
(require 'bug-reference)

(add-to-list 'bug-reference-setup-from-mail-alist
             `("Guix" ; name
               nil   ;; no header matching needed ; FIXME
               ,(concat "\\b\\(bug#\\("
                        "[0-9]\\{1,100\\}\\)\\)\\b")
               "https://debbugs.gnu.org/%s"))

;; Only used when the URL matches <https://debbugs.gnu.org/12345> or <https://bugs.gnu.org/54321>.
(add-hook 'bug-reference-mode-hook 'debbugs-browse-mode)

;; Only used when the URL matches <https://debbugs.gnu.org/12345> or <https://bugs.gnu.org/54321>.
(add-hook 'bug-reference-prog-mode-hook 'debbugs-browse-mode)

(setq request-backend 'url-retrieve) ; alternative: curl

(use-package trashed
  :ensure t
  :commands (trashed)
  :config
  (setq trashed-action-confirmer 'y-or-n-p)
  (setq trashed-use-header-line t)
  (setq trashed-sort-key '("Date deleted" . t))
  (setq trashed-date-format "%Y-%m-%d %H:%M:%S"))

(setq el-job--debug-level 1)

(defun org-babel-execute:ditaa (body params)
  "Execute a block of Ditaa code in BODY with org-babel (and parameters PARAMS).
This function is called by `org-babel-execute-src-block'."
  (let* ((out-file (or (cdr (assq :file params))
                       (error
                        "ditaa code block requires :file header argument")))
         (cmdline (cdr (assq :cmdline params)))
         (java (cdr (assq :java params)))
         (in-file (org-babel-temp-file "ditaa-"))
         (eps (cdr (assq :eps params)))
         (eps-file (when eps
                     (org-babel-process-file-name (concat in-file ".eps"))))
         (pdf-cmd (when (and (or (string= (file-name-extension out-file) "pdf")
                                 (cdr (assq :pdf params))))
                    (concat
                     "epstopdf"
                     " " eps-file
                     " -o=" (org-babel-process-file-name out-file))))
         (cmd (concat "ditaa"
                      " " cmdline
                      " " (org-babel-process-file-name in-file)
                      " " (if pdf-cmd
                              eps-file
                            (org-babel-process-file-name out-file)))))
    (unless (file-exists-p org-ditaa-jar-path)
      (error "Could not find ditaa.jar at %s" org-ditaa-jar-path))
    (with-temp-file in-file (insert body))
    (message cmd) (shell-command cmd)
    (when pdf-cmd (message pdf-cmd) (shell-command pdf-cmd))
    nil)) ;; signal that output has already been written to file

(use-package dirvish
  :config
  (setq dirvish-attributes
        (append
         '(vc-state subtree-state nerd-icons collapse)
         ;; Other attributes are displayed in the order they appear in this list.
         '(git-msg file-time file-size))))

;(use-package org-books
;  :config
;  (setq org-books-file "~/doc/org/books.org"))

;; TODO: emacs-lisp r sql ruby js perl c c++ java haskell scala octave[!] maxima awk ditaa dot gnuplot plantuml latex ledger picolisp ocaml sed go julia sage[!] mathematica scheme sass fortran lua coq[!] d
(org-babel-do-load-languages
 'org-babel-load-languages
 '((shell . t)
   (ditaa . t)
   (python . t)
   (jupyter . t)
   (dot . t)
   (gnuplot . t)
   (plantuml . t)))
;; TODO: Switch to notmuch for news as well?
(use-package gnus
  :config
  (when window-system
    (setq gnus-sum-thread-tree-indent "  ")
    (setq gnus-sum-thread-tree-root "") ;; "● "
    (setq gnus-sum-thread-tree-false-root "") ;; "◯ "
    (setq gnus-sum-thread-tree-single-indent "") ;; "◎ "
    (setq gnus-sum-thread-tree-vertical        "│")
    (setq gnus-sum-thread-tree-leaf-with-other "├─► ")
    (setq gnus-sum-thread-tree-single-leaf     "╰─► "))
  (setq gnus-summary-line-format
        (concat
         "%0{%U%R%z%}"
         "%3{│%}" "%1{%d%}" "%3{│%}" ;; date
         "  "
         "%4{%-20,20f%}"               ;; name
         "  "
         "%3{│%}"
         " "
         "%1{%B%}"
         "%s\n"))
  (setq gnus-summary-display-arrow t)
                                        ; gnus-dired-attach in dired; attaches to open email
  (setq gnus-play-startup-jingle nil)
                                        ; Also .newsrc
                                        ; If the variable gnus-default-subscribed-newsgroups is set, Gnus will subscribe you to just those groups in that list, leaving the rest killed. Your system administrator should have set this variable to something useful.
                                        ;(setq gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\”]\”[#’()]")
                                        ;(setq nnml-directory (expand-file-name "~/gmail"))
                                        ;(setq message-directory (expand-file-name "~/gmail"))
  (setq gnus-gcc-mark-as-read t)
  (setq gnus-agent t)
                                        ;(setq gnus-novice-user nil)           ; careful with this
  ;; checking sources
  (setq gnus-check-new-newsgroups 'ask-server)
  (setq gnus-read-active-file 'some)
  ;; dribble
  (setq gnus-use-dribble-file t)
  (setq gnus-always-read-dribble-file t)
;;; agent
  (setq gnus-agent-article-alist-save-format 1)  ; uncompressed
  (setq gnus-agent-cache t)
  (setq gnus-agent-confirmation-function 'y-or-n-p)
  (setq gnus-agent-consider-all-articles nil)
  (setq gnus-agent-directory (expand-file-name "~/News/agent/"))
  (setq gnus-agent-enable-expiration 'ENABLE)
  (setq gnus-agent-expire-all nil)
  (setq gnus-agent-expire-days 30)
  (setq gnus-agent-mark-unread-after-downloaded t)
  (setq gnus-agent-queue-mail t)        ; queue if unplugged
  (setq gnus-agent-synchronize-flags nil)
;;; article
  (setq gnus-article-browse-delete-temp 'ask)
  (setq gnus-article-over-scroll nil)
  (setq gnus-article-show-cursor t)
  (setq gnus-article-sort-functions
        '((not gnus-article-sort-by-number)
          (not gnus-article-sort-by-date)))
  (setq gnus-article-truncate-lines nil)
  (setq gnus-html-frame-width 80)
  (setq gnus-html-image-automatic-caching t)
  (setq gnus-inhibit-images t)
  (setq gnus-max-image-proportion 0.7)
  (setq gnus-treat-display-smileys nil)
  (setq gnus-article-mode-line-format "%G %S %m")
  (setq gnus-visible-headers
        '("^From:" "^To:" "^Cc:" "^Subject:" "^Newsgroups:" "^Date:"
          "Followup-To:" "Reply-To:" "^Organization:" "^X-Newsreader:"
          "^X-Mailer:"))
  (setq gnus-sorted-header-list gnus-visible-headers)
  (setq gnus-article-x-face-too-ugly ".*") ; all images in headers are outright annoying---disabled!
;;; async
  (setq gnus-asynchronous t)
  (setq gnus-use-article-prefetch 15)
;;; group
  (setq gnus-level-subscribed 6)
  (setq gnus-level-unsubscribed 7)
  (setq gnus-level-zombie 8)
  (setq gnus-activate-level 1)
  (setq gnus-list-groups-with-ticked-articles nil)
  (setq gnus-group-sort-function
        '((gnus-group-sort-by-unread)
          (gnus-group-sort-by-alphabet)
          (gnus-group-sort-by-rank)))
  (setq gnus-group-line-format "%M%p%P%5y:%B%(%g%)\n")
  (setq gnus-group-mode-line-format "%%b")
  (setq gnus-topic-display-empty-topics nil)
;;; summary
  (setq gnus-auto-select-first nil)
  (setq gnus-summary-ignore-duplicates t)
  (setq gnus-suppress-duplicates t)
  (setq gnus-save-duplicate-list t)
  (setq gnus-summary-goto-unread nil)
  (setq gnus-summary-make-false-root 'adopt)
  (setq gnus-summary-thread-gathering-function
        'gnus-gather-threads-by-subject)
  (setq gnus-summary-gather-subject-limit 'fuzzy)
  (setq gnus-thread-sort-functions
        '((not gnus-thread-sort-by-date)
          (not gnus-thread-sort-by-number)))
  (setq gnus-subthread-sort-functions
        'gnus-thread-sort-by-date)
  (setq gnus-thread-hide-subtree nil)
  (setq gnus-thread-ignore-subject nil)
  (setq gnus-user-date-format-alist
        '(((gnus-seconds-today) . "Today at %R")
          ((+ (* 60 60 24) (gnus-seconds-today)) . "Yesterday, %R")
          (t . "%Y-%m-%d %R")))

  ;; When the %f specifier in `gnus-summary-line-format' matches my
  ;; name, this will use the contents of the "To:" field, prefixed by
  ;; the string I specify.  Useful when checking your "Sent" summary or
  ;; a mailing list you participate in.
  (setq gnus-ignored-from-addresses "Protesilaos Stavrou")
  (setq gnus-summary-to-prefix "To: ")

  (setq gnus-summary-line-format "%U%R %-18,18&user-date; %4L:%-25,25f %B%s\n")
  (setq gnus-summary-mode-line-format "[%U] %p")
  (setq gnus-sum-thread-tree-false-root "")
  (setq gnus-sum-thread-tree-indent " ")
  (setq gnus-sum-thread-tree-single-indent "")
  (setq gnus-sum-thread-tree-leaf-with-other "+-> ")
  (setq gnus-sum-thread-tree-root "")
  (setq gnus-sum-thread-tree-single-leaf "\\-> ")
  (setq gnus-sum-thread-tree-vertical "|")
  (setq gnus-select-method
        '(nntp "news.gmane.io"
               (nntp-open-connection-function nntp-open-network-stream) ; FIXME: Force STARTTLS
               (nntp-port-number 119)))
  ;(add-hook 'dired-mode-hook #'gnus-dired-mode) ; dired integration ; does not exist??
  (add-hook 'gnus-group-mode-hook #'gnus-topic-mode)
  (add-hook 'gnus-select-group-hook #'gnus-group-set-timestamp)

  (dolist (mode '(gnus-group-mode-hook gnus-summary-mode-hook gnus-browse-mode-hook))
    (add-hook mode #'hl-line-mode))

  ;;; Gnus is a marvelous client because it has really good NNTP and threading support (silencing and automatic scoring)
  ;;; Is it possible to make mu4e index nntp articles cached by gnus-agent?
  ;;; It seems that mu4e wants maildir but gnus-agent uses mh (?).
  ;;; gmane also includes gwene groups that mirror RSS feeds as usenet messages.
  ;;; For search: nnir (but gmane search broke--even though it would otherwise be built-in and autoconfigured):
  ;;; In the group buffer typing G G will search the group on the current line by calling gnus-group-make-nnir-group.
  ;;; This prompts for a query string, creates an ephemeral nnir group containing the articles that match this query, and takes you to a summary buffer showing these articles.
  ;;; Articles may then be read, moved and deleted using the usual commands.
  ;;; Likewise, mailing list subscriptions have been moved from m.gmane.org to m.gmane-mx.org.
  ;;; The gmane server supports STARTTLS on port 119.
  (let ((map gnus-article-mode-map))
    (define-key map (kbd "i") #'gnus-article-show-images)
    (define-key map (kbd "s") #'gnus-mime-save-part)
    (define-key map (kbd "o") #'gnus-mime-copy-part))
  (let ((map gnus-group-mode-map))       ; I always use `gnus-topic-mode'
    (define-key map (kbd "n") #'gnus-group-next-group)
    (define-key map (kbd "p") #'gnus-group-prev-group)
    (define-key map (kbd "M-n") #'gnus-topic-goto-next-topic)
    (define-key map (kbd "M-p") #'gnus-topic-goto-previous-topic))
  (let ((map gnus-summary-mode-map))
    (define-key map (kbd "<delete>") #'gnus-summary-delete-article)
    (define-key map (kbd "n") #'gnus-summary-next-article)
    (define-key map (kbd "p") #'gnus-summary-prev-article)
    (define-key map (kbd "N") #'gnus-summary-next-unread-article)
    (define-key map (kbd "P") #'gnus-summary-prev-unread-article)
    (define-key map (kbd "M-n") #'gnus-summary-next-thread)
    (define-key map (kbd "M-p") #'gnus-summary-prev-thread)
    (define-key map (kbd "C-M-n") #'gnus-summary-next-group)
    (define-key map (kbd "C-M-p") #'gnus-summary-prev-group)
    (define-key map (kbd "C-M-^") #'gnus-summary-refer-thread))

  (defvar message-mode-tool-bar-map
    (let ((tool-bar-map (make-sparse-keymap)))
      (tool-bar-local-item-from-menu 'mml-attach-file "attach" tool-bar-map message-mode-map)
      (tool-bar-local-item-from-menu 'ispell-message "spell" tool-bar-map message-mode-map)
      (tool-bar-local-item-from-menu 'mml-secure-message-sign "lock" tool-bar-map message-mode-map)
      (tool-bar-local-item-from-menu 'mml-secure-message-encrypt "locked-encrypted" tool-bar-map message-mode-map)

      (tool-bar-local-item-from-menu 'message-send-and-exit "gnus/mail-send" tool-bar-map message-mode-map)
      ;; (tool-bar-local-item-from-menu 'message-dont-send "gnus/save-draft" tool-bar-map message-mode-map)
      (tool-bar-local-item-from-menu 'message-kill-buffer "gnus/kill-group" tool-bar-map message-mode-map)
                                        ;       :label "Reply to all"
                                        ;       :help "Reply to all recipients"
      tool-bar-map))

  (defun my-message-mode-setup-toolbar () ; FIXME: maybe that's also used for mu4e ?! That might not be so great.
    "Set up the toolbar for `message-mode'."
    (setq-local tool-bar-map message-mode-tool-bar-map))

  (add-hook 'message-mode-hook #'my-message-mode-setup-toolbar)

  (defvar gnus-article-mode-tool-bar-map
    (let ((tool-bar-map (make-sparse-keymap)))
      (tool-bar-local-item "mail/reply-all" 'gnus-summary-wide-reply 'gnus-summary-wide-reply tool-bar-map :label "Reply to all" :help "Reply to all recipients")
      (tool-bar-local-item "mail/reply" 'gnus-summary-reply 'gnus-summary-reply tool-bar-map :label "Reply" :help "Reply to sender")
      (tool-bar-local-item "mail/forward" 'gnus-summary-post-forward 'gnus-summary-post-forward tool-bar-map :label "Forward" :help "Forward this message")

      ;; TODO mark

      tool-bar-map))

  (defun my-gnus-article-mode-setup-toolbar ()
    "Set up the toolbar for `gnus-article-mode'."
    (setq-local tool-bar-map gnus-article-mode-tool-bar-map))

  (add-hook 'gnus-article-mode-hook #'my-gnus-article-mode-setup-toolbar)

  (defun my-gnus-summary-mode-setup-toolbar ()
    "Set up the toolbar for `gnus-summary-mode'."
    (let ((my-tool-bar-map (if tool-bar-map (copy-keymap tool-bar-map) (make-sparse-keymap))))  ; Start with copy of global toolbar
      (tool-bar-local-item "mail/compose" 'gnus-summary-post-news 'gnus-summary-post-news my-tool-bar-map :label "Compose new post" :help "Compose a new post")

      (tool-bar-local-item-from-menu
       'gnus-summary-wide-reply
       "mail/reply-all" my-tool-bar-map gnus-summary-mode-map
       :label "Reply to all"
       :help "Reply to all recipients")

      (tool-bar-local-item-from-menu
       'gnus-summary-reply
       "mail/reply" my-tool-bar-map gnus-summary-mode-map
       :label "Reply"
       :help "Reply to sender")

      (tool-bar-local-item-from-menu
       'gnus-summary-post-forward
       "mail/forward" my-tool-bar-map gnus-summary-mode-map
       :label "Forward"
       :help "Forward this message")

      ;; TODO: next, previous article.

      (setq-local tool-bar-map my-tool-bar-map)))

  (add-hook 'gnus-summary-mode-hook #'my-gnus-summary-mode-setup-toolbar))

(add-hook 'git-commit-setup-hook #'my/generate-lisp-commit-message)

;; wakib has keyboard-quit on <escape> via wakib-keys-overriding-map (see simple.el)
;; but apparently there's a minibuffer-keyboard-quit we don't use, except on C-g, where delsel.el defines it.
;;(define-key minibuffer-local-map (kbd "<Escape>") 'minibuffer-keyboard-quit)
(wakib-define-keys wakib-keys-overriding-map `(("<escape>" . ,#'keyboard-escape-quit)))

;; Org mode stuff is too small for me (since it often contains math). Increase font size slightly.
                                        ;(face-remap-add-relative 'stripe-highlight '(:foreground "black" :background "yellow"))
(defun my/org-scale-up-font ()
  "Org mode a a bit too small text for me (since I use a lot of embedded math in it).  Increase font size slightly."
  (text-scale-increase 1)
                                        ;(setq xenops-math-image-scale-factor 0.6)
  )
(add-hook 'org-mode-hook #'my/org-scale-up-font)
(add-hook 'dired-mode-hook 'dired-hide-details-mode)

(with-eval-after-load 'prog-mode
  (define-key prog-mode-map (kbd "C-c s") 'magit-stage-region)
  (define-key prog-mode-map (kbd "C-c c") 'magit-commit))

(use-package compile
  :ensure nil
  :custom
  (compilation-scroll-output t)
  (ansi-color-for-compilation-mode t)
  ; (compilation-environment '("TERM=xterm-256color"))
  :config
  (add-hook 'compilation-filter-hook #'ansi-color-compilation-filter))
(use-package proced
  :defer t
  :custom
  (proced-enable-color-flag t)
  (proced-tree-flag t)
  (proced-auto-update-flag 'visible)
  (proced-auto-update-interval 1)
  (proced-descent t)
  (proced-filter 'user)
  :config
  (add-hook 'proced-mode-hook
            (lambda ()
              (proced-toggle-auto-update 1))))

(use-package flymake
  :defer t
  :hook (emacs-lisp-mode . flymake-mode)
  :custom
  (flymake-show-diagnostics-at-end-of-line t)
  (flymake-indicator-type 'margins)
  (flymake-margin-indicators-string
   `((error "!" compilation-error)
     (warning "?" compilation-warning)
     (note "i" compilation-info))))

(add-hook 'emms-browser-mode-hook 'tab-line-mode)
(add-hook 'emms-browser-mode-hook #'variable-pitch-mode)
(defun my-emms-browser-setup-toolbar ()
  "Add emms-browser-specific items to the global toolbar for `emms-browser-mode'."

  (easy-menu-define emms-browser-mode-menu emms-browser-mode-map
    "Menu for emms-browser"
    '("Emms"
      ["Browse by album" emms-browse-by-album :help "Browse by album"]
      ["Browse by year" emms-browse-by-year :help "Browse by year"]
      ["Browse by genre" emms-browse-by-genre :help "Browse by genre"]
      ["Browse by artist" emms-browse-by-artist :help "Browse by artist"]
      ["Browse by composer" emms-browse-by-composer :help "Browse by composer"]
      ["Browse by performer" emms-browse-by-performer :help "Browse by performer"]
      ["Add tracks" emms-browse-add-tracks :help "Add tracks at point"]
      ["Add tracks and play" emms-add-tracks-and-play :help "Add tracks at point and play"]
      ["Collapse all" emms-browser-collapse-all :help "Collapse all nodes"]
      ["Expand all" emms-browser-expand-all :help "Expand all nodes"]
                                        ;["Do Other Thing" your-mode-do-other-thing :enable (buffer-modified-p) :help "Does another thing"]
      ))
  (let ((my-tool-bar-map (copy-keymap tool-bar-map)))  ; Start with copy of global toolbar
    (tool-bar-local-item "mpc/add" 'emms-browser-add-tracks-and-play 'emms-browser-add-tracks-and-play my-tool-bar-map 'emms-browser-add-tracks-and-play :label "Add and play" :help "Add tracks and play")
    ;; Making a buffer local
    (setq-local tool-bar-map my-tool-bar-map)))
(add-hook 'emms-browser-mode-hook #'my-emms-browser-setup-toolbar)

(add-hook 'emms-playlist-mode-hook 'tab-line-mode)
(defun my-emms-playlist-setup-toolbar ()
  "Add emms-playlist-specific items to the global toolbar for `emms-playlist-mode'."
  (easy-menu-define emms-playlist-mode-menu emms-playlist-mode-map
    "Menu for emms-playlist"
    '("Emms"
      ["Play smart" emms-playlist-mode-play-smart :help "Play (smart)"]
      ["Seek backward" emms-seek-backward :help "Seek backward"]
      ["Seek forward" emms-seek-forward :help "Seek forward"]
      ["Pause" emms-pause :help "Pause"]
      ["Previous track" emms-previous :help "Go to previous track"]
      ["Next track" emms-next :help "Go to next track"]
      ["Stop" emms-stop :help "Stop playing"]
      ["Edit tag..." emms-tag-editor-edit :help "Edit ID3 tag"]
      ["Pipe tag editor..." emms-tag-editor-pipe :help "Pipe to a more complicated (configured) tag editor"]
      ))

  (let ((my-tool-bar-map (copy-keymap tool-bar-map)))  ; Start with copy of global toolbar
    ;;; TODO: emms-playlist-mode-kill-track
    ;;; TODO: emms-playlist-mode-shift-track-up
    ;;; TODO: emms-playlist-mode-shift-track-down
    ;;; TODO: emms-playlist-mode-kill
    ;;; TODO: emms-playlist-mode-kill-track
    ;;; TODO: emms-playlist-mode-yank
    ;;; TODO: emms-playlist-mode-undo
    ;;; TODO: SPC scroll-up
    ;;; TODO: emms-volume-raise
    ;;; TODO: emms-volume-lower

    ;;; icons: add.pbm

    (tool-bar-local-item "mpc/play" 'emms-playlist-mode-play-smart 'emms-playlist-mode-play-smart my-tool-bar-map :label "Play" :help "Play track at point")
    (tool-bar-local-item "mpc/rewind" 'emms-seek-backward 'emms-seek-backward my-tool-bar-map :label "Seek backward" :help "Seek backward in track")
    (tool-bar-local-item "mpc/ffwd" 'emms-seek-forward 'emms-seek-forward my-tool-bar-map :label "Seek forward" :help "Seek forward in track")
    (tool-bar-local-item "mpc/pause" 'emms-pause 'emms-pause my-tool-bar-map :label "Pause" :help "Pause playing")
    (tool-bar-local-item "mpc/prev" 'emms-previous 'emms-previous my-tool-bar-map :label "Previous track" :help "Go to previous track")
    (tool-bar-local-item "mpc/next" 'emms-next 'emms-next my-tool-bar-map :label "Next track" :help "Go to next track")
    (tool-bar-local-item "mpc/stop" 'emms-stop 'emms-stop my-tool-bar-map :label "Stop playing" :help "Stop playing")
    ;;; TODO: emms-random !!!

    ;;; TODO: emms-show -> "currently playing X" in mode-line

    ;;; TODO: emms-tag-editor-edit
    ;;; TODO: emms-tag-editor-rename

    ;;; TODO: emms-playlist-mode-current-kill
    ;;; TODO: emms-playlist-clear
    ;;; TODO: emms-playlist-mode-add-contents
    ;;; TODO: emms-playlist-set-playlist-buffer
    ;;; TODO: emms-playlist-mode-center-current
    ;;; TODO: emms-playlist-mode-goto-dired-at-point
    ;;; TODO: emms-playlist-playlist-insert-track
    ;;; TODO: emms-playlist-mode-bury-buffer
    ;;; TODO: emms-playlist-mode-undo
    ;;;	TODO: emms-playlist-mode-play-current-track (mouse-2)
    ;;; TODO: emms-playlist-limit-to-all
    ;;; TODO: emms-playlist-limit-to-info-albumartist
    ;;; TODO: emms-playlist-limit-to-info-note
    ;;; TODO: emms-playlist-limit-to-info-artist
    ;;; TODO: emms-playlist-limit-to-info-album
    ;;; [...]
    ;;; TODO: emms-playlist-sort-by-info-albumartist
    ;;; [...]
    ;;; TODO: emms-playlist-mode-first
    ;;; TODO: emms-playlist-mode-last
    ;;; TODO: emms-playlist-mode-next
    ;;; TODO: emms-playlist-mode-previous
    ;;; TODO: emms-playlist-mode-yank-pop
    ;;; TODO: emms-playlist-save
    ;;; TODO: emms-playlist-mode-undo

    ;; Making a buffer local
    (setq-local tool-bar-map my-tool-bar-map)))
(add-hook 'emms-playlist-mode-hook #'my-emms-playlist-setup-toolbar)
(add-hook 'emms-playlist-mode-hook #'variable-pitch-mode)

; emms-playlist-mode-go
; switch-to-buffer emms-playlist-buffer
; emms-playlist-mode-add-contents setq emms-playlist-buffer emms-playlist-set-playlist-buffer (emms-playlist-new
(defun my/substitute-unnecessary-latex ()
  "Substitute \\[ \\n \\text{STUFF} \\n \\] with STUFF in the current buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "\\\[\\([[:space:]]*\\)\\(\n\\)[[:space:]]*\\\\text{\\([a-zA-Zäöü:,.[:space:]]*\\)[[:space:]]*}[[:space:]]*\\(\n\\)[[:space:]]*\\\\]")
      (replace-match "\\3" nil nil))))
(use-package magit
  :config
  (defvar magit-status-mode-tool-bar-map
    (let ((tool-bar-map (make-sparse-keymap)))
      (tool-bar-local-item-from-menu 'magit-fetch "refresh" tool-bar-map magit-status-mode-map)
      (tool-bar-local-item-from-menu 'magit-pull "custom/down" tool-bar-map magit-status-mode-map)
      (tool-bar-local-item-from-menu 'magit-push "up-arrow" tool-bar-map magit-status-mode-map)
      (tool-bar-local-item-from-menu 'magit-commit "data-save" tool-bar-map magit-status-mode-map)
                                        ;(tool-bar-local-item-from-menu 'magit-init "attach" tool-bar-map magit-status-mode-map) ; well yeah--but how do I reach it?
                                        ; magit-clone ; well yeah--but how do I reach it?
      tool-bar-map))
  (defun my-magit-status-mode-setup-toolbar ()
    "Set up the toolbar for `magit-status-mode'."
    (setq-local tool-bar-map magit-status-mode-tool-bar-map))
  (add-hook 'magit-status-mode-hook #'my-magit-status-mode-setup-toolbar))

;; I already set mediainfo-mode-file-regexp--but apparently, that's not enough.

                                        ; If I add that then album mode of emms-smart doesn't work anymore.
                                        ;(add-to-list
                                        ; 'file-name-handler-alist
                                        ; (cons (rx "." (or "jpg" "jpeg" "gif" "png")
                                        ;           eos)
                                        ;       'mediainfo-mode--file-handler))

(add-to-list
 'auto-mode-alist
 (cons (rx "." (or "jpg" "jpeg" "gif" "png")
           eos)
       'mediainfo-mode))

;;; org-babel doesn't take into account buffer-env's project environment.
;;; That's because:
;;; 1. Its temp files are not within our project.
;;; 2. buffer-env-update isn't called in time anyway.
;;;
;;; We fix both problems here.

(require 'org)
(require 'ob-shell)
(require 'inheritenv)

(advice-add 'org-babel-execute-src-block :around #'inheritenv-apply)
                                        ;(advice-add 'org-babel-execute:shell :around #'inheritenv-apply)

;; Tools menu is too big.
(defun my-remove-tools-menu-items ()
  "Remove unwanted items from the Tools menu."
  (interactive) ; Good practice, though not strictly needed for the hook

  (define-key global-map [menu-bar tools rgrep] nil) ; removed in favor of ripgrep
  (define-key global-map [menu-bar tools ede] nil) ; removed in favor of projectile, treemacs and lsp-mode
  (define-key global-map [menu-bar tools semantic] nil) ; removed in favor of LSP
  (define-key global-map [menu-bar tools directory-search] nil) ; outdated
  (define-key global-map [menu-bar tools simple-calculator] nil) ; there's a scientific one anyway
  (define-key global-map [menu-bar tools games] nil) ; I'm just out of space in the menu
                                        ;(easy-menu-remove-item '("Tools" "Project:"))
  )

(add-hook 'emacs-startup-hook #'my-remove-tools-menu-items)
;; Example configuration for Consult
(use-package consult
  ;; Replace bindings. Lazily loaded by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'; overridden by wakib to be C-d
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  ; :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
)

(use-package tab-line
  :demand t
  :bind
  (("C-<iso-lefttab>" . tab-line-switch-to-prev-tab)
   ("C-<tab>" . tab-line-switch-to-next-tab))
  :config
  (global-tab-line-mode 1)
  ;(setq
  ; tab-line-new-button-show nil
  ; tab-line-close-button-show nil)
   )
;; One color per project

(require 'project)
(require 'color)

(defun project-color-background ()
  "Return a background color for the project containing this directory"
  (let* ((project (project-current))
         (dirhash (sxhash (if project (project-root project) default-directory)))
         (hue (/ (mod dirhash 1000) 1000.0))
         (saturation (+ 0.3 (* 0.1 (mod (/ dirhash 1000) 3))))
         (lightness (+ 0.4 (* 0.05 (mod (/ (/ dirhash 1000) 3) 4))))
         (rgb (color-hsl-to-rgb hue saturation lightness)))
    (color-rgb-to-hex (nth 0 rgb) (nth 1 rgb) (nth 2 rgb) 2)))

(defun amitp/set-modeline-color ()
  "Set mode line color based on current buffer's project"
  (let ((color (project-color-background)))
    ;(face-remap-add-relative 'tab-line-tab-current :background color :foreground "white")
    (face-remap-add-relative 'mode-line-active :background color :foreground "white")
    (face-remap-add-relative 'line-number-current-line :background color :foreground "white")))

(add-hook 'find-file-hook #'amitp/set-modeline-color)
(add-hook 'dired-mode-hook #'amitp/set-modeline-color)
(add-hook 'change-major-mode-hook #'amitp/set-modeline-color)
(add-hook 'temp-buffer-setup-hook #'amitp/set-modeline-color)
(dolist (hook '(text-mode-hook prog-mode-hook conf-mode-hook org-mode-hook))
  (add-hook hook #'jinx-mode))
(keymap-global-set "M-$" #'jinx-correct)
(keymap-global-set "C-M-$" #'jinx-languages)
;(add-to-list 'vertico-multiform-categories
;             '(jinx grid (vertico-grid-annotate . 20) (vertico-count . 4)))
;(vertico-multiform-mode 1)
;(use-package jinx
;  :hook (emacs-startup . global-jinx-mode)
;  :bind (("M-$" . jinx-correct)
;         ("C-M-$" . jinx-languages)))

(use-package xenops
  :config
  (setq xenops-math-latex-process-alist
  '((dvipng
     :programs ("latex" "dvipng")
     :description "dvi > png"
     :message "you need to install the programs: latex and dvipng."
     :image-input-type "dvi"
     :image-output-type "png"
     :image-size-adjust (1.0 . 1.0)
     :latex-compiler ("lualatex -interaction nonstopmode -shell-escape -output-format dvi -output-directory %o %f")
     :image-converter ("dvipng -D %D -T tight -o %O %f"))
    (dvisvgm
     :programs ("latex" "dvisvgm")
     :description "dvi > svg"
     :message "you need to install the programs: latex and dvisvgm."
     :image-input-type "dvi"
     :image-output-type "svg"
     :image-size-adjust (1.7 . 1.5)
     :latex-compiler ("lualatex -interaction nonstopmode -shell-escape -output-format dvi -output-directory %o %f")
     :image-converter ("dvisvgm %f -n -b %B -c %S -o %O"))
    (imagemagick
     :programs ("latex" "convert")
     :description "pdf > png"
     :message "you need to install the programs: latex and imagemagick."
     :image-input-type "pdf"
     :image-output-type "png"
     :image-size-adjust (1.0 . 1.0)
     :latex-compiler ("pdflatex -interaction nonstopmode -shell-escape -output-directory %o %f")
     :image-converter ("convert -density %D -trim -antialias %f -quality 100 %O")))))

(use-package org-modern-indent
  :ensure t
  :config
  (add-hook 'org-mode-hook #'org-modern-indent-mode 90))

(use-package org-modern
  :ensure t
  :custom
  (org-modern-hide-stars nil)		; adds extra indentation
  (org-modern-table nil)
  (org-modern-list 
   '(;; (?- . "-")
     (?* . "•")
     (?+ . "‣")))
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda))

(use-package indent-bars
  :custom
  (indent-bars-no-descend-lists t) ; no extra bars in continued func arg lists
  (indent-bars-treesit-support t)
  (indent-bars-treesit-ignore-blank-lines-types '("module"))
  ;; Add other languages as needed
  (indent-bars-treesit-scope '((python function_definition class_definition for_statement
	  if_statement with_statement while_statement)))
  ;; Note: wrap may not be needed if no-descend-list is enough
  ;;(indent-bars-treesit-wrap '((python argument_list parameters ; for python, as an example
  ;;				      list list_comprehension
  ;;				      dictionary dictionary_comprehension
  ;;				      parenthesized_expression subscript)))
  :hook ((python-base-mode yaml-mode) . indent-bars-mode))
(load (locate-user-emacs-file "guix-build-failure3.el")
      :no-error-if-file-is-missing)

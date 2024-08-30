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
(global-set-key (kbd "<XF86Search>") 'search-forward)
(global-set-key (kbd "<Search>") 'search-forward)
                                        ;(global-set-key (kbd "<Launch1>") 'async-shell-command)
(global-set-key (kbd "<Launch1>") 'project-compile)


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

(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-S-s") 'save-buffer)

;;; ======================

;; Improve contrast
(add-to-list 'default-frame-alist '(foreground-color . "#505050"))

(add-to-list 'load-path "~/.emacs.d/treemacs-nerd-icons/")
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

(require 'mh-e) ; mail

(add-to-list 'treesit-extra-load-path "/home/dannym/.guix-home/profile/lib/tree-sitter/")

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

;;; Bookmarks
(setq mu4e-bookmarks
      `(
        ("flag:unread AND NOT flag:trashed" "Unread messages" ?u)
        ("flag:unread" "new messages" ?n)
        ("date:today..now" "Today's messages" ?t)
        ("date:7d..now" "Last 7 days" ?w)
        ("mime:image/*" "Messages with images" ?p)
        ))


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

                                        ; Vendored from https://raw.githubusercontent.com/Alexander-Miller/treemacs/master/src/extra/treemacs-projectile.el
(require 'treemacs-projectile)

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

;; Must do this so the agenda knows where to look for my files
(setq org-agenda-files '("~/doc/org"))

;; When a TODO is set to a done state, record a timestamp
(setq org-log-done 'time)

;; Follow the links
(setq org-return-follows-link  t)

;; Associate all org files with org mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

;; Make the indentation look nicer
(add-hook 'org-mode-hook 'org-indent-mode)

;; Remap the change priority keys to use the UP or DOWN key
(define-key org-mode-map (kbd "C-c <up>") 'org-priority-up)
(define-key org-mode-map (kbd "C-c <down>") 'org-priority-down)

;; Shortcuts for storing links, viewing the agenda, and starting a capture
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)

;; When you want to change the level of an org item, use SMR
(define-key org-mode-map (kbd "C-c C-g C-r") 'org-shiftmetaright)

;; Hide the markers so you just see bold text as BOLD-TEXT and not *BOLD-TEXT*
(setq org-hide-emphasis-markers t)

;; Wrap the lines in org mode so that things are easier to read ; FIXME how to make tables work correctly then?
(add-hook 'org-mode-hook 'visual-line-mode)

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

(setq pandoc-data-dir "~/.emacs.d/etc/pandoc/")

(defun efe/export-to-docx ()
  "Output to docx using pandoc-mode"
  (interactive)
  (pandoc-mode)
  (execute-kbd-macro (kbd "C-c / O W d b b r"))
  (setq pandoc-mode nil))

(defun insert-html-blog-template ()
  "Inserts HTML_HEAD lines at the first empty line and html code at the end of the buffer."
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

(add-to-list 'load-path "~/.emacs.d/iscroll/")
(require 'iscroll)
                                        ; Note: Only enable in text modes, not prog modes
                                        ;(iscroll-mode)

(add-hook 'elfeed-show-mode-hook 'iscroll-mode)

;;; Org mode

(setq org-todo-keywords
      '((sequence "TODO(t)" "PLANNING(p)" "IN-PROGRESS(i@/!)" "VERIFYING(v!)" "BLOCKED(b@)"  "|" "DONE(d!)" "OBE(o@!)" "WONT-DO(w@/!)" )
        ))

(setq org-capture-templates
      '(
        ("w" "Work Log Entry"
         entry (file+datetree "~/doc/org/work-log.org")
         "* %?"
         :empty-lines 0)
        ("n" "Note"
         entry (file+headline "~/doc/org/notes.org" "Random Notes")
         "** %?"
         :empty-lines 0)
        ("g" "General To-Do"
         entry (file+headline "~/doc/org/todos.org" "General Tasks")
         "* TODO [#B] %?\n:Created: %T\n "
         :empty-lines 0)
        ("c" "Code To-Do" ; execute this on the line of code you want to link it to
         entry (file+headline "~/doc/org/todos.org" "Code Related Tasks")
         "* TODO [#B] %?\n:Created: %T\n%i\n%a\nProposed Solution: "
         :empty-lines 0)
        ("m" "Meeting"
         entry (file+datetree "~/doc/org/meetings.org")
         "* %? :meeting:%^g \n:Created: %T\n** Attendees\n*** \n** Notes\n** Action Items\n*** TODO [#A] "
         :tree-type week
         :clock-in t
         :clock-resume t
         :empty-lines 0)

        ))

;; Tags
(setq org-tag-alist '(
                      ;; Ticket types (exclusive)
                      (:startgroup . nil)
                      ("@bug" . ?b)
                      ("@feature" . ?u)
                      ("@spike" . ?j)
                      (:endgroup . nil)

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

;; Tag colors
(setq org-tag-faces
      '(
        ("planning"  . (:foreground "mediumPurple1" :weight bold))
        ("backend"   . (:foreground "royalblue1"    :weight bold))
        ("frontend"  . (:foreground "forest green"  :weight bold))
        ("QA"        . (:foreground "sienna"        :weight bold))
        ("meeting"   . (:foreground "yellow1"       :weight bold))
        ("CRITICAL"  . (:foreground "red1"          :weight bold))
        )
      )

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

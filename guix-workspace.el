;;; guix-workspace.el --- manifest.scm workspace + guix shell wrapper -*- lexical-binding: t; -*-

(require 'compile)
(require 'subr-x)
(require 'files)

(defvar my/guix-shell-extra-args
  (list "-C" "-N" "-W"
        "--expose=/usr/bin/env"
        (concat "--share=" (expand-file-name "~/.claude"))
        (concat "--share=" (expand-file-name "~/.claude.json"))
        (concat "--share=" (expand-file-name "~/.gemini"))
        (concat "--share=" (expand-file-name "~/.codex"))
        "--share=/var/log/guix"
        "--share=/var/guix"
        "--share=/tmp") ; otherwise I don't see the failed builds (--keep-failed).
  "Extra args passed to `guix shell` when wrapping commands.")

(defun my/workspace-root ()
  "Workspace is the nearest parent containing manifest.scm."
  (locate-dominating-file (expand-file-name default-directory) "manifest.scm"))

(defun my/manifest-path ()
  "Absolute path to manifest.scm for current workspace, or nil."
  (let ((root (my/workspace-root)))
    (when root (expand-file-name "manifest.scm" root))))

(defun my/guix-auth-file ()
  (expand-file-name
   "shell-authorized-directories"
   (expand-file-name "guix" (or (getenv "XDG_CONFIG_HOME") "~/.config"))))

(defun my/authorized-shell-dir-p (dir)
  "Return non-nil if DIR is authorized in shell-authorized-directories."
  (let* ((auth-file (my/guix-auth-file))
         ;; Mirror guix/scripts/shell.scm: compare exact, absolute paths only.
         ;; Emacs: resolve DIR to the physical cwd (like getcwd), without
         ;; normalizing auth-file lines beyond trimming and absolute-path check.
         (dir (directory-file-name (file-truename (expand-file-name dir)))))
    (when (file-exists-p auth-file)
      (with-temp-buffer
        (insert-file-contents auth-file)
        (goto-char (point-min))
        (catch 'ok
          (while (not (eobp))
            (let* ((line (string-trim
                          (buffer-substring-no-properties
                           (line-beginning-position)
                           (line-end-position)))))
              (cond
               ((or (string-empty-p line) (string-prefix-p "#" line))
                nil)
               ;; Mirror guix/scripts/shell.scm authorized-shell-directory?:
               ;; only absolute paths are considered, and they must match exactly.
               ((string-prefix-p "/" line)
                (when (string= line dir)
                  (throw 'ok t)))
               (t
                nil)))
            (forward-line 1)))))))

(defun my/ensure-authorized-workspace (dir)
  "Ensure DIR is authorized. Prompt to add if not. Return non-nil if authorized."
  (let ((dir (directory-file-name (file-truename (expand-file-name dir)))))
    (if (my/authorized-shell-dir-p dir)
        t
      (when (yes-or-no-p
             (format "Authorize workspace %s in shell-authorized-directories? " dir))
        (let* ((auth-file (my/guix-auth-file))
               (auth-dir (file-name-directory auth-file)))
          (unless (file-directory-p auth-dir)
            (make-directory auth-dir t))
          (with-temp-buffer
            (insert dir "\n")
            (append-to-file (point-min) (point-max) auth-file))
          (message "Authorized %s" dir)
          t)))))

(defun my/guix-shell-runner-list ()
  "Return list for `agent-shell-container-command-runner` or nil.
Refuse to run uncontainerized when the workspace is not authorized."
  (let* ((manifest (my/manifest-path))
         (root (and manifest (file-name-directory manifest))))
    (when manifest
      (unless (my/ensure-authorized-workspace root)
        (user-error "Workspace %s not authorized; refusing non-containerized run" root))
      (append (list "guix" "shell")
              my/guix-shell-extra-args
              (list "-m" manifest "--")))))

(defun my/guix-shell-wrap-command (command)
  "Wrap COMMAND to run inside guix shell using manifest.scm.

  We always use /bin/sh inside the container. Guix guarantees /bin/sh exists in
  containers by symlinking bash there (see guix/scripts/environment.scm).

  Guix default shell is defined as %default-shell in:
    guix/scripts/environment.scm
  which is (or (getenv \"SHELL\") \"/bin/sh\")."
  (let* ((manifest (my/manifest-path))
         (root (and manifest (file-name-directory manifest))))
    (cond
     ((not manifest) command)
     ((not (my/ensure-authorized-workspace root))
      (user-error "Workspace %s not authorized" root))
     (t
      (format "guix shell %s -m %s -- /bin/sh -c %s"
              (mapconcat #'identity my/guix-shell-extra-args " ")
              (shell-quote-argument manifest)
              (shell-quote-argument command))))))

(defun my/compilation-start-around (orig command &rest args)
  (let ((default-directory (or (my/workspace-root) default-directory))
        (command (my/guix-shell-wrap-command command)))
    (apply orig command args)))

;; Idempotent advice setup
(advice-remove 'compilation-start #'my/compilation-start-around)
(advice-add 'compilation-start :around #'my/compilation-start-around)

(with-eval-after-load 'agent-shell
  (defun my/agent-shell--wrap-runner (orig &rest args)
    (let ((agent-shell-container-command-runner
           (or agent-shell-container-command-runner
               (my/guix-shell-runner-list))))
      (unless agent-shell-container-command-runner
        (user-error "No container runner configured"))
      (apply orig args)))
  (advice-remove 'agent-shell--make-acp-client #'my/agent-shell--wrap-runner)
  (advice-add 'agent-shell--make-acp-client :around #'my/agent-shell--wrap-runner))

(provide 'guix-workspace)
;;; guix-workspace.el ends here

{"payload":{"allShortcutsEnabled":false,"fileTree":{"src/extra":{"items":[{"name":"treemacs-all-the-icons.el","path":"src/extra/treemacs-all-the-icons.el","contentType":"file"},{"name":"treemacs-evil.el","path":"src/extra/treemacs-evil.el","contentType":"file"},{"name":"treemacs-icons-dired.el","path":"src/extra/treemacs-icons-dired.el","contentType":"file"},{"name":"treemacs-magit.el","path":"src/extra/treemacs-magit.el","contentType":"file"},{"name":"treemacs-mu4e.el","path":"src/extra/treemacs-mu4e.el","contentType":"file"},{"name":"treemacs-persp.el","path":"src/extra/treemacs-persp.el","contentType":"file"},{"name":"treemacs-perspective.el","path":"src/extra/treemacs-perspective.el","contentType":"file"},{"name":"treemacs-projectile.el","path":"src/extra/treemacs-projectile.el","contentType":"file"},{"name":"treemacs-tab-bar.el","path":"src/extra/treemacs-tab-bar.el","contentType":"file"}],"totalCount":9},"src":{"items":[{"name":"elisp","path":"src/elisp","contentType":"directory"},{"name":"extra","path":"src/extra","contentType":"directory"},{"name":"scripts","path":"src/scripts","contentType":"directory"}],"totalCount":3},"":{"items":[{"name":".github","path":".github","contentType":"directory"},{"name":"icons","path":"icons","contentType":"directory"},{"name":"screenshots","path":"screenshots","contentType":"directory"},{"name":"src","path":"src","contentType":"directory"},{"name":"test","path":"test","contentType":"directory"},{"name":".dir-locals.el","path":".dir-locals.el","contentType":"file"},{"name":".gitignore","path":".gitignore","contentType":"file"},{"name":".travis.yml","path":".travis.yml","contentType":"file"},{"name":"Cask","path":"Cask","contentType":"file"},{"name":"Changelog.org","path":"Changelog.org","contentType":"file"},{"name":"Extensions.org","path":"Extensions.org","contentType":"file"},{"name":"LICENSE","path":"LICENSE","contentType":"file"},{"name":"Makefile","path":"Makefile","contentType":"file"},{"name":"README.org","path":"README.org","contentType":"file"}],"totalCount":14}},"fileTreeProcessingTime":7.2103660000000005,"foldersToFetch":[],"repo":{"id":63552732,"defaultBranch":"master","name":"treemacs","ownerLogin":"Alexander-Miller","currentUserCanPush":false,"isFork":false,"isEmpty":false,"createdAt":"2016-07-17T21:13:35.000Z","ownerAvatar":"https://avatars.githubusercontent.com/u/5951157?v=4","public":true,"private":false,"isOrgOwned":false},"symbolsExpanded":false,"treeExpanded":true,"refInfo":{"name":"master","listCacheKey":"v0:1698838408.0","canEdit":false,"refType":"branch","currentOid":"df26b6ab9a0f467e5ff99f7ed97551ccf756e06c"},"path":"src/extra/treemacs-magit.el","currentUser":null,"blob":{"rawLines":[";;; treemacs-magit.el --- Magit integration for treemacs -*- lexical-binding: t -*-","",";; Copyright (C) 2023 Alexander Miller","",";; Author: Alexander Miller <alexanderm@web.de>",";; Package-Requires: ((emacs \"26.1\") (treemacs \"0.0\") (pfuture \"1.3\" ) (magit \"2.90.0\"))",";; Version: 0",";; Homepage: https://github.com/Alexander-Miller/treemacs","",";; This program is free software; you can redistribute it and/or modify",";; it under the terms of the GNU General Public License as published by",";; the Free Software Foundation, either version 3 of the License, or",";; (at your option) any later version.","",";; This program is distributed in the hope that it will be useful,",";; but WITHOUT ANY WARRANTY; without even the implied warranty of",";; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the",";; GNU General Public License for more details.","",";; You should have received a copy of the GNU General Public License",";; along with this program.  If not, see <https://www.gnu.org/licenses/>.","",";;; Commentary:",";;; Closing the gaps for filewatch- and git-modes in conjunction with magit.",";;; Specifically this package will hook into magit so as to artificially",";;; produce filewatch events for changes that treemacs would otherwise",";;; not catch, namely the committing and (un)staging of files.","",";;; Code:","","(require 'treemacs)","(require 'magit)","(require 'pfuture)","(require 'seq)","",";; no need for dash for a single when-let","(eval-when-compile","  (when (version< emacs-version \"26\")","    (defalias 'if-let* #'if-let)","    (defalias 'when-let* #'when-let)))","",";;;; Filewatch","","(defvar treemacs-magit--timers nil","  \"Cached list of roots an update is scheduled for.\")","","(defun treemacs-magit--schedule-update ()","  \"Schedule an update to potentially run after 3 seconds of idle time.","In order for the update to fully run several conditions must be met:"," * A timer for an update for the given directory must not already exist","   (see `treemacs-magit--timers')"," * The directory must be part of a treemacs workspace, and"," * The project must not be set for refresh already.\"","  (when treemacs-git-mode","    (let ((magit-root (treemacs-canonical-path (magit-toplevel))))","      (unless (member magit-root treemacs-magit--timers)","        (push magit-root treemacs-magit--timers)","        (run-with-idle-timer","         3 nil","         (lambda ()","           (unwind-protect","               (pcase treemacs--git-mode","                 ('simple","                  (treemacs-magit--simple-git-mode-update magit-root))","                 ((or 'extended 'deferred)","                  (treemacs-magit--extended-git-mode-update magit-root)))","             (setf treemacs-magit--timers (delete magit-root treemacs-magit--timers)))))))))","","(defun treemacs-magit--simple-git-mode-update (magit-root)","  \"Update the project at the given MAGIT-ROOT.","Without the parsing ability of extended git-mode this update uses","filewatch-mode's mechanics to update the entire project.\"","  (treemacs-run-in-every-buffer","   (when-let* ((project (treemacs--find-project-for-path magit-root))","               (dom-node (treemacs-find-in-dom (treemacs-project->path project))))","     (push (cons (treemacs-project->path project) 'force-refresh)","           (treemacs-dom-node->refresh-flag dom-node))","     (treemacs--start-filewatch-timer))))","","(defun treemacs-magit--extended-git-mode-update (magit-root)","  \"Update the project at the given MAGIT-ROOT.","This runs due to a commit or stash action, so we know that no files have","actually been added or deleted.  This allows us to forego rebuilding the entire","project structure just to be sure we caught everything.  Instead we grab the","current git status and just go through the lines as they are right now.\"","  ;; we run a single git process to update every buffer, so we need to gather","  ;; the visible dirs in every buffer","  ;; this collection may contain duplicates, but they are removed in python","  (-let [visible-dirs nil]","    (treemacs-run-in-every-buffer","     (dolist (dir (-some->> magit-root","                            (treemacs-find-in-dom)","                            (treemacs-dom-node->children)","                            (-map #'treemacs-dom-node->key)))","       (when (stringp dir)","         (push dir visible-dirs))))","    (pfuture-callback `(,treemacs-python-executable","                        \"-O\" \"-S\"","                        ,treemacs--git-status.py","                        ,magit-root","                        ,(number-to-string treemacs-max-git-entries)","                        ,treemacs-git-command-pipe","                        ,@visible-dirs)","      :directory magit-root","      :on-success","      (progn","        (ignore status)","        (treemacs-magit--update-callback magit-root pfuture-buffer)))))","","(defun treemacs-magit--update-callback (magit-root pfuture-buffer)","  \"Run the update as a pfuture callback.","Will update nodes under MAGIT-ROOT with output in PFUTURE-BUFFER.\"","  (let ((ht (read (pfuture-output-from-buffer pfuture-buffer))))","    (treemacs-run-in-every-buffer","     (let ((dom-node (or (treemacs-find-in-dom magit-root)","                         (when-let* ((project","                                      (seq-find","                                       (lambda (pr) (treemacs-is-path (treemacs-project->path pr) :in magit-root))","                                       (treemacs-workspace->projects (treemacs-current-workspace)))))","                           (treemacs-find-in-dom (treemacs-project->path project))))))","       (when (and dom-node","                  (treemacs-dom-node->position dom-node)","                  (treemacs-is-node-expanded? (treemacs-dom-node->position dom-node))","                  (null (treemacs-dom-node->refresh-flag dom-node)))","         (save-excursion","           (goto-char (treemacs-dom-node->position dom-node))","           (forward-line 1)","           (let* ((node (treemacs-node-at-point))","                  (start-depth (-some-> node (treemacs-button-get :depth)))","                  (curr-depth start-depth)","                  (path (-some-> node (treemacs-button-get :key))))","             (treemacs-with-writable-buffer","              (while (and node","                          (>= curr-depth start-depth))","                (when (and (stringp path)","                           (file-exists-p path))","                  (treemacs--git-face-quick-change","                   (treemacs-button-get node :key)","                   (or (ht-get ht path)","                       (if (memq (treemacs-button-get node :state)","                                 '(file-node-open file-node-closed))","                           'treemacs-git-unmodified-face","                         'treemacs-directory-face)))","                  (put-text-property (treemacs-button-start node) (treemacs-button-end node) 'face","                                     (or (ht-get ht path)","                                         (if (memq (treemacs-button-get node :state)","                                                   '(file-node-open file-node-closed))","                                             'treemacs-git-unmodified-face","                                           'treemacs-directory-face))))","                (forward-line 1)","                (if (eobp)","                    (setf node nil)","                  (setf node (treemacs-node-at-point)","                        path (-some-> node (treemacs-button-get :path))","                        curr-depth (-some-> node (treemacs-button-get :depth)))))))))))))","","(unless (featurep 'treemacs-magit)","  (add-hook 'magit-post-commit-hook      #'treemacs-magit--schedule-update)","  (add-hook 'git-commit-post-finish-hook #'treemacs-magit--schedule-update)","  (add-hook 'magit-post-stage-hook       #'treemacs-magit--schedule-update)","  (add-hook 'magit-post-unstage-hook     #'treemacs-magit--schedule-update))","",";;;; Git Commit Diff","","(defvar treemacs--git-commit-diff.py)","(defvar treemacs--commit-diff-ann-source)","","(defconst treemacs--commit-diff-update-commands","  (list \"pull\" \"push\" \"commit\" \"merge\" \"rebase\" \"cherry-pick\" \"fetch\" \"checkout\")","  \"List of git commands that change local/remote commit status info.","Relevant for integrating with `treemacs-git-commit-diff-mode'.\")","","(defun treemacs--update-commit-diff-after-magit-process (process &rest _)","  \"Update commit diffs after completion of a magit git PROCESS.\"","  (when (memq (process-status process) '(exit signal))","    (let* ((args (process-command process))","           (command (car (nthcdr (1+ (length magit-git-global-arguments)) args))))","      (when (member command treemacs--commit-diff-update-commands)","        (-let [path (process-get process 'default-dir)]","          (pfuture-callback `(,treemacs-python-executable \"-O\" ,treemacs--git-commit-diff.py ,path)","            :directory path","            :on-success","            (-let [out (-> (pfuture-callback-output)","                           (treemacs-string-trim-right)","                           (read))]","              (treemacs-run-in-every-buffer","               (-when-let* ((project (treemacs--find-project-for-path path))","                            (project-path (treemacs-project->path project)))","                 (if out","                     (treemacs-set-annotation-suffix","                      project-path out treemacs--commit-diff-ann-source)","                   (treemacs-remove-annotation-suffix project-path treemacs--commit-diff-ann-source))","                 (treemacs-apply-single-annotation project-path))))))))))","","(defun treemacs--magit-commit-diff-setup ()","  \"Enable or disable magit advice for `treemacs-git-commit-diff-mode'.\"","  (if (bound-and-true-p treemacs-git-commit-diff-mode)","      (advice-add #'magit-process-sentinel :after #'treemacs--update-commit-diff-after-magit-process)","    (advice-remove #'magit-process-sentinel #'treemacs--update-commit-diff-after-magit-process)))","","(unless (featurep 'treemacs-magit)","  (add-hook 'treemacs-git-commit-diff-mode-hook  #'treemacs--magit-commit-diff-setup)","  (when (bound-and-true-p treemacs-git-commit-diff-mode)","      (advice-add #'magit-process-sentinel :after #'treemacs--update-commit-diff-after-magit-process)))","","(provide 'treemacs-magit)","",";;; treemacs-magit.el ends here"],"stylingDirectives":[[{"start":0,"end":83,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"},{"start":61,"end":76,"cssClass":"pl-v"},{"start":78,"end":79,"cssClass":"pl-s"}],[],[{"start":0,"end":38,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[],[{"start":0,"end":47,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[{"start":0,"end":88,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[{"start":0,"end":13,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[{"start":0,"end":57,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[],[{"start":0,"end":71,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[{"start":0,"end":71,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[{"start":0,"end":68,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[{"start":0,"end":38,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[],[{"start":0,"end":66,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[{"start":0,"end":65,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[{"start":0,"end":64,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[{"start":0,"end":47,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[],[{"start":0,"end":68,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[{"start":0,"end":73,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[],[{"start":0,"end":15,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[{"start":0,"end":76,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[{"start":0,"end":72,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[{"start":0,"end":70,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[{"start":0,"end":62,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[],[{"start":0,"end":9,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[],[{"start":1,"end":8,"cssClass":"pl-c1"},{"start":9,"end":18,"cssClass":"pl-c1"}],[{"start":1,"end":8,"cssClass":"pl-c1"},{"start":9,"end":15,"cssClass":"pl-c1"}],[{"start":1,"end":8,"cssClass":"pl-c1"},{"start":9,"end":17,"cssClass":"pl-c1"}],[{"start":1,"end":8,"cssClass":"pl-c1"},{"start":9,"end":13,"cssClass":"pl-c1"}],[],[{"start":0,"end":41,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[{"start":1,"end":18,"cssClass":"pl-c1"}],[{"start":3,"end":7,"cssClass":"pl-k"},{"start":9,"end":17,"cssClass":"pl-c1"},{"start":32,"end":36,"cssClass":"pl-s"},{"start":32,"end":33,"cssClass":"pl-pds"},{"start":35,"end":36,"cssClass":"pl-pds"}],[{"start":5,"end":13,"cssClass":"pl-c1"},{"start":14,"end":22,"cssClass":"pl-c1"},{"start":23,"end":31,"cssClass":"pl-c1"},{"start":24,"end":31,"cssClass":"pl-c1"}],[{"start":5,"end":13,"cssClass":"pl-c1"},{"start":14,"end":24,"cssClass":"pl-c1"},{"start":25,"end":35,"cssClass":"pl-c1"},{"start":26,"end":35,"cssClass":"pl-c1"}],[],[{"start":0,"end":14,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[],[{"start":1,"end":7,"cssClass":"pl-k"},{"start":8,"end":30,"cssClass":"pl-en"},{"start":31,"end":34,"cssClass":"pl-c1"}],[{"start":2,"end":52,"cssClass":"pl-s"},{"start":2,"end":3,"cssClass":"pl-pds"},{"start":51,"end":52,"cssClass":"pl-pds"}],[],[{"start":1,"end":6,"cssClass":"pl-k"},{"start":7,"end":38,"cssClass":"pl-e"}],[{"start":2,"end":70,"cssClass":"pl-s"},{"start":2,"end":3,"cssClass":"pl-pds"}],[{"start":0,"end":68,"cssClass":"pl-s"}],[{"start":0,"end":71,"cssClass":"pl-s"}],[{"start":0,"end":33,"cssClass":"pl-s"},{"start":8,"end":32,"cssClass":"pl-smi"}],[{"start":0,"end":58,"cssClass":"pl-s"}],[{"start":0,"end":52,"cssClass":"pl-s"},{"start":51,"end":52,"cssClass":"pl-pds"}],[{"start":3,"end":7,"cssClass":"pl-v"},{"start":8,"end":25,"cssClass":"pl-v"}],[{"start":5,"end":8,"cssClass":"pl-k"}],[{"start":7,"end":13,"cssClass":"pl-k"},{"start":15,"end":21,"cssClass":"pl-k"}],[{"start":9,"end":13,"cssClass":"pl-k"}],[{"start":9,"end":28,"cssClass":"pl-c1"}],[{"start":9,"end":10,"cssClass":"pl-c1"},{"start":11,"end":14,"cssClass":"pl-c1"}],[{"start":10,"end":16,"cssClass":"pl-k"}],[{"start":12,"end":26,"cssClass":"pl-v"}],[{"start":16,"end":21,"cssClass":"pl-k"}],[{"start":18,"end":25,"cssClass":"pl-c1"}],[],[{"start":19,"end":21,"cssClass":"pl-k"},{"start":22,"end":31,"cssClass":"pl-c1"},{"start":32,"end":41,"cssClass":"pl-c1"}],[],[{"start":14,"end":18,"cssClass":"pl-k"},{"start":43,"end":49,"cssClass":"pl-c1"}],[],[{"start":1,"end":6,"cssClass":"pl-k"},{"start":7,"end":45,"cssClass":"pl-e"},{"start":47,"end":57,"cssClass":"pl-v"}],[{"start":2,"end":46,"cssClass":"pl-s"},{"start":2,"end":3,"cssClass":"pl-pds"}],[{"start":0,"end":65,"cssClass":"pl-s"}],[{"start":0,"end":57,"cssClass":"pl-s"},{"start":56,"end":57,"cssClass":"pl-pds"}],[{"start":3,"end":31,"cssClass":"pl-v"}],[{"start":4,"end":13,"cssClass":"pl-c1"}],[{"start":16,"end":24,"cssClass":"pl-c1"}],[{"start":6,"end":10,"cssClass":"pl-k"},{"start":12,"end":16,"cssClass":"pl-k"},{"start":50,"end":64,"cssClass":"pl-c1"}],[],[],[],[{"start":1,"end":6,"cssClass":"pl-k"},{"start":7,"end":47,"cssClass":"pl-e"},{"start":49,"end":59,"cssClass":"pl-v"}],[{"start":2,"end":46,"cssClass":"pl-s"},{"start":2,"end":3,"cssClass":"pl-pds"}],[{"start":0,"end":72,"cssClass":"pl-s"}],[{"start":0,"end":79,"cssClass":"pl-s"}],[{"start":0,"end":76,"cssClass":"pl-s"}],[{"start":0,"end":72,"cssClass":"pl-s"},{"start":71,"end":72,"cssClass":"pl-pds"}],[{"start":2,"end":77,"cssClass":"pl-c"},{"start":2,"end":3,"cssClass":"pl-c"}],[{"start":2,"end":37,"cssClass":"pl-c"},{"start":2,"end":3,"cssClass":"pl-c"}],[{"start":2,"end":75,"cssClass":"pl-c"},{"start":2,"end":3,"cssClass":"pl-c"}],[{"start":4,"end":7,"cssClass":"pl-v"},{"start":9,"end":21,"cssClass":"pl-v"},{"start":22,"end":25,"cssClass":"pl-v"}],[],[{"start":6,"end":12,"cssClass":"pl-k"},{"start":26,"end":27,"cssClass":"pl-k"}],[],[],[{"start":34,"end":58,"cssClass":"pl-c1"},{"start":35,"end":58,"cssClass":"pl-c1"}],[{"start":8,"end":12,"cssClass":"pl-k"},{"start":14,"end":21,"cssClass":"pl-c1"}],[{"start":10,"end":14,"cssClass":"pl-k"}],[{"start":24,"end":51,"cssClass":"pl-c1"},{"start":24,"end":25,"cssClass":"pl-mi1"}],[{"start":24,"end":28,"cssClass":"pl-s"},{"start":24,"end":25,"cssClass":"pl-pds"},{"start":27,"end":28,"cssClass":"pl-pds"},{"start":29,"end":33,"cssClass":"pl-s"},{"start":29,"end":30,"cssClass":"pl-pds"},{"start":32,"end":33,"cssClass":"pl-pds"}],[{"start":24,"end":45,"cssClass":"pl-c1"},{"start":24,"end":25,"cssClass":"pl-mi1"}],[{"start":24,"end":35,"cssClass":"pl-c1"},{"start":24,"end":25,"cssClass":"pl-mi1"}],[{"start":26,"end":42,"cssClass":"pl-c1"}],[{"start":24,"end":50,"cssClass":"pl-c1"},{"start":24,"end":25,"cssClass":"pl-mi1"}],[{"start":24,"end":38,"cssClass":"pl-c1"}],[{"start":6,"end":16,"cssClass":"pl-c1"}],[{"start":6,"end":17,"cssClass":"pl-c1"}],[{"start":7,"end":12,"cssClass":"pl-k"}],[{"start":9,"end":15,"cssClass":"pl-c1"}],[],[],[{"start":1,"end":6,"cssClass":"pl-k"},{"start":7,"end":38,"cssClass":"pl-e"},{"start":40,"end":50,"cssClass":"pl-v"},{"start":51,"end":65,"cssClass":"pl-v"}],[{"start":2,"end":40,"cssClass":"pl-s"},{"start":2,"end":3,"cssClass":"pl-pds"}],[{"start":0,"end":66,"cssClass":"pl-s"},{"start":65,"end":66,"cssClass":"pl-pds"}],[{"start":3,"end":6,"cssClass":"pl-v"},{"start":13,"end":17,"cssClass":"pl-c1"}],[],[{"start":6,"end":9,"cssClass":"pl-k"},{"start":12,"end":20,"cssClass":"pl-c1"},{"start":22,"end":24,"cssClass":"pl-k"}],[{"start":26,"end":35,"cssClass":"pl-c1"}],[{"start":39,"end":47,"cssClass":"pl-c1"}],[{"start":40,"end":46,"cssClass":"pl-k"},{"start":48,"end":50,"cssClass":"pl-v"},{"start":53,"end":69,"cssClass":"pl-v"},{"start":98,"end":101,"cssClass":"pl-c1"},{"start":102,"end":112,"cssClass":"pl-v"}],[],[],[{"start":8,"end":12,"cssClass":"pl-k"},{"start":14,"end":17,"cssClass":"pl-k"}],[],[{"start":44,"end":46,"cssClass":"pl-c1"}],[{"start":19,"end":23,"cssClass":"pl-k"}],[{"start":10,"end":24,"cssClass":"pl-c1"}],[{"start":12,"end":21,"cssClass":"pl-c1"}],[{"start":12,"end":24,"cssClass":"pl-c1"},{"start":25,"end":26,"cssClass":"pl-c1"}],[{"start":12,"end":16,"cssClass":"pl-k"}],[{"start":38,"end":39,"cssClass":"pl-k"},{"start":66,"end":72,"cssClass":"pl-c1"}],[],[{"start":31,"end":32,"cssClass":"pl-k"},{"start":59,"end":63,"cssClass":"pl-c1"}],[],[{"start":15,"end":20,"cssClass":"pl-k"},{"start":22,"end":25,"cssClass":"pl-k"}],[{"start":27,"end":29,"cssClass":"pl-k"}],[{"start":17,"end":21,"cssClass":"pl-k"},{"start":23,"end":26,"cssClass":"pl-k"},{"start":28,"end":35,"cssClass":"pl-c1"}],[{"start":28,"end":41,"cssClass":"pl-c1"}],[],[{"start":45,"end":49,"cssClass":"pl-c1"}],[{"start":20,"end":22,"cssClass":"pl-k"}],[{"start":24,"end":26,"cssClass":"pl-k"},{"start":28,"end":32,"cssClass":"pl-c1"},{"start":59,"end":65,"cssClass":"pl-c1"}],[],[{"start":27,"end":56,"cssClass":"pl-c1"}],[{"start":25,"end":49,"cssClass":"pl-c1"}],[{"start":19,"end":36,"cssClass":"pl-c1"},{"start":93,"end":98,"cssClass":"pl-c1"}],[{"start":38,"end":40,"cssClass":"pl-k"}],[{"start":42,"end":44,"cssClass":"pl-k"},{"start":46,"end":50,"cssClass":"pl-c1"},{"start":77,"end":83,"cssClass":"pl-c1"}],[],[{"start":45,"end":74,"cssClass":"pl-c1"}],[{"start":43,"end":67,"cssClass":"pl-c1"}],[{"start":17,"end":29,"cssClass":"pl-c1"},{"start":30,"end":31,"cssClass":"pl-c1"}],[{"start":17,"end":19,"cssClass":"pl-k"},{"start":21,"end":25,"cssClass":"pl-c1"}],[{"start":21,"end":25,"cssClass":"pl-k"},{"start":31,"end":34,"cssClass":"pl-c1"}],[{"start":19,"end":23,"cssClass":"pl-k"}],[{"start":36,"end":37,"cssClass":"pl-k"},{"start":64,"end":69,"cssClass":"pl-c1"}],[{"start":42,"end":43,"cssClass":"pl-k"},{"start":70,"end":76,"cssClass":"pl-c1"}],[],[{"start":1,"end":7,"cssClass":"pl-k"},{"start":9,"end":17,"cssClass":"pl-c1"},{"start":18,"end":33,"cssClass":"pl-c1"}],[{"start":3,"end":11,"cssClass":"pl-c1"},{"start":12,"end":35,"cssClass":"pl-c1"},{"start":41,"end":74,"cssClass":"pl-c1"},{"start":42,"end":74,"cssClass":"pl-c1"}],[{"start":3,"end":11,"cssClass":"pl-c1"},{"start":12,"end":40,"cssClass":"pl-c1"},{"start":41,"end":74,"cssClass":"pl-c1"},{"start":42,"end":74,"cssClass":"pl-c1"}],[{"start":3,"end":11,"cssClass":"pl-c1"},{"start":12,"end":34,"cssClass":"pl-c1"},{"start":41,"end":74,"cssClass":"pl-c1"},{"start":42,"end":74,"cssClass":"pl-c1"}],[{"start":3,"end":11,"cssClass":"pl-c1"},{"start":12,"end":36,"cssClass":"pl-c1"},{"start":41,"end":74,"cssClass":"pl-c1"},{"start":42,"end":74,"cssClass":"pl-c1"}],[],[{"start":0,"end":20,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[],[{"start":1,"end":7,"cssClass":"pl-k"}],[{"start":1,"end":7,"cssClass":"pl-k"},{"start":8,"end":40,"cssClass":"pl-en"}],[],[{"start":1,"end":9,"cssClass":"pl-k"},{"start":10,"end":47,"cssClass":"pl-en"}],[{"start":3,"end":7,"cssClass":"pl-k"},{"start":8,"end":14,"cssClass":"pl-s"},{"start":8,"end":9,"cssClass":"pl-pds"},{"start":13,"end":14,"cssClass":"pl-pds"},{"start":15,"end":21,"cssClass":"pl-s"},{"start":15,"end":16,"cssClass":"pl-pds"},{"start":20,"end":21,"cssClass":"pl-pds"},{"start":22,"end":30,"cssClass":"pl-s"},{"start":22,"end":23,"cssClass":"pl-pds"},{"start":29,"end":30,"cssClass":"pl-pds"},{"start":31,"end":38,"cssClass":"pl-s"},{"start":31,"end":32,"cssClass":"pl-pds"},{"start":37,"end":38,"cssClass":"pl-pds"},{"start":39,"end":47,"cssClass":"pl-s"},{"start":39,"end":40,"cssClass":"pl-pds"},{"start":46,"end":47,"cssClass":"pl-pds"},{"start":48,"end":61,"cssClass":"pl-s"},{"start":48,"end":49,"cssClass":"pl-pds"},{"start":60,"end":61,"cssClass":"pl-pds"},{"start":62,"end":69,"cssClass":"pl-s"},{"start":62,"end":63,"cssClass":"pl-pds"},{"start":68,"end":69,"cssClass":"pl-pds"},{"start":70,"end":80,"cssClass":"pl-s"},{"start":70,"end":71,"cssClass":"pl-pds"},{"start":79,"end":80,"cssClass":"pl-pds"}],[{"start":2,"end":68,"cssClass":"pl-s"},{"start":2,"end":3,"cssClass":"pl-pds"}],[{"start":0,"end":63,"cssClass":"pl-s"},{"start":30,"end":61,"cssClass":"pl-smi"},{"start":62,"end":63,"cssClass":"pl-pds"}],[],[{"start":1,"end":6,"cssClass":"pl-k"},{"start":7,"end":55,"cssClass":"pl-e"},{"start":57,"end":64,"cssClass":"pl-v"},{"start":65,"end":70,"cssClass":"pl-c1"},{"start":71,"end":72,"cssClass":"pl-v"}],[{"start":2,"end":64,"cssClass":"pl-s"},{"start":2,"end":3,"cssClass":"pl-pds"},{"start":63,"end":64,"cssClass":"pl-pds"}],[{"start":3,"end":7,"cssClass":"pl-v"},{"start":9,"end":13,"cssClass":"pl-c1"},{"start":15,"end":29,"cssClass":"pl-c1"},{"start":41,"end":45,"cssClass":"pl-c1"}],[{"start":5,"end":9,"cssClass":"pl-k"},{"start":18,"end":33,"cssClass":"pl-c1"}],[{"start":21,"end":24,"cssClass":"pl-k"},{"start":26,"end":32,"cssClass":"pl-k"},{"start":34,"end":36,"cssClass":"pl-c1"},{"start":38,"end":44,"cssClass":"pl-k"}],[{"start":7,"end":11,"cssClass":"pl-k"},{"start":13,"end":19,"cssClass":"pl-k"}],[{"start":21,"end":32,"cssClass":"pl-c1"},{"start":41,"end":53,"cssClass":"pl-c1"}],[{"start":30,"end":57,"cssClass":"pl-c1"},{"start":30,"end":31,"cssClass":"pl-mi1"},{"start":58,"end":62,"cssClass":"pl-s"},{"start":58,"end":59,"cssClass":"pl-pds"},{"start":61,"end":62,"cssClass":"pl-pds"},{"start":63,"end":89,"cssClass":"pl-c1"},{"start":63,"end":64,"cssClass":"pl-mi1"},{"start":93,"end":98,"cssClass":"pl-c1"},{"start":93,"end":94,"cssClass":"pl-mi1"}],[{"start":12,"end":22,"cssClass":"pl-c1"}],[{"start":12,"end":23,"cssClass":"pl-c1"}],[{"start":25,"end":26,"cssClass":"pl-k"}],[],[{"start":28,"end":32,"cssClass":"pl-c1"}],[],[],[],[{"start":18,"end":20,"cssClass":"pl-k"}],[],[],[],[],[],[{"start":1,"end":6,"cssClass":"pl-k"},{"start":7,"end":40,"cssClass":"pl-e"}],[{"start":2,"end":71,"cssClass":"pl-s"},{"start":2,"end":3,"cssClass":"pl-pds"},{"start":38,"end":69,"cssClass":"pl-smi"},{"start":70,"end":71,"cssClass":"pl-pds"}],[{"start":3,"end":5,"cssClass":"pl-v"},{"start":7,"end":23,"cssClass":"pl-c1"}],[{"start":7,"end":17,"cssClass":"pl-c1"},{"start":18,"end":42,"cssClass":"pl-c1"},{"start":19,"end":42,"cssClass":"pl-c1"},{"start":43,"end":49,"cssClass":"pl-c1"},{"start":50,"end":100,"cssClass":"pl-c1"},{"start":51,"end":100,"cssClass":"pl-c1"}],[{"start":5,"end":18,"cssClass":"pl-c1"},{"start":19,"end":43,"cssClass":"pl-c1"},{"start":20,"end":43,"cssClass":"pl-c1"},{"start":44,"end":94,"cssClass":"pl-c1"},{"start":45,"end":94,"cssClass":"pl-c1"}],[],[{"start":1,"end":7,"cssClass":"pl-k"},{"start":9,"end":17,"cssClass":"pl-c1"},{"start":18,"end":33,"cssClass":"pl-c1"}],[{"start":3,"end":11,"cssClass":"pl-c1"},{"start":12,"end":47,"cssClass":"pl-c1"},{"start":49,"end":84,"cssClass":"pl-c1"},{"start":50,"end":84,"cssClass":"pl-c1"}],[{"start":3,"end":7,"cssClass":"pl-k"},{"start":9,"end":25,"cssClass":"pl-c1"}],[{"start":7,"end":17,"cssClass":"pl-c1"},{"start":18,"end":42,"cssClass":"pl-c1"},{"start":19,"end":42,"cssClass":"pl-c1"},{"start":43,"end":49,"cssClass":"pl-c1"},{"start":50,"end":100,"cssClass":"pl-c1"},{"start":51,"end":100,"cssClass":"pl-c1"}],[],[{"start":1,"end":8,"cssClass":"pl-c1"},{"start":9,"end":24,"cssClass":"pl-c1"}],[],[{"start":0,"end":31,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}]],"csv":null,"csvError":null,"dependabotInfo":{"showConfigurationBanner":false,"configFilePath":null,"networkDependabotPath":"/Alexander-Miller/treemacs/network/updates","dismissConfigurationNoticePath":"/settings/dismiss-notice/dependabot_configuration_notice","configurationNoticeDismissed":null,"repoAlertsPath":"/Alexander-Miller/treemacs/security/dependabot","repoSecurityAndAnalysisPath":"/Alexander-Miller/treemacs/settings/security_analysis","repoOwnerIsOrg":false,"currentUserCanAdminRepo":false},"displayName":"treemacs-magit.el","displayUrl":"https://github.com/Alexander-Miller/treemacs/blob/master/src/extra/treemacs-magit.el?raw=true","headerInfo":{"blobSize":"9.86 KB","deleteInfo":{"deleteTooltip":"You must be signed in to make or propose changes"},"editInfo":{"editTooltip":"You must be signed in to make or propose changes"},"ghDesktopPath":"https://desktop.github.com","gitLfsPath":null,"onBranch":true,"shortPath":"732ccb4","siteNavLoginPath":"/login?return_to=https%3A%2F%2Fgithub.com%2FAlexander-Miller%2Ftreemacs%2Fblob%2Fmaster%2Fsrc%2Fextra%2Ftreemacs-magit.el","isCSV":false,"isRichtext":false,"toc":null,"lineInfo":{"truncatedLoc":"208","truncatedSloc":"184"},"mode":"file"},"image":false,"isCodeownersFile":null,"isPlain":false,"isValidLegacyIssueTemplate":false,"issueTemplateHelpUrl":"https://docs.github.com/articles/about-issue-and-pull-request-templates","issueTemplate":null,"discussionTemplate":null,"language":"Emacs Lisp","languageID":102,"large":false,"loggedIn":false,"newDiscussionPath":"/Alexander-Miller/treemacs/discussions/new","newIssuePath":"/Alexander-Miller/treemacs/issues/new","planSupportInfo":{"repoIsFork":null,"repoOwnedByCurrentUser":null,"requestFullPath":"/Alexander-Miller/treemacs/blob/master/src/extra/treemacs-magit.el","showFreeOrgGatedFeatureMessage":null,"showPlanSupportBanner":null,"upgradeDataAttributes":null,"upgradePath":null},"publishBannersInfo":{"dismissActionNoticePath":"/settings/dismiss-notice/publish_action_from_dockerfile","releasePath":"/Alexander-Miller/treemacs/releases/new?marketplace=true","showPublishActionBanner":false},"rawBlobUrl":"https://github.com/Alexander-Miller/treemacs/raw/master/src/extra/treemacs-magit.el","renderImageOrRaw":false,"richText":null,"renderedFileInfo":null,"shortPath":null,"symbolsEnabled":true,"tabSize":8,"topBannersInfo":{"overridingGlobalFundingFile":false,"globalPreferredFundingPath":null,"repoOwner":"Alexander-Miller","repoName":"treemacs","showInvalidCitationWarning":false,"citationHelpUrl":"https://docs.github.com/github/creating-cloning-and-archiving-repositories/creating-a-repository-on-github/about-citation-files","showDependabotConfigurationBanner":false,"actionsOnboardingTip":null},"truncated":false,"viewable":true,"workflowRedirectUrl":null,"symbols":{"timed_out":false,"not_analyzed":true,"symbols":[]}},"copilotInfo":null,"copilotAccessAllowed":false,"csrf_tokens":{"/Alexander-Miller/treemacs/branches":{"post":"dYB2NRhXpegDdBEjoc547tA-BupcGB4kJU45f1CGSM02DWJuC_R8N-CQxfQq8sbFX04nMRy1DtCT1alaWgOufw"},"/repos/preferences":{"post":"bfArQ8Vh4seiT4hG4-SlfMeptETNmiNyGw-z-H98pyCZawdH6oo3tjB6ZZ7PyO6JvGx2m6zAmOw0GqvqlluUXQ"}}},"title":"treemacs/src/extra/treemacs-magit.el at master · Alexander-Miller/treemacs"}
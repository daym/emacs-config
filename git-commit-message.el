;; -*- lexical-binding: t; -*-

;;; This module provides a way to auto-prepare a commit message (from the file content).
;;; Main export: my/generate-lisp-commit-message

(require 'ert)
(require 'cl-lib)

(defun my/parse-exactly-one-list (sexp-string)
  "Parse exactly one S-expression from a string and ensure no leftover content.
If there is leftover content, return nil."
  (save-excursion
    (with-temp-buffer
      (insert sexp-string)
      (let* ((pos (scan-lists (point-min) 1 0))
             (result (if pos (buffer-substring-no-properties (point-min) pos) nil))
             (rest (if pos (buffer-substring-no-properties pos (point-max)) "")))
        (if (and rest (string-match "^[ \t\n]*$" rest))
            result
          nil)))))

(ert-deftest my/test-parse-exactly-one-list ()
  "Test cases for `my/parse-exactly-one-list`."
  (should (equal "(define-public foo-1.0)"
                 (my/parse-exactly-one-list "(define-public foo-1.0)")))
  (should (equal "  (define-public bar-2.0)"
                 (my/parse-exactly-one-list "  (define-public bar-2.0)  ")))
  (should (equal "((a b) (c d))"
                 (my/parse-exactly-one-list "((a b) (c d))")))
  (should (equal (mapconcat #'identity
                            '(""
                              "(define-public rust-matrix-sdk-store-encryption-0.9"
                              "  (package"
                              "    (name \"rust-matrix-sdk-store-encryption\")"
                              "    (version \"0.10.0\")"
                              "    (source"
                              "     (origin"
                              "       (method url-fetch)"
                              "       (uri (crate-uri \"matrix-sdk-store-encryption\" version))"
                              "       (file-name (string-append name \"-\" version \".tar.gz\"))"
                              "       (sha256" "        (base32 \"0b8ah52nqi6fmm31j243kp00bvqcd646k42z9rk57yap0xjvdj6w\"))))"
                              "    (build-system cargo-build-system)"
                              "    (arguments"
                              "     `(#:skip-build? #t"
                              "       #:cargo-inputs ((\"rust-base64\" ,rust-base64-0.22)"
                              "                       (\"rust-blake3\" ,rust-blake3-1)"
                              "                       (\"rust-chacha20poly1305\" ,rust-chacha20poly1305-0.10)"
                              "                       (\"rust-getrandom\" ,rust-getrandom-0.2)"
                              "                       (\"rust-hmac\" ,rust-hmac-0.12)"
                              "                       (\"rust-pbkdf2\" ,rust-pbkdf2-0.12)"
                              "                       (\"rust-rand\" ,rust-rand-0.8)"
                              "                       (\"rust-rmp-serde\" ,rust-rmp-serde-1)"
                              "                       (\"rust-serde\" ,rust-serde-1)"
                              "                       (\"rust-serde-json\" ,rust-serde-json-1)"
                              "                       (\"rust-sha2\" ,rust-sha2-0.10)" "                       (\"rust-thiserror\" ,rust-thiserror-2)"
                              "                       (\"rust-zeroize\" ,rust-zeroize-1))))"
                              "    (home-page \"https://github.com/matrix-org/matrix-rust-sdk\")"
                              "    (synopsis \"Helpers for encrypted storage keys for the Matrix SDK\")"
                              "    (description"
                              "     \"This package provides Helpers for encrypted storage keys for the Matrix SDK.\")"
                              "    (license license:asl2.0)))"))
                 (my/parse-exactly-one-list (mapconcat #'identity
                                                       '(""
                                                         "(define-public rust-matrix-sdk-store-encryption-0.9"
                                                         "  (package"
                                                         "    (name \"rust-matrix-sdk-store-encryption\")"
                                                         "    (version \"0.10.0\")"
                                                         "    (source"
                                                         "     (origin"
                                                         "       (method url-fetch)"
                                                         "       (uri (crate-uri \"matrix-sdk-store-encryption\" version))"
                                                         "       (file-name (string-append name \"-\" version \".tar.gz\"))"
                                                         "       (sha256" "        (base32 \"0b8ah52nqi6fmm31j243kp00bvqcd646k42z9rk57yap0xjvdj6w\"))))"
                                                         "    (build-system cargo-build-system)"
                                                         "    (arguments"
                                                         "     `(#:skip-build? #t"
                                                         "       #:cargo-inputs ((\"rust-base64\" ,rust-base64-0.22)"
                                                         "                       (\"rust-blake3\" ,rust-blake3-1)"
                                                         "                       (\"rust-chacha20poly1305\" ,rust-chacha20poly1305-0.10)"
                                                         "                       (\"rust-getrandom\" ,rust-getrandom-0.2)"
                                                         "                       (\"rust-hmac\" ,rust-hmac-0.12)"
                                                         "                       (\"rust-pbkdf2\" ,rust-pbkdf2-0.12)"
                                                         "                       (\"rust-rand\" ,rust-rand-0.8)"
                                                         "                       (\"rust-rmp-serde\" ,rust-rmp-serde-1)"
                                                         "                       (\"rust-serde\" ,rust-serde-1)"
                                                         "                       (\"rust-serde-json\" ,rust-serde-json-1)"
                                                         "                       (\"rust-sha2\" ,rust-sha2-0.10)" "                       (\"rust-thiserror\" ,rust-thiserror-2)"
                                                         "                       (\"rust-zeroize\" ,rust-zeroize-1))))"
                                                         "    (home-page \"https://github.com/matrix-org/matrix-rust-sdk\")"
                                                         "    (synopsis \"Helpers for encrypted storage keys for the Matrix SDK\")"
                                                         "    (description"
                                                         "     \"This package provides Helpers for encrypted storage keys for the Matrix SDK.\")"
                                                         "    (license license:asl2.0)))")))))
  (should (equal nil (my/parse-exactly-one-list "(define-public foo-1.0) (define-public bar-2.0)")))
                                        ;  (should (equal nil (my/parse-exactly-one-list "")))
  (should (equal nil (condition-case ex
                         (my/parse-exactly-one-list "(define-public foo-1.0")
                       ('scan-error nil)))) ; scan-error
  (should (equal nil (my/parse-exactly-one-list "(define-public foo-1.0))")))
  (should (equal nil (my/parse-exactly-one-list "(define-public foo-1.0) extra text"))))

(defun my/diff-lines->files (lines)
  (cl-remove-duplicates
   (cl-loop for line in lines
            when (string-match "^diff --git \\([^ ]+\\)" line)
            collect (match-string 1 line))
   :test 'string=))

(ert-deftest my/test-diff-lines->files ()
  "Test the my/diff-lines->files function."
  (let ((diff "diff --git a/path/filename1.scm b/path/filename1.scm
index 0000001..1234567
--- a/path/filename1.scm
+++ b/path/filename1.scm
@@ -1,3 +1,4 @@
+ (define-public package-0.7)
diff --git a/path/filename2.scm b/path/filename2.scm
index 0000001..1234567
--- a/path/filename2.scm
+++ b/path/filename2.scm
@@ -1,3 +1,4 @@
+ (define-public another-package-0.8)"))
    (should (equal (my/diff-lines->files (split-string diff "\n"))
                   '("a/path/filename1.scm" "a/path/filename2.scm")))))
(defun my/diff-lines->block-lines (lines)
  "Collect one continuous block starting with a single '+'."
  (let ((result nil)
        (in-block nil))
    (catch 'multiple-blocks
      (dolist (line lines)
        (cond
         ((string-prefix-p "+++ " line) nil) ; Skip diff headers
         ((string-prefix-p "+" line)
          (if (and (not in-block) result)
              (throw 'multiple-blocks nil)
            (setq in-block t)
            (push (substring line 1) result)))
         (t (setq in-block nil))))
      (nreverse result))))

(ert-deftest my/test-diff-lines->block-lines ()
  "Test the my/diff-lines->blocks function."
  (let ((diff "diff --git a/path/filename.scm b/path/filename.scm
index 0000001..1234567
--- a/path/filename.scm
+++ b/path/filename.scm
@@ -1,3 +1,4 @@
+(define-public package-0.7
+blub)"))
    (should (equal (my/diff-lines->block-lines (split-string diff "\n"))
                   '("(define-public package-0.7" "blub)")))))

(ert-deftest my/test-diff-lines->block-lines2 ()
  "Test the my/diff-lines->blocks function."
  (let ((diff "diff --git a/path/filename.scm b/path/filename.scm
index 0000001..1234567
--- a/path/filename.scm
+++ b/path/filename.scm
@@ -1,3 +1,4 @@
+(define-public package-0.7 (package))
"))
    (should (equal (my/diff-lines->block-lines (split-string diff "\n"))
                   '("(define-public package-0.7 (package))")))))

(defun my/guix-split-variable-name (text)
  "Split a text of the form <package-name>-<package-version> into `(,package-name ,package-version).
Assumes versions start with a digit.  If in doubt, returns the symbol 'nil (because actual nil seems
to be impossible to put in a list)."
  (if (null text)
      `(nil nil)
    (let* ((parts (split-string text "-"))
           (version-part nil)
           (name-part parts))
      (pcase (length parts)
        (0 '(nil nil))
        (1 `(,text))
        (_
         (let ((last-part (car (last parts))))
           (when (string-match "^[0-9][0-9.]*" last-part)
             (setq version-part last-part)
             (setq name-part (butlast parts))))))
      (list (mapconcat 'identity name-part "-") version-part))))

(ert-deftest my/test-guix-split-variable-name ()
  "Test the my/guix-split-variable-name function."
  (should (equal (my/guix-split-variable-name "package") '("package" nil)))
  (should (equal (my/guix-split-variable-name "package-0") '("package" "0")))
  (should (equal (my/guix-split-variable-name "package-0.7") '("package" "0.7")))
  (should (equal (my/guix-split-variable-name "package-name-0.7") '("package-name" "0.7")))
  (should (equal (my/guix-split-variable-name "package-name-with-dash-0.7") '("package-name-with-dash" "0.7")))
  (should (equal (my/guix-split-variable-name "package-without-version") '("package-without-version" nil))))

(defun my/strip-prefix (prefix string)
  "Remove PREFIX from the beginning of STRING if it exists."
  (if (string-prefix-p prefix string)
      (substring string (length prefix))
    string))

(defun my/generate-lisp-commit-message ()
  "Auto-generate commit message for single-package additions."
  (when (magit-anything-staged-p)
    (let* ((lines (magit-git-lines "diff" "--cached"))
           (files (my/diff-lines->files lines))
           (block-lines (my/diff-lines->block-lines lines)))
      (when (and (= (length files) 1) block-lines)
        (let* ((block-string (mapconcat 'identity block-lines "\n"))
               (block-string (string-trim (or (my/parse-exactly-one-list block-string) "")))
               (package-name-version
                (and (string-match "^(define-public \\([a-z0-9*?.-]+\\)" block-string)
                     (match-string 1 block-string))))
          (pcase (my/guix-split-variable-name package-name-version)
            (`(nil nil) nil)
            (`(,package-name ,package-version)
             (save-excursion
               (goto-char (point-min))
               (delete-region (point-min) (point-max)) ;; Clear the buffer (... we shouldn't need that)
               (insert (format "gnu: Add %s@%s.

* %s (%s-%s): New variable."
                               package-name
                               package-version
                               (my/strip-prefix "c/" (car files))
                               package-name
                               package-version))
               (buffer-string)))))))))

(defun my/test-generate-lisp-commit-message-setup (diff-content)
  "Helper function to set up the buffer with diff content and to mock magit-git-string."
  (with-temp-buffer
    (insert diff-content)
    (cl-letf (((symbol-function #'magit-git-lines)
               (lambda (cmd &rest args) (string-split (buffer-string) "\n")))
              ((symbol-function #'magit-anything-staged-p)
               (lambda (&rest args) t)))
      (my/generate-lisp-commit-message))))

;; Define the test cases
(ert-deftest my/test-generate-lisp-commit-message-single-block ()
  "Test the my/generate-lisp-commit-message function with a single block."
  (let ((diff "diff --git a/path/filename.scm b/path/filename.scm
index 0000001..1234567
--- a/path/filename.scm
+++ b/path/filename.scm
@@ -1,3 +1,4 @@
+ (define-public package-0.7)
"))
    (should (string-equal (my/test-generate-lisp-commit-message-setup diff)
                          "gnu: Add package.\n\n* path/filename.scm (package-0.7): New variable."))))

(ert-deftest my/test-generate-lisp-commit-message-multiple-blocks ()
  "Test the my/generate-lisp-commit-message function with multiple blocks (should fail)."
  (let ((diff "diff --git a/path/filename.scm b/path/filename.scm
index 0000001..1234567
--- a/path/filename.scm
+++ b/path/filename.scm
@@ -1,3 +1,5 @@
+ (define-public package-0.7)
+ (another-function)
"))
    (should-error (my/test-generate-lisp-commit-message-setup diff))))

(ert-deftest my/test-generate-lisp-commit-message-multiple-files ()
  "Test the my/generate-lisp-commit-message function with multiple files (should fail)."
  (let ((diff "diff --git a/path/filename1.scm b/path/filename1.scm
index 0000001..1234567
--- a/path/filename1.scm
+++ b/path/filename1.scm
@@ -1,3 +1,4 @@
+ (define-public package-0.7)
diff --git a/path/filename2.scm b/path/filename2.scm
index 0000001..1234567
--- a/path/filename2.scm
+++ b/path/filename2.scm
@@ -1,3 +1,4 @@
+ (define-public another-package-0.8)
"))
    (should-error (my/test-generate-lisp-commit-message-setup diff))))

(ert-deftest my/test-generate-lisp-commit-message-invalid-syntax ()
  "Test the my/generate-lisp-commit-message function with invalid syntax (should fail)."
  (let ((diff "diff --git a/path/filename.scm b/path/filename.scm
index 0000001..1234567
--- a/path/filename.scm
+++ b/path/filename.scm
@@ -1,3 +1,4 @@
+ (invalid-syntax)
"))
    (should-error (my/test-generate-lisp-commit-message-setup diff))))

(ert-deftest my/test-generate-lisp-commit-message-extra-content ()
  "Test the my/generate-lisp-commit-message function with extra content (should fail)."
  (let ((diff "diff --git a/path/filename.scm b/path/filename.scm
index 0000001..1234567
--- a/path/filename.scm
+++ b/path/filename.scm
@@ -1,3 +1,4 @@
+ (define-public package-0.7)
+ (extra-content)
"))
    (should-error (my/test-generate-lisp-commit-message-setup diff))))

(ert-deftest my/test-generate-lisp-commit-message-trailing-whitespace ()
  "Test the my/generate-lisp-commit-message function with trailing whitespace (should pass)."
  (let ((diff "diff --git a/path/filename.scm b/path/filename.scm
index 0000001..1234567
--- a/path/filename.scm
+++ b/path/filename.scm
@@ -1,3 +1,4 @@
+ (define-public package-0.7 (package))
"))
    (should (string-equal (my/test-generate-lisp-commit-message-setup diff)
                          "gnu: Add package.\n\n* path/filename.scm (package-0.7): New variable."))))

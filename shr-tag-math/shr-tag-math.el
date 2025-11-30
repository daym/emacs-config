;;; shr-tag-math.el --- Handle MathML in HTML rendering -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Danny Milosavljevic

;; Author: Danny Milosavljevic <dannym@friendly-machines.com>
;; Keywords: html, mathml
;; Version: 1
;; License: GPL 3

;;; Commentary:

;; This package adds support for rendering MathML in HTML documents rendered by `shr.el`.
;; It converts MathML elements to LaTeX for display.

;;; Code:

(require 'shr)
(require 'dom)

(defun escape-latex-special (input-string)
  "Escape special characters in INPUT-STRING for LaTeX."
  (replace-regexp-in-string
   "\\^"
   "\\\\hat{}"
   (replace-regexp-in-string
    "[\\\\$&%_{}~]"
    (lambda (match) (concat "\\\\" match))  ; Escape
    input-string)))

;; Recursive
(defun shr-tag-mathml--convert-to-latex (root)
  "Convert MATHML DOM element to LaTeX format."
  (if (stringp root)
      (progn
       (insert "{")
       (insert (escape-latex-special root))
       (insert "}")
       )
    (let ((root-tag (dom-tag root))
          (children (dom-children root)))
      (pcase root-tag
        ('math (mapc #'shr-tag-mathml--convert-to-latex children))
        ('mrow (mapc #'shr-tag-mathml--convert-to-latex children))
        ('msup
         (let ((base (nth 0 children))
               (extra (nth 1 children)))
           (insert "{")
           (shr-tag-mathml--convert-to-latex base)
           (insert "^")
           (shr-tag-mathml--convert-to-latex extra)
           (insert "}")))
        ('msub
         (let ((base (nth 0 children))
               (extra (nth 1 children)))
           (insert "{")
           (shr-tag-mathml--convert-to-latex base)
           (insert "_")
           (shr-tag-mathml--convert-to-latex extra)
           (insert "}")))
        ('msubsup
         (let ((base (nth 0 children))
               (extra (nth 1 children))
               (hyper (nth 2 children)))
           (insert "{")
           (shr-tag-mathml--convert-to-latex base)
           (insert "_")
           (shr-tag-mathml--convert-to-latex extra)
           (insert "^")
           (shr-tag-mathml--convert-to-latex hyper)
           (insert "}")))
        ('mfrac
         (let ((base (nth 0 children))
               (extra (nth 1 children)))
           (insert "\\frac{")
           (shr-tag-mathml--convert-to-latex base)
           (insert "}{")
           (shr-tag-mathml--convert-to-latex extra)
           (insert "}")))
        ('mover ; TODO: "accent" attr.
         (let ((base (nth 0 children))
               (extra (nth 1 children)))
                                        ; TODO: If you have texlive-mathtools, mathclap
           (insert "\\stackrel")
           (insert "{") ; TODO: mathclap
           (shr-tag-mathml--convert-to-latex extra) ; overscript
           (insert "}{")
           (shr-tag-mathml--convert-to-latex base)
           (insert "}")))
        ('munder ; TODO: "accentunder" attr.
         (let ((base (nth 0 children))
               (extra (nth 1 children)))
           (insert "\\stackrel{")
           (shr-tag-mathml--convert-to-latex base)
           (insert "}{")
           (shr-tag-mathml--convert-to-latex extra)
           (insert "}")))
        ('mroot
         (let ((base (nth 0 children))
               (extra (nth 1 children)))
           (insert "\\sqrt[")
           (shr-tag-mathml--convert-to-latex base)
           (insert "]")
           (shr-tag-mathml--convert-to-latex extra)))
        ('mfenced ; old mathml
         (let ((close ")") ; TODO: value of attr "close", or ")"
               (open "(") ; TODO: value of attr "open", or "("
               (separators ",")) ; TODO: value of attr "separators", or ","; uses the last one if there are too few
           (dolist (node children)
             (shr-tag-mathml--convert-to-latex node)
             (insert separators)))) ; TODO: Just one of the separators
        ('mtable
         (insert "\\begin{pmatrix}")
         (mapc #'shr-tag-mathml--convert-to-latex children)
         (insert "\\end{pmatrix}"))
        ('mtr
         (mapc #'shr-tag-mathml--convert-to-latex children)
         (insert "\\\\\n"))
        ('mtd
         (mapc #'shr-tag-mathml--convert-to-latex children)
         (insert "& \\text{}"))
        ('mo
         (insert (dom-text root)))
        ('mi
         (mapc #'shr-tag-mathml--convert-to-latex children))
        ('mn
         (mapc #'shr-tag-mathml--convert-to-latex children))
        ('mtext
         (insert "\\text{")
         (mapc #'shr-tag-mathml--convert-to-latex children)
         (insert "}"))
        ('mstyle
         (mapc #'shr-tag-mathml--convert-to-latex children))
        ('ms ; for math accents
         (insert "\\text{")
         (mapc #'shr-tag-mathml--convert-to-latex children)
         (insert "}"))
        ('mspace
         (insert "\\, ")) ; TODO: Remove space
        (_
         (insert "???")
         (insert (symbol-name root-tag))
         (mapc #'shr-tag-mathml--convert-to-latex children)
         (insert "/")
         (insert (symbol-name root-tag)))))))

(defun shr-tag-math (math)
  "Render the MATH MathML element."
  (let ((start (point)))  ; Save the current point position
    (insert " \\(") ; "\\begin{equation}\n" ; try $
    (shr-tag-mathml--convert-to-latex math)
    (insert "\\) ") ; "\n\\end{equation}\n" ; try $
    (let ((e (xenops-math-parse-element-at start)))
      (if e
          (progn
  (setq-local TeX-header-end (regexp-quote "%**end of header"))
  (setq-local TeX-trailer-start (regexp-quote (concat TeX-esc "bye")))

(message "ELEMENT: %S" e)
;      (xenops-util-plist-update)
;       :type 'inline-math
          (xenops-math-render e))
          (message "NO ELEMENT!\n")))))

                                        ;(debug-on-entry 'xenops-math-render)



;;; Or: (xenops-math-render (xenops-math-parse-element-from-string "$ x + 5 = 3 $"))

;;; Register the external rendering function
(add-to-list 'shr-external-rendering-functions
             '(math . shr-tag-math))

(provide 'shr-tag-math)
;;; shr-tag-mathml.el ends here

                                        ;(add-hook 'nov-mode-hook 'xenops-math-activate)

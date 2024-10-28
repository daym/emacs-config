;;; shr-tag-mathml.el --- Handle MathML in HTML rendering -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Danny Milosavljevic

;; Author: Danny Milosavljevic <dannym@friendly-machines.com>
;; Keywords: html, mathml
;; Version: 1

;;; Commentary:

;; This package adds support for rendering MathML in HTML documents rendered by `shr.el`.
;; It converts MathML elements to LaTeX for display.

;;; Code:

(require 'shr)
(require 'dom)

;; Recursive
(defun shr-tag-mathml--convert-to-latex (children)
  "Convert MATHML DOM element to LaTeX format."
  (dolist (node children)
    (cond
     ((stringp node) (insert node))
                                        ; TODO (dom-node-name node)
     ((eq (dom-tag node) 'mrow)
      (insert "{")
      (shr-tag-mathml--convert-to-latex (dom-children node))
      (insert "}"))
     ((eq (dom-tag node) 'msup)
      (insert "{")
      (shr-tag-mathml--convert-to-latex (dom-children (nth 0 (dom-children node))))
      (insert "}^{")
      (shr-tag-mathml--convert-to-latex (dom-children (nth 1 (dom-children node))))
      (insert "}"))
     ((eq (dom-tag node) 'msub)
      (insert "{")
      (shr-tag-mathml--convert-to-latex (dom-children (nth 0 (dom-children node))))
      (insert "}_{")
      (shr-tag-mathml--convert-to-latex (dom-children (nth 1 (dom-children node))))
      (insert "}"))
     ((eq (dom-tag node) 'msubsup)
      (insert "{")
      (shr-tag-mathml--convert-to-latex (dom-children (nth 0 (dom-children node))))
      (insert "}_{")
      (shr-tag-mathml--convert-to-latex (dom-children (nth 1 (dom-children node))))
      (insert "}^{")
      (shr-tag-mathml--convert-to-latex (dom-children (nth 2 (dom-children node))))
      (insert "}"))
     ((eq (dom-tag node) 'mfrac)
      (insert "\\frac{")
      (shr-tag-mathml--convert-to-latex (dom-children (nth 0 (dom-children node))))
      (insert "}{")
      (shr-tag-mathml--convert-to-latex (dom-children (nth 1 (dom-children node))))
      (insert "}"))
     ((eq (dom-tag node) 'mroot)
      (insert "\\sqrt[")
      (shr-tag-mathml--convert-to-latex (dom-children (nth 0 (dom-children node))))
      (insert "]{")
      (shr-tag-mathml--convert-to-latex (dom-children (nth 1 (dom-children node))))
      (insert "}"))
     ((eq (dom-tag node) 'mo)
      (insert (concat " " (dom-text node) " ")))
     ((eq (dom-tag node) 'mi)
      (insert (concat (dom-text node))))
     ((eq (dom-tag node) 'mn)
      (insert (concat (dom-text node))))
     ((eq (dom-tag node) 'mtext)
      (insert (concat "\\text{FIXME}"))) ;  (s-replace "_" "" (dom-text node)) "}")
     ((eq (dom-tag node) 'mstyle)
      (shr-tag-mathml--convert-to-latex (dom-children node)))
     ((eq (dom-tag node) 'ms) ; for math accents
      (insert (concat "\\text{" (dom-text node) "}")))
     ((eq (dom-tag node) 'mspace)
      ;; Handle space as a command
      (insert (concat "\\, ")))
     ;; TODO: Add handling for other MathML elements as required
     (t
      (insert "???")
      (insert (symbol-name (dom-tag node)))
      (shr-tag-mathml--convert-to-latex (dom-children node))
      (insert "/")
      (insert (symbol-name (dom-tag node)))))))

(defun shr-tag-math (math)
  "Render the MATH MathML element."
                                        ; (message "QR %s" math)
                                        ; TODO: with-temp-buffer
                                        ;xenops-math-render
                                        ;(save-excursion
  (let ((start (point)))  ; Save the current point position
    (insert "$") ; "\\begin{equation}\n" ; try $
    (shr-tag-mathml--convert-to-latex (dom-children math))
    (insert "$") ; "\n\\end{equation}\n" ; try $
                                        ;(save-excursion
    (xenops-math-render (xenops-math-parse-element-at start))))

;(debug-on-entry 'xenops-math-render)



;;; Or: (xenops-math-render (xenops-math-parse-element-from-string "$ x + 5 = 3 $"))

;;; Register the external rendering function
(add-to-list 'shr-external-rendering-functions
             '(math . shr-tag-math))

(provide 'shr-tag-math)
;;; shr-tag-mathml.el ends here

                                        ;(add-hook 'nov-mode-hook 'xenops-math-activate)

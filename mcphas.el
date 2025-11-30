;; -*- lexical-binding: t -*-

(defvar my-mcphas-mode-syntax-table
  (let ((syntax-table (make-syntax-table)))
    (modify-syntax-entry ?_ "w" syntax-table)
    syntax-table)
  "Syntax table for my-mcphas-mode.")

(define-derived-mode my-mcphas-mode prog-mode "MyCustom"
  "A major mode for editing files with custom extensions."
  :syntax-table my-mcphas-mode-syntax-table
  (setq mode-name "mcphas"))

;; TODO: Maybe icsdread

(defun run-mcphas ()
  (interactive)
  (compile "mcphas"))

(defun run-calcsta ()
  (interactive)
  (compile "wine64 cmd calcsta.bat"))

(defun run-simannfit ()
  (interactive)
  (compile "simannfit"))

(defun run-searchspace ()
  (interactive)
  (compile "searchspace"))

(defun setup-mcphasjforfit ()
  (interactive)
  (compile "setup_mcphasjforfit"))

(defun powdermagnon-r ()
  (interactive)
  (compile "powdermagnon -r")) ; TODO: test

(defun powdermagnon ()
  (interactive)
  (compile "powdermagnon")) ; TODO: test

(defun mcdisp ()
  (interactive)
  (compile "mcdisp")) ; TODO: test

(defun mcdiff ()
  (interactive)
  (compile "mcdiff")) ; TODO: test

(defun cpsingleion ()
  (interactive)
  (compile "cpsingleion")) ; TODO: test

(defun mcphas2jvx ()
  (interactive)
  (compile (concat "mcphas2jvx " (buffer-file-name))))

;;; interactive argument:
;;; "*" is buffer is supposed to be read-write.
;;; a  function name
;;; b  existing buffer name
;;; B  buffer name
;;; c  character
;;; C  command name
;;; d  position of point
;;; D  directory
;;; e  event
;;; f  existing file name
;;; F  file name
;;; G  file or directory name
;;; i  irrelevant (always nil)
;;; k  key sequence
;;; K  key sequence, with last element unconverted
;;; U  key up sequence (or nil)
;;; m  position of mark
;;; n  number (!)
;;; N  numeric prefix argument, or number
;;; p  numeric prefix argument
;;; P  raw prefix argument
;;; r  position of point and mark, sorted, as two arguments.
;;; s  string
;;; S  interned symbol
;;; v  custom variable
;;; x  Lisp form, not evaluated
;;; X  Lisp form, evaluated
;;; z  coding system (as symbol)
;;; Z  coding system, but only if this command has a prefix argument

(defun singleion (T Hext Hxc)
  (interactive "nT: \nnHext: \nnHxc: ")
  (compile (format "singleion -T %s -Hext %s -Hxc %s" T Hext Hxc)))

(defun ic1ion ()
  (interactive)
  (let ((T (read-number "T: "))
        (Hext (read-number "Hext: "))
        (Hxc (read-number "Hxc: ")))
    (compile (format "ic1ion -T %s -Hext %s -Hxc %s" T Hext Hxc)))) ; FIXME: check and test

(defun formfactor ()
  (interactive)
  (compile (format "formfactor"))) ; FIXME: check and test

(defun bfk ()
  (interactive)
  (compile (format "bfk"))) ; FIXME: check and test

(defun run-anisotropy ()
  "Run the anisotropy program with user inputs."
  (interactive)
  (let* ((temperature (read-number "Enter temperature (T) in Kelvin: "))
         (field-strength (read-number "Enter absolute value of the external magnetic field (H) in Tesla: "))
         (polycrystal-flag (yes-or-no-p "Calculate polycrystal average? "))

         (calc-plane (if polycrystal-flag ""
                       (read-string "plane in which anisotropy should be calculated (given as direction normal to plane xn yn zn), e.g., '0 0 1': ")))
         (nofsteps (if polycrystal-flag ""
                     (read-number "Enter number of steps to be calculated: ")))

         (nofthetasteps (if polycrystal-flag (read-number "Enter number of theta steps to be calculated: ") ""))

         (sipffilename (read-file-name "Enter filename of single ion parameter file (or press Enter to skip): " nil nil t))
         (exchange-fields (if (not (string-empty-p sipffilename))
                              (read-string "Enter exchange field components (Hxc1 Hxc2 ...) in meV: ")
                            "")))

    (let ((command
           (concat "anisotropy "
                   (number-to-string temperature) " "
                   (number-to-string field-strength) " "
                   calc-plane " "
                   (number-to-string nofsteps) " "

                   (if polycrystal-flag (concat "-p " (number-to-string nofthetasteps))
                     "")
                   " "
                   (if (not (string-empty-p sipffilename))
                       (concat "-r " sipffilename " " exchange-fields)))))
      (message "Running command: %s" command)
      (compile command))))

(defun makenn ()
  (interactive)
  (let ((distance (read-number "distance (A): "))
        (option (completing-read "Choose an option: "
                                 '("-rkky" "-rkky3d" "-rkkz" "-rkkz3d" "-kaneyoshi" "-kaneyoshi3d" "-bvk" "-cfph" "-f" "-dm" "-d")))
        (A (read-number "A (meV): ")))
    (cond
     ((string-equal option "-rkky")
      (let ((kf (read-number "kf (1/A): ")))
        (compile (format "makenn %s -rkky %s %s" distance A kf))))
     ((string-equal option "-rkky3d")
      (let ((ka (read-number "ka (1/A): "))
            (kb (read-number "kb (1/A): "))
            (kc (read-number "kc (1/A): ")))
        (compile (format "makenn %s -rkky3d %s %s %s %s" distance A ka kb kc))))
     ((string-equal option "-rkkz")
      (let ((kf (read-number "kf (1/A): ")))
        (compile (format "makenn %s -rkkz %s %s" distance A kf))))
     ((string-equal option "-rkkz3d")
      (let ((ka (read-number "ka (1/A): "))
            (kb (read-number "kb (1/A): "))
            (kc (read-number "kc (1/A): ")))
        (compile (format "makenn %s -rkkz3d %s %s %s %s" distance A ka kb kc))))
     ((string-equal option "-kaneyoshi")
      (let ((D (read-number "D (A): "))
            (alpha (read-number "alpha: ")))
        (compile (format "makenn %s -kaneyoshi %s %s %s" distance A D alpha))))
     ((string-equal option "-kaneyoshi3d")
      (let ((Da (read-number "Da (A): "))
            (Db (read-number "Db (A): "))
            (Dc (read-number "Dc (A): "))
            (alpha (read-number "alpha: ")))
        (compile (format "makenn %s -kaneyoshi3d %s %s %s %s %s" distance A Da Db Dc alpha))))
     ((string-equal option "-bvk")
      (let ((filename (read-file-name "Phonon file: ")))
        (compile (format "makenn %s -bvk %s" distance filename))))
     ((string-equal option "-cfph")
      (let ((screeningfile (read-file-name "Screening file: ")))
        (compile (format "makenn %s -cfph %s" distance screeningfile))))
     ((string-equal option "-f") ; TODO: in addition?
      (let ((filename (read-file-name "Filename: ")))
        (compile (format "makenn %s -f %s" distance filename))))
     ((string-equal option "-dm") ; TODO: in addition?
      (let ((filename (read-file-name "Filename: ")))
        (compile (format "makenn %s -dm %s" distance filename))))
     ((string-equal option "-d") ; TODO: in addition?
      (compile (format "makenn %s -d" distance))))))

(defun setup-jqfit (h k l)
  (interactive "nh: \nnk: \nl: ")
  (compile (format "setup_jqfit -h %s -k %s -l %s" h k l)))

(defun setup-mcdiff-in ()
  (interactive)
  (let ((T (read-number "T: "))
        (Ha (read-number "Ha: "))
        (Hb (read-number "Hb: "))
        (Hc (read-number "Hc: "))
        (x (read-number "x: "))
        (y (read-number "y: ")))
    (compile (format "setup_mcdiff_in -T %s -Ha %s -Hb %s -Hc %s -x %s -y %s" T Ha Hb Hc x y))))

(defun setup-mcdisp-mf ()
  (interactive)
  (let ((T (read-number "T: "))
        (Ha (read-number "Ha: "))
        (Hb (read-number "Hb: "))
        (Hc (read-number "Hc: "))
        (x (read-number "x: "))
        (y (read-number "y: ")))
    (compile (format "setup_mcdisp_mf -T %s -Ha %s -Hb %s -Hc %s -x %s -y %s" T Ha Hb Hc x y))))

(defun pointc ()
  (interactive)
  ;; pointc file.sipf 0.2 4 1 5.3 0.1 0.3
  ;;     TODO ask     q   x y z   q   q
  (let ((ionname (buffer-file-name)) ; TODO: Or (read-string "Ion name: ")
        (charge (read-number "Charge: "))
        (x (read-number "x: "))
        (y (read-number "y: "))
        (z (read-number "z: "))
        ;; TODO optional B4m
        ;; TODO optional B6m
        )
    (compile (format "pointc %s %s %s %s %s" ionname charge x y z))))

(defun mpe ()
  (interactive)
  (start-process-shell-command "mpename" "mpebuffername" "mpe"))

(defun javaview ()
  (interactive)
  (start-process-shell-command "javaview" "javaview" (concat "javaview " (buffer-file-name))))

(defun cif2mcphas ()
  (interactive)
  (compile (concat "cif2mcphas " (buffer-file-name))))

(defun display-density ()
  (interactive)
  (compile (format "display_density"))) ; TODO: test

(defun display-densities ()
  (interactive)
  (let ((option (read-string "Option: "))) ; Fixme menu
    (cond
     ((string-equal option "-f")
      (let ((filename (read-file-name "Filename: "))
            (T (read-number "T: "))
            (Ha (read-number "Ha: "))
            (Hb (read-number "Hb: "))
            (Hc (read-number "Hc: ")))
        (compile (format "display_densities -f %s %s %s %s %s" filename T Ha Hb Hc))))
     ((string-equal option "-tMSL")
      (let ((T (read-number "T: "))
            (Ha (read-number "Ha: "))
            (Hb (read-number "Hb: "))
            (Hc (read-number "Hc: ")))
        (compile (format "display_densities -tMSL %s %s %s %s" T Ha Hb Hc))))
     ((string-equal option "-tHex")
      (let ((T (read-number "T: "))
            (Ha (read-number "Ha: "))
            (Hb (read-number "Hb: "))
            (Hc (read-number "Hc: ")))
        (compile (format "display_densities -tHex %s %s %s %s" T Ha Hb Hc))))
     ((string-equal option "-tI")
      (let ((T (read-number "T: "))
            (Ha (read-number "Ha: "))
            (Hb (read-number "Hb: "))
            (Hc (read-number "Hc: ")))
        (compile (format "display_densities -tI %s %s %s %s" T Ha Hb Hc))))
     ((string-equal option "-c")
      (let ((T (read-number "T: "))
            (Ha (read-number "Ha: "))
            (Hb (read-number "Hb: "))
            (Hc (read-number "Hc: ")))
        (compile (format "display_densities -c %s %s %s %s" T Ha Hb Hc))))
     ((string-equal option "-s")
      (let ((T (read-number "T: "))
            (Ha (read-number "Ha: "))
            (Hb (read-number "Hb: "))
            (Hc (read-number "Hc: ")))
        (compile (format "display_densities -s %s %s %s %s" T Ha Hb Hc))))
     ((string-equal option "-o")
      (let ((T (read-number "T: "))
            (Ha (read-number "Ha: "))
            (Hb (read-number "Hb: "))
            (Hc (read-number "Hc: ")))
        (compile (format "display_densities -o %s %s %s %s" T Ha Hb Hc))))
     ((string-equal option "-m")
      (let ((T (read-number "T: "))
            (Ha (read-number "Ha: "))
            (Hb (read-number "Hb: "))
            (Hc (read-number "Hc: ")))
        (compile (format "display_densities -m %s %s %s %s" T Ha Hb Hc))))
     ((string-equal option "-j")
      (let ((T (read-number "T: "))
            (Ha (read-number "Ha: "))
            (Hb (read-number "Hb: "))
            (Hc (read-number "Hc: ")))
        (compile (format "display_densities -j %s %s %s %s" T Ha Hb Hc))))
     ((string-equal option "-p")
      (let ((i (read-number "i: "))
            (j (read-number "j: "))
            (k (read-number "k: "))
            (T (read-number "T: "))
            (Ha (read-number "Ha: "))
            (Hb (read-number "Hb: "))
            (Hc (read-number "Hc: ")))
        (compile (format "display_densities -p %s %s %s %s %s %s %s" i j k T Ha Hb Hc))))
     ((string-equal option "-div")
      (let ((T (read-number "T: "))
            (Ha (read-number "Ha: "))
            (Hb (read-number "Hb: "))
            (Hc (read-number "Hc: ")))
        (compile (format "display_densities -div %s %s %s %s" T Ha Hb Hc))))
     ((string-equal option "-L")
      (let ((T (read-number "T: "))
            (Ha (read-number "Ha: "))
            (Hb (read-number "Hb: "))
            (Hc (read-number "Hc: ")))
        (compile (format "display_densities -L %s %s %s %s" T Ha Hb Hc))))
     ((string-equal option "-M")
      (let ((T (read-number "T: "))
            (Ha (read-number "Ha: "))
            (Hb (read-number "Hb: "))
            (Hc (read-number "Hc: ")))
        (compile (format "display_densities -M %s %s %s %s" T Ha Hb Hc))))
     ((string-equal option "-P")
      (let ((T (read-number "T: "))
            (Ha (read-number "Ha: "))
            (Hb (read-number "Hb: "))
            (Hc (read-number "Hc: ")))
        (compile (format "display_densities -P %s %s %s %s" T Ha Hb Hc)))))))

;; TODO: handle bcfph
(defun my-mcphas-mode-toolbar-buttons ()
  (let ((tool-bar-map (copy-keymap tool-bar-map))  ; Start with copy of global toolbar
        (file-name (or (buffer-file-name) "")))
    (cond
     ((string-match "\\`.*\\.cif\\'" file-name)
      (tool-bar-local-item nil 'cif2mcphas 'cif2mcphas tool-bar-map :label "|Run cif2mcphas" :help "Run cif2mcphas")) ; cif -> mcphas.j
     ((or (string-match "\\`.*calcsta\\.bat\\'" file-name) (string-match "\\`.*\\.forfit\\'" file-name))
      (tool-bar-local-item nil 'run-calcsta 'run-calcsta tool-bar-map :label "|Run calcsta" :help "Run calcsta")
      (tool-bar-local-item nil 'run-simannfit 'run-simannfit tool-bar-map :label "|Run simannfit" :help "Run simannfit")
      (tool-bar-local-item nil 'run-searchspace 'run-searchspace tool-bar-map :label "|Run searchspace" :help "Run searchspace"))
     ((string-match "\\`.*\\.sipf\\'" file-name)
      (tool-bar-local-item nil 'pointc 'pointc tool-bar-map :label "|Run pointc" :help "Run pointc")
      (tool-bar-local-item nil 'mpe 'mpe tool-bar-map :label "|Run mpe" :help "Run mpe")
      (tool-bar-local-item nil 'singleion 'singleion tool-bar-map :label "|Run singleion" :help "Run singleion")
      (tool-bar-local-item nil 'ic1ion 'ic1ion tool-bar-map :label "|Run ic1ion" :help "Run ic1ion")
      (tool-bar-local-item nil 'formfactor 'formfactor tool-bar-map :label "|Run formfactor" :help "Run formfactor")
      (tool-bar-local-item nil 'display-density 'display-density tool-bar-map :label "|Display density" :help "Display density")
                                        ;(tool-bar-local-item nil 'display-densities 'display-densities tool-bar-map :label "|Display densities" :help "Display densities") ; TODO: results/mcphas.mf vs other mf
      )
     ((string-match "\\`.*mcphas\\.ini\\|.*mcphas\\.j\\'" file-name)
      (tool-bar-local-item "mcphas-mcphas" 'run-mcphas 'run-mcphas tool-bar-map :label "|Run mcphas" :help "Run mcphas")
      (tool-bar-local-item nil 'singleion 'singleion tool-bar-map :label "|Run singeleion" :help "Run singleion")
      (tool-bar-local-item nil 'setup-jqfit 'setup-jqfit tool-bar-map :label "|Setup jqfit" :help "Setup jqfit") ; mcphase.j sipf ->
      (tool-bar-local-item nil 'setup-mcphasjforfit 'setup-mcphasjforfit tool-bar-map :label "|Setup mcphasjforfit" :help "Setup mcphasjforfit") ; mcphas.j -> mcphas.j.forfit
      (tool-bar-local-item nil 'mcphas2jvx 'mcphas2jvx tool-bar-map :label "|Run mcphas2jvx" :help "Run mcphas2jvx")
      (tool-bar-local-item nil 'makenn 'makenn tool-bar-map :label "|Run makenn" :help "Run makenn")       ; requires mcphas.j, edits mcphas.j
      (tool-bar-local-item nil 'powdermagnon 'powdermagnon tool-bar-map :label "|Run powdermagnon" :help "Run powdermagnon") ; TODO: maybe on sipf, too
      (tool-bar-local-item nil 'mcdisp 'mcdisp tool-bar-map :label "|Run mcdisp" :help "Run mcdisp")
      (tool-bar-local-item nil 'display-densities 'display-densities tool-bar-map :label "|Display densities" :help "Display densities") ; TODO: results/mcphas.mf vs other mf
      (tool-bar-local-item nil 'run-anisotropy 'run-anisotropy tool-bar-map :label "|Run anisotropy" :help "Run anisotropy")
      )
     ((string-match "\\`.*mcdisp\\.\\(par\\|mf\\)\\'" file-name)
      (tool-bar-local-item nil 'mcdisp 'mcdisp tool-bar-map :label "|Run mcdisp" :help "Run mcdisp")
      )
     ((string-match "\\`.*\\(cef\\|par\\)\\'" file-name)
      (tool-bar-local-item nil 'bfk 'bfk tool-bar-map :label "|Run bfk" :help "Run bfk")
      )

     ((string-match "\\`.*mcdiff\\.in\\'" file-name)
      (tool-bar-local-item nil 'mcdiff 'mcdiff tool-bar-map :label "|Run mcdiff" :help "Run mcdiff")
      )
     ((string-match "\\`.*\\.j\\'" file-name)
      nil
      )
     ((string-match "\\`.*\\.sps\\'" file-name)
      (tool-bar-local-item nil 'setup-mcdiff-in 'setup-mcdiff-in tool-bar-map :label "|Setup mcdiff_in" :help "Setup mcdiff_in")
      (tool-bar-local-item nil 'display-densities 'display-densities tool-bar-map :label "|Display densities" :help "Display densities")
      )
     ((string-match "\\`.*\\.mf\\'" file-name) ; results/*.mf
      (tool-bar-local-item nil 'setup-mcdiff-in 'setup-mcdiff-in tool-bar-map :label "|Setup mcdiff_in" :help "Setup mcdiff_in")
      (tool-bar-local-item nil 'setup-mcdisp-mf 'setup-mcdisp-mf tool-bar-map :label "|Setup mcdisp_mf" :help "Setup mcdisp_mf")
      (tool-bar-local-item nil 'display-densities 'display-densities tool-bar-map :label "|Display densities" :help "Display densities") ; TODO: results/mcphas.mf vs other mf
      )
     ((string-match "\\`.*\\.sipf.levels\\'" file-name) ; results/
      (tool-bar-local-item nil 'cpsingleion 'cpsingleion tool-bar-map :label "|Run cpsingleion" :help "Run cpsingleion")
      )
     ((string-match "\\`.*\\.qei\\'" file-name) ; results/*.qei
      (tool-bar-local-item nil 'powdermagnon-r 'powdermagnon-r tool-bar-map :label "|Run powdermagnon-r" :help "Run powdermagnon-r")
      )

     ((string-match "\\`.*\\.jvx\\'" file-name)
      (tool-bar-local-item nil 'javaview 'javaview tool-bar-map :label "|Run javaview" :help "Run javaview"))
     )
    (setq-local tool-bar-map tool-bar-map)))

;; Add the toolbar buttons when the mode is activated
(add-hook 'my-mcphas-mode-hook 'my-mcphas-mode-toolbar-buttons)

;; Provide the mode
(provide 'my-mcphas-mode)

(add-to-list 'auto-mode-alist
             '("\\.\\(Blm\\|cef\\|cif\\|clc\\|dat\\|del\\|dsigma\\|fcm\\|fe_status\\|forfit\\|fst\\|fum\\|grid\\|hkl\\|hst\\|in\\|ini\\|j\\|jq\\|jvx\\|Llm\\|mcdisp\\|mcphas\\|mf\\|MH_mcphas\\|MH_spins\\|MH_spins3dab\\|MH_spins3dac\\|MH_spins3dbc\\|MT_mcphas\\|MT_spins\\|MT_spins3dab\\|MT_spins3dac\\|MT_spins3dbc\\|out\\|par\\|pc\\|phs\\|prn\\|qee\\|qei\\|qem\\|qom\\|qvc\\|rtplot\\|setup\\|sipf\\|spins\\|spins3dab\\|spins3dac\\|spins3dbc\\|sps\\|status\\|trs\\|tst\\|txt\\|xyt\\)\\'" . my-mcphas-mode))

;; It's using bat-mode anyway.
(add-to-list 'auto-mode-alist
             '("calcsta\\.\\(bat\\)\\'" . my-mcphas-mode))

(add-hook 'my-mcphas-mode-hook
          (lambda ()
            (when (string-match "\\.sipf\\'" (buffer-name))
              (font-lock-add-keywords
               nil
               '(("#.*$" . font-lock-comment-face)
                 ("\"[^\"]*\"" . font-lock-string-face))))
            (when (string-match "\\.cif\\'" (buffer-name))
              (font-lock-add-keywords
               nil
               '(("#.*$" . font-lock-comment-face)
                 ("\"[^\"]*\"" . font-lock-string-face))))
            (when (string-match "\\.tst\\'" (buffer-name))
              (font-lock-add-keywords
               nil
               '(("#.*$" . font-lock-comment-face)
                 ("\"[^\"]*\"" . font-lock-string-face))))
            (when (string-match "\\.grid\\'" (buffer-name))
              (font-lock-add-keywords
               nil
               '(("#.*$" . font-lock-comment-face)
                 ("\"[^\"]*\"" . font-lock-string-face))))
            (when (string-match "\\.j\\'" (buffer-name))
              (font-lock-add-keywords
               nil
               '(("#.*$" . font-lock-comment-face)
                 ("\"[^\"]*\"" . font-lock-string-face))))))

(progn (deftheme my "A theme created with Koeeoadi") (put (quote my) (quote theme-immediate) t) (custom-theme-set-faces (quote my) (quote (font-lock-string-face ((t (:foreground "#e5a34a"))))) (quote (font-lock-variable-name-face ((t (:foreground "#ec1818"))))) (quote (font-lock-type-face ((t (:foreground "#14d916"))))) (quote (font-lock-function-name-face ((t (:foreground "#a8a8a8"))))) (quote (font-lock-preprocessor-face ((t (:foreground "#e2f2ff"))))) (quote (font-lock-builtin-face ((t (:foreground "#e2f2ff"))))) (quote (font-lock-constant-face ((t (:foreground "#e2f2ff"))))) (quote (font-lock-doc-face ((t (:foreground "#000000" :background "#e2f2ff"))))) (quote (font-lock-background-face ((t (:background "#000000"))))) (quote (font-lock-comment-face ((t (:foreground "#bc60c5" :italic t))))) (quote (font-lock-keyword-face ((t (:foreground "#2c68ff"))))) (quote (font-lock-comment-delimiter-face ((t (:foreground "#5b5b5b" :italic t))))) (quote (default ((t (:foreground "#e2f2ff" :background "#000000")))))) (provide-theme (quote my)))
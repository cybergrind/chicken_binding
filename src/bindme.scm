(declare (unit bindme))

(foreign-declare "#include \"bindme.h\"")

;; Binding for:
;; void echo_str(const char *str);

(define echo-str
  (foreign-lambda void echo_str c-string))


;; Binding for:
;; void echo_str2(const char **str);


;; straightforward approach to convert type, opaque function call
(define echo-str2
  (foreign-safe-lambda* void (((const c-string) str))
    "echo_str2(&str);"))


;; straighforward wrapper declaration
;; requires convertation of passed parameter
(define echo-str2-c
  (foreign-lambda void echo_str2 (c-pointer (const c-string))))

(define str-to-pointer
  (lambda (str)
    ((foreign-primitive (c-pointer c-string) ((c-string str)) "C_return(&str);") str)))

(define echo-str2-v2
  (lambda (str)
    (echo-str2-c (str-to-pointer str))))

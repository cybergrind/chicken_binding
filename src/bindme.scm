(declare (unit bindme))

(foreign-declare "#include \"bindme.h\"")

(define echo-str
  (foreign-lambda void echo_str c-string))

(define echo-str2
  (foreign-safe-lambda* void (((const c-string) str))
    "echo_str2(&str);"))

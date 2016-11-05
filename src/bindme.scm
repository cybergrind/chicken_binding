(declare (unit bindme))

(foreign-declare "#include \"bindme.h\"")

(define echo-str
  (foreign-lambda void echo_str c-string))

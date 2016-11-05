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


;; using foreigners define-foreign-record-type helper

;; straigforward wrapper
(define echo-struct-c
  (foreign-lambda void echo_struct word_count))


(import foreign)
(import foreigners)

;; define type
(define-foreign-record-type (word_count "word_count")
  (constructor: %make-word-count)  ;; as I understand it define `malloc(word_count)` function
  ;;  and bind it to `%make-word-count` name
  (destructor: %free-word-count)   ;; binding `free(word_count *)` function to `%free-word-count`
  (unsigned-integer count word_count-count word_count-count-set!)
  (c-string str word_count-str word_count-str-set!))

;; this function used to construct foreign-type when calling `echo-struct-c`
(define (make-word-count count str)
  (let ((r (%make-word-count)))
    (set-finalizer! r %free-word-count)
    (word_count-count-set! r count)
    (word_count-str-set! r str)
    r))

(define echo-struct
  (lambda (count str)
    (echo-struct-c (make-word-count count str))))

;; glue in C. Just straigforward reimplementation of code in `exec.c`
(define echo-struct-stack
  (foreign-lambda* void ((unsigned-integer count) (c-string str))
    "word_count wk = {count, str};
     echo_struct(&wk);"))

(define echo-struct-malloc
  (foreign-lambda* void ((unsigned-integer count) (c-string str))
#<<END
    word_count *wk = malloc(sizeof(word_count));
    wk->count = count;
    wk->str = str;
    echo_struct(wk);
    free(wk);
END
))

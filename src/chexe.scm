(declare (uses bindme))

(echo-str "hello world")
(echo-str2 "hello world")
(echo-str2-v2 "hello world")

(echo-struct 4 "hello scheme")

(echo-struct-stack 3 "stack scheme")

(do ((i 0 (+ i 1))) ((> i 1) #t)
  (echo-struct-malloc 2 "malloc scheme"))

(echo-struct-locations 1 "test location")

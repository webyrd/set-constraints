(load "mk.scm")
(load "test-check.scm")

(define anyo
  (lambda (g)
    (conde
      (g)
      ((anyo g)))))

(define nevero (anyo fail))
(define alwayso (anyo succeed))

(test "memb-1"
  (run* (q)
    (memb 5 '(5)))
  '(_.0))

(test "memb-2"
  (run* (q)
    (memb q '(5)))
  '(5))

(test "memb-3"
  (run* (q)
    (memb q 5))
  '())

(test "memb-4"
  (run* (q)
    (memb 5 `(5 . ,q)))
  '())

(test "memb-5"
  (run* (q)
    (memb 5 `(,q)))
  '(5))

(test "memb-6"
  (run* (q)
    (memb 5 '(6 5 7)))
  '(_.0))

(test "memb-7"
  (run* (q)
    (memb 5 '(6 8 7)))
  '())

(test "memb-8"
  (run* (q)
    (fresh (x)
      (memb 5 `(,x ,x))))
  '(_.0))

(test "memb-9"
  (run* (q)
    (memb 5 `(,q ,q)))
  '(5))

(test "memb-10"
  (run* (q)
    (fresh (x)
      (memb q `((,x) (,x)))))
  '((_.0)))

(test "memb-11"
  (run* (q)
    (fresh (x y)
      (memb q `((5 ,x) (6 ,y)))))
  '((5 _.0)
    (6 _.0)))

(test "memb-12"
  (run* (q)
    (fresh (x y)
      (memb q `((5 ,x) (5 ,y)))))
  '((5 _.0) (5 _.0)))

(test "memb-13"
  (run* (q)
    (fresh (x)
      (memb q `((5 ,x) (5 ,x)))))
  '((5 _.0)))

(test "memb-14"
  (run* (q)
    (memb q '(5))
    (memb q '(5)))
  '(5))

(test "memb-15"
  (run* (q)
    (memb q '(5))
    (memb q '(6)))
  '())

(test "memb-16"
  (run* (q)
    (fresh (x)
      (memb q '(5))
      (memb q `(,x))))
  '(5))

(test "memb-17"
  (run* (q)
    (fresh (x)
      (memb q `(,x))
      (memb q '(5))))
  '(5))

(test "memb-18"
  (run* (q)
    (memb q '(5 6 5 7 7 5)))
  '(6 7 5))

(test "memb-19"
  (run* (q)
    (memb q '(5 6))
    (memb q '(6 7)))
  '(6))

(test "memb-20"
  (run* (q)
    (memb q '(5 6))
    (memb q '(7 6)))
  '(6))

(test "memb-20"
  (run* (q)
    (fresh (x)
      (memb q '(5 6))
      (memb q `(7 ,x))))
  '(5 6))

(test "memb-21"
  (run* (q)
    (fresh (x)
      (memb q `(7 ,x))
      (memb q '(5 6))))
  '(5 6))

(test "memb-22"
  (run* (q)
    (memb q '(5))
    (memb q '(6))
    nevero)
  '())

(test "memb-23"
  (run* (q)
    (memb q '(5 6))
    (memb q '(7 8)))
  '())

;; TODO
;;
;; this test diverges, but should not
;;
;; 1. update memb code to check/normalize constraints after each
;; unification
;;
;; 2. update memb code to verify that the *conjunction* of memb
;; constraints is satisfiable (as opposed to only checking
;; satisfiability of individual memb constraints).  No need to
;; enumerate the answers to check satisfiability--just ensure at least
;; one answer exists.
(test "memb-24"
  (run* (q)
    (memb q '(5 6))
    (memb q '(7 8))
    nevero)
  '())

(test "memb-25"
  (run* (q)
    (memb q '(5 6))
    (memb q '(7 8 9 10 11 12 13 14))
    nevero)
  '())

(test "memb-26"
  (run* (q)
    (memb q '(7 8 9 10 11 12 13 14))
    (memb q '(5 6))
    nevero)
  '())

(test "memb-27"
  (run* (q)
    (memb q '(5 6))
    (memb `(,q) '((7) (8))))
  '())

(test "memb-28"
  (run* (q)
    (memb `(,q) '((7) (8)))
    (memb q '(5 6)))
  '())

(test "memb-29"
  (run* (q)
    (memb q '(5 6))
    (memb `(,q) '((7) (8)))
    nevero)
  '())

(test "memb-30"
  (run* (q)
    (memb `(,q) '((7) (8)))
    (memb q '(5 6))
    nevero)
  '())

(test "memb-31"
  (run* (q)
    (fresh (x y)
      (memb x '(5 6))
      (memb y '(7 8))
      (== `(,x ,y) q)))
  '((5 7)
    (6 7)
    (5 8)
    (6 8)))

(test "memb-32"
  (run* (q)
    (fresh (x y)
      (memb x '(5 6))
      (memb y '(7 8))
      (memb x '(1 2))
      (== `(,x ,y) q)))
  '())

(test "memb-33"
  (run* (q)
    (fresh (x y)
      (memb x '(5 6))
      (memb y '(7 8))
      (memb x '(1 2))
      nevero
      (== `(,x ,y) q)))
  '())

(test "memb-34"
  (run* (q)
    (memb q `(,q)))
  '(_.0))

(test "memb-35"
  (run* (q)
    (memb q `((,q))))
  '())

(test "memb-36"
  (run* (q)
    (memb q `(5 (,q) 6)))
  '(5 6))

(test "memb-37"
  (run* (q)
    (memb q `((,q)))
    nevero)
  '())

(test "memb-38"
  (run* (q)
    (memb q `(5 (,q) 6))
    (memb q `(7 8)))
  '())

(test "memb-39"
  (run* (q)
    (memb q `(5 (,q) 6))
    (memb q `(7 8))
    nevero)
  '())

(test "memb-40"
  (run* (q)
    (memb q `(5 (,q) 6))
    (memb q `(7 8 (,q))))
  '())

(test "memb-41"
  (run* (q)
    (memb q `(5 (,q) 6))
    (memb q `(7 8 (,q)))
    nevero)
  '())



(test "membo-1"
  (run* (q) (membo 'x '(x)))
  '(_.0))

(test "membo-2"
  (run* (q) (membo 'x '(y)))
  '())

(test "membo-3"
  (run* (q) (membo 'x '(z x y)))
  '(_.0))

(test "membo-4"
  (run* (q) (membo q '(z x y)))
  '(z x y))

(test "membo-5"
  (run 5 (q) (membo 'x q))
  '((x . _.0)
    ((_.0 x . _.1) (=/= ((_.0 x))))
    ((_.0 _.1 x . _.2) (=/= ((_.0 x)) ((_.1 x))))
    ((_.0 _.1 _.2 x . _.3) (=/= ((_.0 x)) ((_.1 x)) ((_.2 x))))
    ((_.0 _.1 _.2 _.3 x . _.4) (=/= ((_.0 x)) ((_.1 x)) ((_.2 x)) ((_.3 x))))))



(test "subset-ofo-1"
  (run* (q) (subset-ofo '() q))
  '(_.0))

(test "subset-ofo-2"
  (run 5 (q) (subset-ofo '(5) q))
  '((5 . _.0)
    ((_.0 5 . _.1) (=/= ((_.0 5))))
    ((_.0 _.1 5 . _.2) (=/= ((_.0 5)) ((_.1 5))))
    ((_.0 _.1 _.2 5 . _.3) (=/= ((_.0 5)) ((_.1 5)) ((_.2 5))))
    ((_.0 _.1 _.2 _.3 5 . _.4) (=/= ((_.0 5)) ((_.1 5)) ((_.2 5)) ((_.3 5))))))

(test "subset-ofo-3"
  (run 5 (q) (subset-ofo '(5 6) q))
  '((5 6 . _.0)
    ((5 _.0 6 . _.1) (=/= ((_.0 6))))
    (6 5 . _.0)
    ((5 _.0 _.1 6 . _.2) (=/= ((_.0 6)) ((_.1 6))))
    ((5 _.0 _.1 _.2 6 . _.3) (=/= ((_.0 6)) ((_.1 6)) ((_.2 6))))))

(test "subset-ofo-4"
  (run* (q)
    (fresh (x y)
      (subset-ofo '(5 6) `(,x ,y))
      (== `(,x ,y) q)))
  '((5 6)
    (6 5)))

(test "subset-ofo-5"
  (run* (q)
    (fresh (x y z)
      (subset-ofo '(5 6) `(,x ,y ,z))
      (== `(,x ,y ,z) q)))
  '((5 6 _.0)
    ((5 _.0 6) (=/= ((_.0 6))))
    (6 5 _.0)
    ((6 _.0 5) (=/= ((_.0 5))))
    ((_.0 5 6) (=/= ((_.0 5)) ((_.0 6))))
    ((_.0 6 5) (=/= ((_.0 5)) ((_.0 6))))))


(test "unify-setso-1"
  (run* (q) (unify-setso '(5 6) '(5 6)))
  '(_.0))

(test "unify-setso-2"
  (run* (q) (unify-setso '(5 6) '(6 5)))
  '(_.0))

(test "unify-setso-3"
  (run* (q)
    (fresh (x y)
      (unify-setso '(5 6) `(,x ,y))
      (== `(,x ,y) q)))
  '((5 6)
    (6 5)))

(test "unify-setso-4"
  (run* (q)
    (fresh (A B u v x y)
      (== `(,u ,v) A)
      (== `(,x ,y) B)
      (unify-setso A B)
      (== `(,A ,B) q)))
  '(((_.0 _.0) (_.0 _.0))
    (((_.0 _.1) (_.1 _.0)) (=/= ((_.0 _.1))))
    (((_.0 _.1) (_.0 _.1)) (=/= ((_.0 _.1))))))

(test "unify-setso-5"
  (run 20 (q)
    (fresh (A B)
      (unify-setso A B)
      (== `(,A ,B) q)))
  '((() ())
    ((_.0) (_.0))
    ((_.0) (_.0 _.0))
    ((_.0) (_.0 _.0 _.0))
    ((_.0) (_.0 _.0 _.0 _.0))
    ((_.0 _.0) (_.0))
    ((_.0) (_.0 _.0 _.0 _.0 _.0))
    ((_.0) (_.0 _.0 _.0 _.0 _.0 _.0))
    ((_.0 _.0) (_.0 _.0))
    ((_.0) (_.0 _.0 _.0 _.0 _.0 _.0 _.0))
    ((_.0) (_.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0))
    ((_.0) (_.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0))
    ((_.0 _.0) (_.0 _.0 _.0))
    ((_.0) (_.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0))
    ((_.0) (_.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0))
    ((_.0 _.0) (_.0 _.0 _.0 _.0))
    ((_.0) (_.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0))
    ((_.0)
     (_.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0))
    ((_.0)
     (_.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0))
    ((_.0 _.0) (_.0 _.0 _.0 _.0 _.0))))

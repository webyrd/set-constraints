(load "mk.scm")
(load "test-check.scm")

(define anyo
  (lambda (g)
    (conde
      (g)
      ((anyo g)))))

(define nevero (anyo fail))
(define alwayso (anyo succeed))

(test "==-sets-empty-1"
  (run* (q) (== empty-set empty-set))
  '(_.0))

(test "==-sets-empty-2"
  (run* (q) (== empty-set (make-set 5)))
  '())

(test "==-sets-empty-3"
  (run* (q) (== (make-set 5) empty-set))
  '())

(test "==-sets-empty-4"
  (run* (q) (== (make-set 5) (ext-set empty-set 5)))
  '(_.0))


(test "==-sets-0"
  (run* (q) (== (make-set 5 6) (make-set 5 5 6)))
  '(_.0))

(test "==-sets-1"
  (run* (q) (== (make-set 5 6) (make-set 5 6)))
  '(_.0))

(test "==-sets-2"
  (run* (q) (== (make-set 5 6) (make-set 6 5)))
  '(_.0))

(test "==-sets-3"
  (run* (q)
    (fresh (x y)
      (== (make-set 5 6) (make-set x y))
      (== `(,x ,y) q)))
  '((5 6)
    (6 5)))

(test "==-sets-4"
  (run* (q)
    (fresh (A B u v x y)
      (== (make-set u v) (make-set x y))
      (== `((,u ,v) (,x ,y)) q)))
  '(((_.0 _.0) (_.0 _.0))
    (((_.0 _.1) (_.1 _.0)) (=/= ((_.0 _.1))))
    (((_.0 _.1) (_.0 _.1)) (=/= ((_.0 _.1))))))

(test "==-sets-experiment-1a"
;; experiment 1 on p. 10 of Stolzenburg's 'Membership-Constraints and
;; Complexity in Logic Programming with Sets'
  (run* (q)
    (fresh (B w x y z)
      (== (make-set w x y z) (make-set 'a 'b))
      (== `(,w ,x ,y ,z) q)))
  '((b a a a)
    (a b a a)
    (b b a a)
    (a a b a)
    (b a b a)
    (a a a b)
    (a b b a)
    (b a a b)
    (b b b a)
    (a b a b)
    (a a b b)
    (b b a b)
    (b a b b)
    (a b b b)))

(test "==-sets-experiment-1b"
;; experiment 1 on p. 10 of Stolzenburg's 'Membership-Constraints and
;; Complexity in Logic Programming with Sets'  
  (length
   (run* (q)
     (fresh (w x y z)
       (== (make-set w x y z) (make-set 'a 'b)))))
  14)

(test "==-sets-experiment-2a"
;; experiment 2 on p. 10 of Stolzenburg's 'Membership-Constraints and
;; Complexity in Logic Programming with Sets'
;;
;; Hmmm.  Doesn't seem to match the number of answers from the paper.
  (run* (q)
    (fresh (x y z)
      (== (make-set x y z) (make-set x y z))
      (== `((,x ,y ,z) (,x ,y ,z)) q)))
  '(((_.0 _.0 _.0) (_.0 _.0 _.0))
    (((_.0 _.1 _.0) (_.0 _.1 _.0)) (=/= ((_.0 _.1))))
    (((_.0 _.1 _.1) (_.0 _.1 _.1)) (=/= ((_.0 _.1))))
    (((_.0 _.0 _.1) (_.0 _.0 _.1)) (=/= ((_.0 _.1))))
    (((_.0 _.1 _.2) (_.0 _.1 _.2)) (=/= ((_.0 _.1)) ((_.0 _.2)) ((_.1 _.2))))))

(test "==-sets-experiment-2b"
  ;; experiment 2 on p. 10 of Stolzenburg's 'Membership-Constraints and
  ;; Complexity in Logic Programming with Sets'
  (length
   (run* (q)
     (fresh (x y z)
       (== (make-set x y z) (make-set x y z))
       (== `((,x ,y ,z) (,x ,y ,z)) q))))
  5)

(test "==-sets-experiment-3a"
  ;; experiment 3 on p. 10 of Stolzenburg's 'Membership-Constraints and
  ;; Complexity in Logic Programming with Sets'
  (run* (q)
    (fresh (x y1 z1 y2 z2)
      (== (make-set x `(f ,y1) `(g ,y1) `(g ,z1))
          (make-set x `(f ,y2) `(g ,y2) `(g ,z2)))
      (== `((,x (f ,y1) (g ,y1) (g ,z1))
            (,x (f ,y2) (g ,y2) (g ,z2)))
          q)))
  '((((g _.0) (f _.0) (g _.0) (g _.0))
     ((g _.0) (f _.0) (g _.0) (g _.0)))
    (((f _.0) (f _.0) (g _.0) (g _.0))
     ((f _.0) (f _.0) (g _.0) (g _.0)))
    ((((g _.0) (f _.1) (g _.1) (g _.0))
      ((g _.0) (f _.1) (g _.1) (g _.0)))
     (=/= ((_.0 _.1))))
    ((((g _.0) (f _.1) (g _.1) (g _.0))
      ((g _.0) (f _.1) (g _.1) (g _.1)))
     (=/= ((_.0 _.1))))
    ((((f _.0) (f _.0) (g _.0) (g _.1))
      ((f _.0) (f _.0) (g _.0) (g _.1)))
     (=/= ((_.0 _.1))))
    ((((g _.0) (f _.0) (g _.0) (g _.1))
      ((g _.0) (f _.0) (g _.0) (g _.1)))
     (=/= ((_.0 _.1))))
    ((((g _.0) (f _.1) (g _.1) (g _.1))
      ((g _.0) (f _.1) (g _.1) (g _.0)))
     (=/= ((_.0 _.1))))
    (((_.0 (f _.1) (g _.1) (g _.1))
      (_.0 (f _.1) (g _.1) (g _.1)))
     (=/= ((_.0 (f _.1))) ((_.0 (g _.1)))))
    (((_.0 (f _.1) (g _.1) (g _.2))
      (_.0 (f _.1) (g _.1) (g _.2)))
     (=/= ((_.0 (f _.1))) ((_.0 (g _.1))) ((_.0 (g _.2)))
          ((_.1 _.2))))))

(test "==-sets-experiment-3b"
  ;; experiment 3 on p. 10 of Stolzenburg's 'Membership-Constraints and
  ;; Complexity in Logic Programming with Sets'
  (length
   (run* (q)
     (fresh (x y1 z1 y2 z2)
       (== (make-set x `(f ,y1) `(g ,y1) `(g ,z1))
           (make-set x `(f ,y2) `(g ,y2) `(g ,z2)))
       (== `((,x (f ,y1) (g ,y1) (g ,z1))
             (,x (f ,y2) (g ,y2) (g ,z2)))
           q))))
  9)


(test "elem-0"
  (run* (q) (elem q (make-set 5 6)))
  '(5 6))

(test "not-elem-0"
  (run* (q) (not-elem q (make-set 5 6)))
  '((_.0 (=/= ((_.0 5)) ((_.0 6))))))







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


(test "unify-setso-0"
  (run* (q) (unify-setso '(5 6) '(5 5 6)))
  '(_.0))

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
    ((_.0) (_.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0))
    ((_.0 _.0) (_.0 _.0 _.0))
    ((_.0) (_.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0))
    ((_.0) (_.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0))
    ((_.0) (_.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0))
    ((_.0 _.0) (_.0 _.0 _.0 _.0))
    ((_.0) (_.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0))
    ((_.0) (_.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0 _.0))))

(test "unify-setso-experiment-1a"
;; experiment 1 on p. 10 of Stolzenburg's 'Membership-Constraints and
;; Complexity in Logic Programming with Sets'
  (run* (A)
    (fresh (B w x y z)
      (== `(,w ,x ,y ,z) A)
      (== '(a b) B)
      (unify-setso A B)))
  '((b a a a)
    (a b a a)
    (b b a a)
    (a a b a)
    (b a b a)
    (a a a b)
    (a b b a)
    (b a a b)
    (b b b a)
    (a b a b)
    (a a b b)
    (b b a b)
    (b a b b)
    (a b b b)))

(test "unify-setso-experiment-1b"
;; experiment 1 on p. 10 of Stolzenburg's 'Membership-Constraints and
;; Complexity in Logic Programming with Sets'  
  (length
   (run* (A)
    (fresh (B w x y z)
      (== `(,w ,x ,y ,z) A)
      (== '(a b) B)
      (unify-setso A B))))
  14)

(test "unify-setso-experiment-2a"
;; experiment 2 on p. 10 of Stolzenburg's 'Membership-Constraints and
;; Complexity in Logic Programming with Sets'
;;
;; Hmmm.  Doesn't seem to match the number of answers from the paper.
  (run* (q)
    (fresh (A B x y z)
      (== `(,x ,y ,z) A)
      (== `(,x ,y ,z) B)
      (unify-setso A B)
      (== `(,A ,B) q)))
  '(((_.0 _.0 _.0) (_.0 _.0 _.0))
    (((_.0 _.1 _.0) (_.0 _.1 _.0)) (=/= ((_.0 _.1))))
    (((_.0 _.1 _.1) (_.0 _.1 _.1)) (=/= ((_.0 _.1))))
    (((_.0 _.0 _.1) (_.0 _.0 _.1)) (=/= ((_.0 _.1))))
    (((_.0 _.1 _.2) (_.0 _.1 _.2)) (=/= ((_.0 _.1)) ((_.0 _.2)) ((_.1 _.2))))))

(test "unify-setso-experiment-2b"
  ;; experiment 2 on p. 10 of Stolzenburg's 'Membership-Constraints and
  ;; Complexity in Logic Programming with Sets'
  (length
   (run* (q)
     (fresh (A B x y z)
       (== `(,x ,y ,z) A)
       (== `(,x ,y ,z) B)
       (unify-setso A B)
       (== `(,A ,B) q))))
  5)

(test "unify-setso-experiment-3a"
  ;; experiment 3 on p. 10 of Stolzenburg's 'Membership-Constraints and
  ;; Complexity in Logic Programming with Sets'
  (run* (q)
    (fresh (A B x y1 z1 y2 z2)
      (== `(,x (f ,y1) (g ,y1) (g ,z1)) A)
      (== `(,x (f ,y2) (g ,y2) (g ,z2)) B)
      (unify-setso A B)
      (== `(,A ,B) q)))
  '((((g _.0) (f _.0) (g _.0) (g _.0))
     ((g _.0) (f _.0) (g _.0) (g _.0)))
    (((f _.0) (f _.0) (g _.0) (g _.0))
     ((f _.0) (f _.0) (g _.0) (g _.0)))
    ((((g _.0) (f _.1) (g _.1) (g _.0))
      ((g _.0) (f _.1) (g _.1) (g _.0)))
     (=/= ((_.0 _.1))))
    ((((g _.0) (f _.1) (g _.1) (g _.0))
      ((g _.0) (f _.1) (g _.1) (g _.1)))
     (=/= ((_.0 _.1))))
    ((((f _.0) (f _.0) (g _.0) (g _.1))
      ((f _.0) (f _.0) (g _.0) (g _.1)))
     (=/= ((_.0 _.1))))
    ((((g _.0) (f _.0) (g _.0) (g _.1))
      ((g _.0) (f _.0) (g _.0) (g _.1)))
     (=/= ((_.0 _.1))))
    ((((g _.0) (f _.1) (g _.1) (g _.1))
      ((g _.0) (f _.1) (g _.1) (g _.0)))
     (=/= ((_.0 _.1))))
    (((_.0 (f _.1) (g _.1) (g _.1))
      (_.0 (f _.1) (g _.1) (g _.1)))
     (=/= ((_.0 (f _.1))) ((_.0 (g _.1)))))
    (((_.0 (f _.1) (g _.1) (g _.2))
      (_.0 (f _.1) (g _.1) (g _.2)))
     (=/= ((_.0 (f _.1))) ((_.0 (g _.1))) ((_.0 (g _.2)))
          ((_.1 _.2))))))

(test "unify-setso-experiment-3b"
  ;; experiment 3 on p. 10 of Stolzenburg's 'Membership-Constraints and
  ;; Complexity in Logic Programming with Sets'
  (length (run* (q)
            (fresh (A B x y1 z1 y2 z2)
              (== `(,x (f ,y1) (g ,y1) (g ,z1)) A)
              (== `(,x (f ,y2) (g ,y2) (g ,z2)) B)
              (unify-setso A B)
              (== `(,A ,B) q))))
  9)


#!eof

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

(test "memb-42"
  (run* (q)
    (memb 5 '(6 7 8))
    nevero)
  '())

(test "memb-43"
  (run* (q)
    (== q 7)
    (memb 5 `(6 ,q 8))    
    nevero)
  '())

(test "memb-44"
  (run* (q)
    (memb 5 `(6 ,q 8))
    (== q 7)    
    nevero)
  '())

(test "memb-45"
  (run* (q)
    (=/= q 5)
    (memb 5 `(6 ,q 8)))
  '())

(test "memb-46"
  (run* (q)
    (memb 5 `(6 ,q 8))
    (=/= q 5))
  '())

(test "memb-47"
  (run* (q)
    (=/= q 5)
    (memb 5 `(6 ,q 8))
    nevero)
  '())

(test "memb-48"
  (run* (q)
    (memb 5 `(6 ,q 8))
    (=/= q 5)
    nevero)
  '())

(test "memb-49"
  (run* (q)
    (memb q '(5 6))
    (memb q '(6 7))
    (=/= q 6))
  '())

(test "memb-50"
  (run* (q)
    (memb q '(5 6))
    (=/= q 6)
    (memb q '(6 7)))
  '())

(test "memb-51"
  (run* (q)
    (=/= q 6)
    (memb q '(5 6))
    (memb q '(6 7)))
  '())

;; These seem like the difficult tests, unless memb is fairly eager
(test "memb-52"
  (run* (q)
    (memb q '(5 6))
    (memb q '(6 7))
    (=/= q 6)
    nevero)
  '())

(test "memb-53"
  (run* (q)
    (memb q '(5 6))
    (=/= q 6)
    (memb q '(6 7))
    nevero)
  '())

(test "memb-54"
  (run* (q)
    (=/= q 6)
    (memb q '(5 6))
    (memb q '(6 7))
    nevero)
  '())



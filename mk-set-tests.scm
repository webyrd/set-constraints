(load "mk.scm")
(load "test-check.scm")

(define anyo
  (lambda (g)
    (conde
      (g)
      ((anyo g)))))

(define nevero (anyo fail))
(define alwayso (anyo succeed))

(test "set=-sets-empty-1"
  (run* (q) (set= empty-set empty-set))
  '(_.0))

(test "set=-sets-empty-2"
  (run* (q) (set= empty-set (make-set 5)))
  '())

(test "set=-sets-empty-3"
  (run* (q) (set= (make-set 5) empty-set))
  '())

(test "set=-sets-empty-4"
  (run* (q) (set= (make-set 5) (ext-set empty-set 5)))
  '(_.0))


(test "set=-sets-0"
  (run* (q) (set= (make-set 5 6) (make-set 5 5 6)))
  '(_.0))

(test "set=-sets-1"
  (run* (q) (set= (make-set 5 6) (make-set 5 6)))
  '(_.0))

(test "set=-sets-2"
  (run* (q) (set= (make-set 5 6) (make-set 6 5)))
  '(_.0))

(test "set=-sets-3"
  (run* (q)
    (fresh (x y)
      (set= (make-set 5 6) (make-set x y))
      (== `(,x ,y) q)))
  '((5 6)
    (6 5)))

(test "set=-sets-with-vars-1a"
  (run* (q)
    (fresh (A B x y)
      (set= (make-set 5 6) A)
      (set= (make-set x y) B)
      (set= A B)
      (== `(,x ,y) q)))
  '((5 6)
    (6 5)))

(test "set=-sets-with-vars-1b"
  (run* (q)
    (fresh (A B x y)
      (set= (make-set x y) B)
      (set= (make-set 5 6) A)
      (set= A B)
      (== `(,x ,y) q)))
  '((5 6)
    (6 5)))

(test "set=-sets-with-vars-1c"
  (run* (q)
    (fresh (A B x y)
      (set= A B)
      (set= (make-set x y) B)
      (set= (make-set 5 6) A)
      (== `(,x ,y) q)))
  '((5 6)
    (6 5)))

(test "set=-sets-with-vars-1d"
  (run* (q)
    (fresh (A B x y)
      (== `(,x ,y) q)
      (set= A B)
      (set= (make-set x y) B)
      (set= (make-set 5 6) A)))
  '((5 6)
    (6 5)))

(test "set=-sets-with-vars-1e"
  (run* (q)
    (fresh (A B x y)
      (== `(,x ,y) q)
      (set= (make-set x y) B)
      (set= A B)
      (set= (make-set 5 6) A)))
  '((5 6)
    (6 5)))

(test "set=-sets-with-vars-1f"
  (run* (q)
    (fresh (A B x y)
      (== `(,x ,y) q)
      (set= (make-set 5 6) A)
      (set= A B)
      (set= (make-set x y) B)))
  '((6 5)
    (5 6)))

(test "set=-sets-4"
  (run* (q)
    (fresh (A B u v x y)
      (set= (make-set u v) (make-set x y))
      (== `((,u ,v) (,x ,y)) q)))
  '(((_.0 _.0) (_.0 _.0))
    (((_.0 _.1) (_.1 _.0)) (=/= ((_.0 _.1))))
    (((_.0 _.1) (_.0 _.1)) (=/= ((_.0 _.1))))))

(test "set=-sets-experiment-1a"
;; experiment 1 on p. 10 of Stolzenburg's 'Membership-Constraints and
;; Complexity in Logic Programming with Sets'
  (run* (q)
    (fresh (B w x y z)
      (set= (make-set w x y z) (make-set 'a 'b))
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

(test "set=-sets-experiment-1b"
;; experiment 1 on p. 10 of Stolzenburg's 'Membership-Constraints and
;; Complexity in Logic Programming with Sets'  
  (length
   (run* (q)
     (fresh (w x y z)
       (set= (make-set w x y z) (make-set 'a 'b)))))
  14)

(test "set=-sets-experiment-2a"
;; experiment 2 on p. 10 of Stolzenburg's 'Membership-Constraints and
;; Complexity in Logic Programming with Sets'
;;
;; Hmmm.  Doesn't seem to match the number of answers from the paper.
  (run* (q)
    (fresh (x y z)
      (set= (make-set x y z) (make-set x y z))
      (== `((,x ,y ,z) (,x ,y ,z)) q)))
  '(((_.0 _.0 _.0) (_.0 _.0 _.0))
    (((_.0 _.1 _.0) (_.0 _.1 _.0)) (=/= ((_.0 _.1))))
    (((_.0 _.1 _.1) (_.0 _.1 _.1)) (=/= ((_.0 _.1))))
    (((_.0 _.0 _.1) (_.0 _.0 _.1)) (=/= ((_.0 _.1))))
    (((_.0 _.1 _.2) (_.0 _.1 _.2)) (=/= ((_.0 _.1)) ((_.0 _.2)) ((_.1 _.2))))))

(test "set=-sets-experiment-2b"
  ;; experiment 2 on p. 10 of Stolzenburg's 'Membership-Constraints and
  ;; Complexity in Logic Programming with Sets'
  (length
   (run* (q)
     (fresh (x y z)
       (set= (make-set x y z) (make-set x y z))
       (== `((,x ,y ,z) (,x ,y ,z)) q))))
  5)

(test "set=-sets-experiment-3a"
  ;; experiment 3 on p. 10 of Stolzenburg's 'Membership-Constraints and
  ;; Complexity in Logic Programming with Sets'
  (run* (q)
    (fresh (x y1 z1 y2 z2)
      (set= (make-set x `(f ,y1) `(g ,y1) `(g ,z1))
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

(test "set=-sets-experiment-3b"
  ;; experiment 3 on p. 10 of Stolzenburg's 'Membership-Constraints and
  ;; Complexity in Logic Programming with Sets'
  (length
   (run* (q)
     (fresh (x y1 z1 y2 z2)
       (set= (make-set x `(f ,y1) `(g ,y1) `(g ,z1))
             (make-set x `(f ,y2) `(g ,y2) `(g ,z2)))
       (== `((,x (f ,y1) (g ,y1) (g ,z1))
             (,x (f ,y2) (g ,y2) (g ,z2)))
           q))))
  9)


(test "elem-0"
  (run* (q) (elem q (make-set 5 6)))
  '(5 6))

(test "elem-1"
  (run* (q) (elem q empty-set))
  '())

(test "elem-2"
  (run* (q) (elem q (ext-set empty-set 5 6)))
  '(5 6))

(test "elem-3"
  (run* (q)
    (elem q (make-set 5))
    (elem q (make-set 6))
    nevero)
  '())

(test "elem-4"
  (run* (q)
    (elem q (make-set 5 6))
    (elem q (make-set 7 8))
    nevero)
  '())

(test "elem-5"
  (run* (q)
    (elem q (make-set 5 6))
    (elem q (make-set 6 7)))
  '(6))

(test "elem-6"
  (run* (q)
    (elem q (make-set 5 6))
    (elem q (make-set 6 7))
    (=/= 6 q))
  '())

(test "elem-7"
  (run* (q)
    (elem q (make-set 5 6))
    (not-elem q (make-set 5 6)))
  '())

(test "elem-7"
  (run* (q)
    (not-elem q (make-set 5 6))
    (elem q (make-set 5 6)))
  '())


(test "not-elem-0"
  (run* (q) (not-elem q (make-set 5 6)))
  '((_.0 (=/= ((_.0 5)) ((_.0 6))))))

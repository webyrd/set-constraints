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

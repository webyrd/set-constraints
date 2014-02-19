(load "mk.scm")
(load "matche.scm")
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

(test "elem-8"
  (run* (q)
    (not-elem q (make-set 5 6))
    (elem q (make-set 5 6)))
  '())

(test "elem-9"
  (run* (q)
    (fresh (x y)
      (elem q (make-set x y))))
  '(_.0 _.0))

(test "elem-10"
  (run* (q)
    (fresh (x y)
      (== x y)
      (elem q (make-set x y))))
  '(_.0))

(test "elem-11"
  (run* (q)
    (fresh (x y)
      (elem q (make-set x y))
      (== x y)))
  '(_.0))

;; TODO
;;
;; This test currently is erroneous, since the second arg to elem must
;; be a set, not a fresh variable.  Should probably fix this.  Or, at
;; least should work if the second argument is a set with a non-empty
;; tail.
;;
#;(test "elem-12"
  (run 5 (q)
    (elem 5 q))
  '???)


(test "not-elem-0"
  (run* (q) (not-elem q (make-set 5 6)))
  '((_.0 (=/= ((_.0 5)) ((_.0 6))))))



;; Find all free variables in a lambda-calculus expression
;;
;; 'project' is necessary, since ext-set is just a Scheme constructor,
;; and doesn't know which values are associated with a logic variable.
;; Probably ext-set should be a relation, not a Scheme constructor.
;;
;;
;; moded:
;;
;; (exp bound-vars+ free-in+ free-out)
;;
;; both bound-vars and free-in cannot be fresh variables--they must be bound to sets
;;
;; this is because elem and not-elem expect their second args to be sets, not vars,
;; and also because ext-set requires its first element to be a set, not a var.
;;
;; maybe I can get around this by delaying elem and not-elem when
;; their arguments aren't sufficiently ground, and by reifying these
;; constraints if they never become sufficiently ground.  And maybe I
;; can use a more general 'extend-set' constraint, rather than
;; 'ext-set'.  Extending set unification to handle tails doesn't seem
;; sufficient, since set unification isn't the problem.  But should be
;; easy to extend ext-set to handle sets with tails.
(define all-freeo
  (lambda (exp bound-vars free-in free-out)
    (matche exp
      (,x (symbolo x)
       (conde
         ((elem x bound-vars)
          (set= free-in free-out))
         ((not-elem x bound-vars)
          (project (free-in)
            (set= (ext-set free-in x) free-out)))))
      ((lambda (,x) ,body)
       (project (bound-vars)
         (all-freeo body (ext-set bound-vars x) free-in free-out)))
      ((,e1 ,e2)
       (fresh (free-in^)
         (all-freeo e1 bound-vars free-in free-in^)
         (all-freeo e2 bound-vars free-in^ free-out))))))

(test "all-freeo-1"
  (run* (q) (all-freeo 'y empty-set empty-set q))
  '((set-tag y)))

(test "all-freeo-2"
  (run* (q) (all-freeo '(lambda (z) z) empty-set empty-set q))
  '((set-tag)))

(test "all-freeo-3"
  (run* (q) (all-freeo '(lambda (z) w) empty-set empty-set q))
  '((set-tag w)))

(test "all-freeo-4"
  (run* (q) (all-freeo '(v w) empty-set empty-set q))
  '((set-tag v w)))

(test "all-freeo-5"
  (run* (q) (all-freeo '((lambda (x) x) (lambda (x) x)) empty-set empty-set q))
  '((set-tag)))

(test "all-freeo-6"
  (run* (q) (all-freeo '(lambda (x) ((y x) z)) empty-set empty-set q))
  '((set-tag y z)))

(test "all-freeo-7"
  (run 10 (q) (all-freeo q empty-set empty-set (ext-set empty-set 'y 'z)))
  '((z y)
    (y z)
    ((z (lambda (_.0) y)) (=/= ((_.0 y))))
    ((y (lambda (_.0) z)) (=/= ((_.0 z))))
    (((lambda (_.0) z) y) (=/= ((_.0 z))))
    (((lambda (_.0) y) z) (=/= ((_.0 y))))
    (z (y y))
    ((lambda (_.0) (z y)) (=/= ((_.0 y)) ((_.0 z))))
    ((lambda (_.0) (y z)) (=/= ((_.0 y)) ((_.0 z))))
    (y (z y))))

(test "all-freeo-8"
  (run 10 (q) (all-freeo q empty-set empty-set (ext-set empty-set 'y 'y 'z)))
  '((z y)
    (y z)
    ((z (lambda (_.0) y)) (=/= ((_.0 y))))
    ((y (lambda (_.0) z)) (=/= ((_.0 z))))
    (((lambda (_.0) z) y) (=/= ((_.0 z))))
    (((lambda (_.0) y) z) (=/= ((_.0 y))))
    (z (y y))
    ((lambda (_.0) (z y)) (=/= ((_.0 y)) ((_.0 z))))
    ((lambda (_.0) (y z)) (=/= ((_.0 y)) ((_.0 z))))
    (y (z y))))

(test "all-freeo-9"
  (run 10 (q)
    (fresh (exp x y)
      (all-freeo exp empty-set empty-set (ext-set empty-set x y))
      (== `(,exp => ,x ,y) q)))
  '(((_.0 => _.0 _.0) (sym _.0))
    (((lambda (_.0) _.1) => _.1 _.1) (=/= ((_.0 _.1))) (sym _.1))
    (((_.0 _.0) => _.0 _.0) (sym _.0))
    (((lambda (_.0) (lambda (_.1) _.2)) => _.2 _.2) (=/= ((_.0 _.2)) ((_.1 _.2))) (sym _.2))
    (((_.0 _.1) => _.1 _.0) (=/= ((_.0 _.1))) (sym _.0 _.1))
    ((((lambda (_.0) _.0) _.1) => _.1 _.1) (sym _.0 _.1))
    (((_.0 _.1) => _.0 _.1) (=/= ((_.0 _.1))) (sym _.0 _.1))
    (((lambda (_.0) (_.0 _.1)) => _.1 _.1) (=/= ((_.0 _.1))) (sym _.0 _.1))
    (((lambda (_.0) (lambda (_.1) (lambda (_.2) _.3))) => _.3 _.3) (=/= ((_.0 _.3)) ((_.1 _.3)) ((_.2 _.3))) (sym _.3))
    (((_.0 (lambda (_.1) _.1)) => _.0 _.0) (sym _.0 _.1))))

(test "all-freeo-10"
  (run 10 (q)
    (fresh (exp x y)
      (=/= x y)
      (all-freeo exp empty-set empty-set (ext-set empty-set x y))
      (== `(,exp => ,x ,y) q)))
  '((((_.0 _.1) => _.1 _.0) (=/= ((_.0 _.1))) (sym _.0 _.1))
    (((_.0 _.1) => _.0 _.1) (=/= ((_.0 _.1))) (sym _.0 _.1))
    (((_.0 (lambda (_.1) _.2)) => _.2 _.0) (=/= ((_.0 _.2)) ((_.1 _.2))) (sym _.0 _.2))
    (((_.0 (lambda (_.1) _.2)) => _.0 _.2) (=/= ((_.0 _.2)) ((_.1 _.2))) (sym _.0 _.2))
    ((((lambda (_.0) _.1) _.2) => _.2 _.1) (=/= ((_.0 _.1)) ((_.1 _.2))) (sym _.1 _.2))
    ((((lambda (_.0) _.1) _.2) => _.1 _.2) (=/= ((_.0 _.1)) ((_.1 _.2))) (sym _.1 _.2))
    (((_.0 (_.1 _.1)) => _.1 _.0) (=/= ((_.0 _.1))) (sym _.0 _.1))
    (((lambda (_.0) (_.1 _.2)) => _.2 _.1) (=/= ((_.0 _.1)) ((_.0 _.2)) ((_.1 _.2))) (sym _.1 _.2))
    (((lambda (_.0) (_.1 _.2)) => _.1 _.2) (=/= ((_.0 _.1)) ((_.0 _.2)) ((_.1 _.2))) (sym _.1 _.2))
    (((_.0 (_.1 _.0)) => _.0 _.1) (=/= ((_.0 _.1))) (sym _.0 _.1))))



;; abstract interpretation of signs, from:
;;
;; http://matt.might.net/articles/intro-static-analysis/
;;
;; two negative numbers, added together, results in another negative number.
(define ai+-minus-minus
  (lambda (s1 s2 in-set out-set)
    (conde
      ((elem '- s1)
       (conde
         ((elem '- s2)
          (project (in-set)
            (set= (ext-set in-set '-) out-set)))
         ((not-elem '- s2)
          (set= in-set out-set))))
      ((not-elem '- s1)
       (set= in-set out-set)))))

(test "ai+-minus-minus-1"
  (run* (q) (ai+-minus-minus (make-set '-) (make-set '-) empty-set q))
  '((set-tag -)))

(test "ai+-minus-minus-2"
  (run* (q) (ai+-minus-minus (make-set '-) (make-set '-) empty-set (make-set '-)))
  '(_.0))

(test "ai+-minus-minus-3"
  (run* (q) (ai+-minus-minus (make-set q) (make-set '-) empty-set (make-set '-)))
  '(-))

(test "ai+-minus-minus-4"
  (run* (q)
    (fresh (x y z)
      (ai+-minus-minus (make-set x) (make-set y) empty-set (make-set z))
      (== `(,x ,y ,z) q)))
  '((- - -)))

(test "ai+-minus-minus-5"
  (run* (q) (ai+-minus-minus (make-set '+) (make-set '+) empty-set q))
  `(,empty-set))


(define ai+-minus-zero
  (lambda (s1 s2 in-set out-set)
    (conde
      ((elem '- s1)
       (conde
         ((elem 0 s2)
          (project (in-set)
            (set= (ext-set in-set '-) out-set)))
         ((not-elem 0 s2)
          (set= in-set out-set))))
      ((not-elem '- s1)
       (set= in-set out-set)))))

(test "ai+-minus-zero-1"
  (run* (q) (ai+-minus-zero (make-set '-) (make-set 0) empty-set q))
  '((set-tag -)))

(test "ai+-minus-zero-2"
  (run* (q) (ai+-minus-zero (make-set '-) (make-set 0) empty-set (make-set '-)))
  '(_.0))

(test "ai+-minus-zero-3"
  (run* (q) (ai+-minus-zero (make-set q) (make-set 0) empty-set (make-set '-)))
  '(-))

(test "ai+-minus-zero-4"
  (run* (q)
    (fresh (x y z)
      (ai+-minus-zero (make-set x) (make-set y) empty-set (make-set z))
      (== `(,x ,y ,z) q)))
  '((- 0 -)))

(test "ai+-minus-zero-5"
  (run* (q) (ai+-minus-zero (make-set '+) (make-set '+) empty-set q))
  `(,empty-set))


(define ai+-minus-plus
  (lambda (s1 s2 in-set out-set)
    (conde
      ((elem '- s1)
       (conde
         ((elem '+ s2)
          (project (in-set)
            (set= (ext-set in-set '- 0 '+) out-set)))
         ((not-elem '+ s2)
          (set= in-set out-set))))
      ((not-elem '- s1)
       (set= in-set out-set)))))

(test "ai+-minus-plus-1"
  (run* (q) (ai+-minus-plus (make-set '-) (make-set '+) empty-set q))
  '((set-tag - 0 +)))

(test "ai+-minus-plus-2a"
  (run* (q) (ai+-minus-plus (make-set '-) (make-set '+) empty-set (make-set '- 0 '+)))
  '(_.0))

(test "ai+-minus-plus-2b"
  (run* (q) (ai+-minus-plus (make-set '-) (make-set '+) empty-set (make-set 0 '- '+)))
  '(_.0))

(test "ai+-minus-plus-2c"
  (run* (q) (ai+-minus-plus (make-set '-) (make-set '+) empty-set (make-set '+ 0 '- '+ 0)))
  '(_.0))

(test "ai+-minus-plus-3"
  (run* (q) (ai+-minus-plus (make-set q) (make-set '+) empty-set (make-set '- 0 '+)))
  '(-))

(test "ai+-minus-plus-4"
  (run* (q)
    (fresh (a b)
      (ai+-minus-plus (make-set a) (make-set b) empty-set (make-set '- 0 '+))
      (== `(,a ,b) q)))
  '((- +)))

(test "ai+-minus-plus-5"
  (run* (q) (ai+-minus-plus (make-set '+) (make-set '+) empty-set q))
  `(,empty-set))

(test "ai+-minus-plus-6"
  (run* (q)
    (fresh (a b x y z)
      (ai+-minus-plus (make-set a) (make-set b) empty-set (make-set x y z))
      (== `(,a ,b ,x ,y ,z) q)))
  '((- + - 0 +)
    (- + - + 0)
    (- + 0 + -)
    (- + 0 - +)
    (- + + - 0)
    (- + + 0 -)))



(define ai+-zero-anything
  (lambda (s1 s2 in-set out-set)
    (conde
      ((elem 0 s1)
       (set= s2 out-set))
      ((not-elem 0 s1)
       (set= in-set out-set)))))

(test "ai+-zero-anything-1a"
  (run* (q) (ai+-zero-anything (make-set 0) (make-set '-) empty-set q))
  '((set-tag -)))

(test "ai+-zero-anything-1b"
  (run* (q) (ai+-zero-anything (make-set 0) (make-set '- 0) empty-set q))
  '((set-tag - 0)))

(test "ai+-zero-anything-1c"
  (run* (q) (ai+-zero-anything (make-set 0) (make-set '- 0 '+) empty-set q))
  '((set-tag - 0 +)))

(test "ai+-zero-anything-2"
  (run* (q) (ai+-zero-anything (make-set 0) (make-set '-) empty-set (make-set '-)))
  '(_.0))

(test "ai+-zero-anything-3"
  (run* (q) (ai+-zero-anything (make-set q) (make-set '-) empty-set (make-set '-)))
  '(0))

(test "ai+-zero-anything-4"
  (run* (q)
    (fresh (x y z)
      (ai+-zero-anything (make-set x) (make-set y) empty-set (make-set z))
      (== `(,x ,y ,z) q)))
  '((0 _.0 _.0)))

(test "ai+-zero-anything-5"
  (run* (q) (ai+-zero-anything (make-set '+) (make-set '+) empty-set q))
  `(,empty-set))



(define ai+-plus-minus
  (lambda (s1 s2 in-set out-set)
    (conde
      ((elem '+ s1)
       (conde
         ((elem '- s2)
          (project (in-set)
            (set= (ext-set in-set '- 0 '+) out-set)))
         ((not-elem '- s2)
          (set= in-set out-set))))
      ((not-elem '+ s1)
       (set= in-set out-set)))))

(test "ai+-plus-minus-1"
  (run* (q) (ai+-plus-minus (make-set '+) (make-set '-) empty-set q))
  '((set-tag - 0 +)))

(test "ai+-plus-minus-2a"
  (run* (q) (ai+-plus-minus (make-set '+) (make-set '-) empty-set (make-set '- 0 '+)))
  '(_.0))

(test "ai+-plus-minus-2b"
  (run* (q) (ai+-plus-minus (make-set '+) (make-set '-) empty-set (make-set 0 '- '+)))
  '(_.0))

(test "ai+-plus-minus-2c"
  (run* (q) (ai+-plus-minus (make-set '+) (make-set '-) empty-set (make-set '+ 0 '- '+ 0)))
  '(_.0))

(test "ai+-plus-minus-3"
  (run* (q) (ai+-plus-minus (make-set q) (make-set '-) empty-set (make-set '- 0 '+)))
  '(+))

(test "ai+-plus-minus-4"
  (run* (q)
    (fresh (a b)
      (ai+-plus-minus (make-set a) (make-set b) empty-set (make-set '- 0 '+))
      (== `(,a ,b) q)))
  '((+ -)))

(test "ai+-plus-minus-5"
  (run* (q) (ai+-plus-minus (make-set '+) (make-set '+) empty-set q))
  `(,empty-set))

(test "ai+-plus-minus-6"
  (run* (q)
    (fresh (a b x y z)
      (ai+-plus-minus (make-set a) (make-set b) empty-set (make-set x y z))
      (== `(,a ,b ,x ,y ,z) q)))
  '((+ - - 0 +)
    (+ - - + 0)
    (+ - 0 + -)
    (+ - 0 - +)
    (+ - + - 0)
    (+ - + 0 -)))


(define ai+-plus-zero
  (lambda (s1 s2 in-set out-set)
    (conde
      ((elem '+ s1)
       (conde
         ((elem 0 s2)
          (project (in-set)
            (set= (ext-set in-set '+) out-set)))
         ((not-elem 0 s2)
          (set= in-set out-set))))
      ((not-elem '+ s1)
       (set= in-set out-set)))))

(test "ai+-plus-zero-1"
  (run* (q) (ai+-plus-zero (make-set '+) (make-set 0) empty-set q))
  '((set-tag +)))

(test "ai+-plus-zero-2"
  (run* (q) (ai+-plus-zero (make-set '+) (make-set 0) empty-set (make-set '+)))
  '(_.0))

(test "ai+-plus-zero-3"
  (run* (q) (ai+-plus-zero (make-set q) (make-set 0) empty-set (make-set '+)))
  '(+))

(test "ai+-plus-zero-4"
  (run* (q)
    (fresh (x y z)
      (ai+-plus-zero (make-set x) (make-set y) empty-set (make-set z))
      (== `(,x ,y ,z) q)))
  '((+ 0 +)))

(test "ai+-plus-zero-5"
  (run* (q) (ai+-plus-zero (make-set '+) (make-set '+) empty-set q))
  `(,empty-set))


(define ai+-plus-plus
  (lambda (s1 s2 in-set out-set)
    (conde
      ((elem '+ s1)
       (conde
         ((elem '+ s2)
          (project (in-set)
            (set= (ext-set in-set '+) out-set)))
         ((not-elem '+ s2)
          (set= in-set out-set))))
      ((not-elem '+ s1)
       (set= in-set out-set)))))

(test "ai+-plus-plus-1"
  (run* (q) (ai+-plus-plus (make-set '+) (make-set '+) empty-set q))
  '((set-tag +)))

(test "ai+-plus-plus-2"
  (run* (q) (ai+-plus-plus (make-set '+) (make-set '+) empty-set (make-set '+)))
  '(_.0))

(test "ai+-plus-plus-3"
  (run* (q) (ai+-plus-plus (make-set q) (make-set '+) empty-set (make-set '+)))
  '(+))

(test "ai+-plus-plus-4"
  (run* (q)
    (fresh (x y z)
      (ai+-plus-plus (make-set x) (make-set y) empty-set (make-set z))
      (== `(,x ,y ,z) q)))
  '((+ + +)))

(test "ai+-plus-plus-5"
  (run* (q) (ai+-plus-plus (make-set '-) (make-set '-) empty-set q))
  `(,empty-set))


;;; combine multiple a+ relations

(test "ai+-minus/plus-and-plus/minus-1a"
  (run* (q)
    (fresh (A B C D)
      (set= (make-set '- '+) A)
      (set= (make-set '- '+) B)
      (ai+-plus-minus A B empty-set C)
      (ai+-minus-plus A B empty-set D)
      (== `(,A ,B ,C ,D) q)))
  '(((set-tag - +)
     (set-tag - +)
     (set-tag - 0 +)
     (set-tag - 0 +))))

(test "ai+-minus/plus-and-plus/minus-1b"
  (run* (q)
    (fresh (C D)
      (ai+-plus-minus (make-set '- '+) (make-set '- '+) empty-set C)
      (ai+-minus-plus (make-set '- '+) (make-set '- '+) empty-set D)
      (== `(,C ,D) q)))
  '(((set-tag - 0 +)
     (set-tag - 0 +))))

(test "ai+-minus/plus-and-plus/minus-2a"
  (run* (q)
    (fresh (A B x y z)
      (set= (make-set '- '+) A)
      (set= (make-set '- '+) B)
      (ai+-plus-minus A B empty-set (make-set x y z))
      (ai+-minus-plus A B empty-set (make-set x y z))
      (== `(,A ,B ,x ,y ,z) q)))
  '(((set-tag - +) (set-tag - +) - 0 +)
    ((set-tag - +) (set-tag - +) - + 0)
    ((set-tag - +) (set-tag - +) 0 + -)
    ((set-tag - +) (set-tag - +) 0 - +)
    ((set-tag - +) (set-tag - +) + - 0)
    ((set-tag - +) (set-tag - +) + 0 -)))

(test "ai+-minus/plus-and-plus/minus-2b"
  (run* (q)
    (fresh (A B C x y z)
      (set= (make-set '- '+) A)
      (set= (make-set '- '+) B)
      (set= (make-set x y z) C)
      (ai+-plus-minus A B empty-set C)
      (ai+-minus-plus A B empty-set C)
      (== `(,A ,B ,C) q)))
  '(((set-tag - +) (set-tag - +) (set-tag - 0 +))
    ((set-tag - +) (set-tag - +) (set-tag - + 0))
    ((set-tag - +) (set-tag - +) (set-tag 0 + -))
    ((set-tag - +) (set-tag - +) (set-tag 0 - +))
    ((set-tag - +) (set-tag - +) (set-tag + - 0))
    ((set-tag - +) (set-tag - +) (set-tag + 0 -))))

(test "ai+-minus/plus-and-plus/minus-3"
  (run* (q)
    (fresh (A B C x y v w)
      (set= (make-set x y) A)
      (set= (make-set v w) B)
      (set= (make-set '- 0 '+) C)
      (ai+-plus-minus A B empty-set C)
      (ai+-minus-plus A B empty-set C)
      (== `(,A ,B ,C) q)))
  '(((set-tag + -) (set-tag - +) (set-tag - 0 +))
    ((set-tag - +) (set-tag - +) (set-tag - 0 +))
    ((set-tag + -) (set-tag + -) (set-tag - 0 +))
    ((set-tag - +) (set-tag + -) (set-tag - 0 +))))


;; combine all the ai + relations
(define ai+
  (lambda (s1 s2 s3)
    (fresh (res1 res2 res3 res4 res5 res6)
      (ai+-minus-minus s1 s2 empty-set res1)
      (ai+-minus-zero s1 s2 res1 res2)
      (ai+-minus-plus s1 s2 res2 res3)
      (ai+-zero-anything s1 s2 res3 res4)
      (ai+-plus-minus s1 s2 res4 res5)
      (ai+-plus-zero s1 s2 res5 res6)
      (ai+-plus-plus s1 s2 res6 s3))))

(test "ai+-1"
  (run* (q) (ai+ (make-set '+) (make-set '+) q))
  '((set-tag +)))

;; TODO
;;
;; make a smarter set extension that will avoid adding syntactically duplicate elements.
(test "ai+-2"
  (run* (q) (ai+ (make-set '- '+) (make-set '+) q))
  '((set-tag - 0 + +)))

(test "ai+-3"
  (run* (q)
    (fresh (x y)
      (ai+ (make-set x) (make-set y) (make-set '+))
      (== `(,x ,y) q)))
  '((0 +)
    (+ +)
    (+ 0)))

(test "ai+-4"
  (run* (q)
    (fresh (x y)
      (ai+ (make-set x) (make-set y) (make-set '- 0 '+))
      (== `(,x ,y) q)))
  '((+ -)
    (- +)))

(test "ai+-5"
  (run* (q)
    (fresh (x y)
      (ai+ (make-set x) (make-set y) (make-set '- '+))
      (== `(,x ,y) q)))
  '())

(test "ai+-6"
  (run* (q)
    (ai+ (make-set 0) (make-set 0 '+) q))
  '((set-tag 0 +)))

(test "ai+-7"
  (run* (q)
    (fresh (x y)
      (ai+ (make-set x) (make-set y) (make-set 0 '+))
      (== `(,x ,y) q)))
  '())

(test "ai+-8"
  (run* (q)
    (fresh (x y z)
      (ai+ (make-set x) (make-set y z) (make-set 0 '+))
      (== `(,x ,y ,z) q)))
  '((0 + 0)
    (0 0 +)))

(test "ai+-9"
  (run 1 (q)
    (fresh (a b c u v w x y z)
      (ai+ (make-set a b c) (make-set u v w) (make-set x y z))
      (== `((,a ,b ,c) (,u ,v ,w) (,x ,y ,z)) q)))
  '((((0 _.0 _.1) (_.2 _.2 _.2) (_.2 _.2 _.2))
     (=/= ((_.0 +)) ((_.0 -))
          ((_.1 +)) ((_.1 -))))))

(test "ai+-10"
  (run 1 (q)
    (fresh (a b c u v w x y z)
      (=/= x y)
      (=/= x z)
      (=/= y z)
      (ai+ (make-set a b c) (make-set u v w) (make-set x y z))
      (== `((,a ,b ,c) (,u ,v ,w) (,x ,y ,z)) q)))
  '((((0 _.0 _.1) (_.2 _.3 _.4) (_.2 _.4 _.3))
     (=/= ((_.0 +)) ((_.0 -))
          ((_.1 +)) ((_.1 -))
          ((_.2 _.3)) ((_.2 _.4)) ((_.3 _.4))))))

(test "ai+-11"
  (run 5 (q)
    (fresh (a b c u v w)
      (ai+ (make-set a b c) (make-set u v w) (make-set '- 0 '+))
      (== `((,a ,b ,c) (,u ,v ,w)) q)))
  '((((0 _.0 _.1) (- + 0))
     (=/= ((_.0 +)) ((_.0 -)) ((_.1 +)) ((_.1 -))))
    (((0 _.0 _.1) (- 0 +))
     (=/= ((_.0 +)) ((_.0 -)) ((_.1 +)) ((_.1 -))))
    (((0 _.0 _.1) (+ - 0))
     (=/= ((_.0 +)) ((_.0 -)) ((_.1 +)) ((_.1 -))))
    (((0 + _.0) (- 0 +)) (=/= ((_.0 -))))
    (((0 _.0 _.1) (0 - +))
     (=/= ((_.0 +)) ((_.0 -)) ((_.1 +)) ((_.1 -))))))

;; TODO
;;
;; should be able to cut this number down
(test "ai+-12"
  (length
    (run* (q)
      (fresh (a b c u v w)
        (ai+ (make-set a b c) (make-set u v w) (make-set '- 0 '+))
        (== `((,a ,b ,c) (,u ,v ,w)) q))))
  588)




;; Broken version of termso
;;
;; From p. 27 of Pierce's 'Types and Programming Languages'
;; Using Peano numerals: z, (s z), (s (s z)), etc
;;
;; Tricky, since Pierce uses set-builder notation to construct a new
;; set using elements of another set.
;;
;; I think I can implement this if I make a remove-element constraint
;; that takes an element and two sets, where the second set is the
;; first set with all occurrences of the first element removed.
;; I suppose I can do this with disequality constraints.
;;
;; Assuming I have a remove-element constraint, I could write a
;; recursive helper that removes elements from the set until it is
;; empty.  For each removed element that isn't in Si, the helper would
;; add that element to Si.
(define termso
  (lambda (i Si)
    (conde
      ((== 'z i)
       (set= empty-set Si))
      ((== '(s z) i)
       (fresh (S0)
         (termso 'z S0)
         (project (S0)
           (set= (ext-set S0 'true 'false) Si))))
      ((fresh (i-2 Si-1)
         (== `(s (s ,i-2)) i)
         (fresh (Si-1)
           (termso `(s ,i-2) Si-1)
           (terms-add-singletonso Si-1 Si-1 Si)))))))

;; adding 'if' seems trickier...
;;
;; seems like intensional sets would help here
;;
;; or, I could use setof/bagof, although they have their own tradeoffs
(define terms-add-singletonso
  (lambda (Si-1 S-acc Si)
    (conde
      ((set= empty-set Si-1)
       (set= S-acc Si))
      ((fresh (t Si-1^ S-acc^)
         (remove-elemento t Si-1 Si-1^)
         (project (S-acc)
           (set= (ext-set
                  S-acc
                  `(succ ,t)
                  `(pred ,t)
                  `(iszero ,t))
                 S-acc^))
         (terms-add-singletonso Si-1^ S-acc^ Si))))))

;; Can implement 'remove-element' directly as a miniKanren relation,
;; provided set unification supports sets with tails.
;;
;; remove-elemento won't work correctly, without support for tails!!
(define remove-elemento
  (lambda (e s-in s-out)
    (conde
      ((set= empty-set s-in)
       (set= empty-set s-out))
      ((fresh (a d)
         (set= `(,set-tag ,a . ,d) s-in)
         (conde
           ((== e a)
            (remove-elemento e `(,set-tag . ,d) s-out))           
          ((=/= e a)
           (fresh (res)
             (remove-elemento e `(,set-tag . ,d) `(,set-tag . ,res))
             (set= `(set-tag ,a . ,res) s-out)))))))))

;; won't work correctly, without support for tails!!
#;(test "remove-elemento-0a"
  (run 1 (q)
    (fresh (e out)
      (remove-elemento e empty-set out)
      (== `(,e ,out) q)))
  '((_.0 (set-tag))))

;; won't work correctly, without support for tails!!
#;(test "remove-elemento-0b"
  (run* (q)
    (fresh (e out)
      (remove-elemento e empty-set out)
      (== `(,e ,out) q)))
  '((_.0 (set-tag))))

;; won't work correctly, without support for tails!!
#;(test "remove-elemento-1a"
  (run 1 (q)
    (fresh (e out)
      (remove-elemento e (ext-set empty-set 'a) out)
      (== `(,e ,out) q)))
  '((a (set-tag))))

;; won't work correctly, without support for tails!!
#;(test "remove-elemento-1b"
  (run 2 (q)
    (fresh (e out)
      (remove-elemento e (ext-set empty-set 'a) out)
      (== `(,e ,out) q)))
  '((a (set-tag))
    ((_.0 (set-tag a)) (=/= ((_.0 a))))))

;; broken, until can handle set-unification with tails
;; (returns duplicate answers)
#;(test "remove-elemento-1c"
  (run 3 (q)
    (fresh (e out)
      (remove-elemento e (ext-set empty-set 'a) out)
      (== `(,e ,out) q)))
  '((a (set-tag))
    ((_.0 (set-tag a)) (=/= ((_.0 a))))))

;; broken, until can handle set-unification with tails
;; (returns duplicate answers)
#;(test "remove-elemento-1d"
  (run* (q)
    (fresh (e out)
      (remove-elemento e (ext-set empty-set 'a) out)
      (== `(,e ,out) q)))
  '((a (set-tag))))

;; run* is broken until I support set unification with tails
;;
#;(test "remove-elemento-2"
  (run 2 (q)
    (fresh (e out)
      (remove-elemento e (ext-set empty-set 'a 'b) out)
      (== `(,e ,out) q)))
  '((b (set-tag a)) (a (set-tag b))))

;; run* is broken until I support set unification with tails
;;
#;(test "remove-elemento-3"
  (run 1 (q)
    (fresh (e out)
      (remove-elemento e (ext-set empty-set 'a 'b 'c) out)
      (== `(,e ,out) q)))
  '((c (set-tag b a))))


(test "termso-1"
  (run* (q) (termso 'z q))
  '((set-tag)))

(test "termso-2"
  (run* (q) (termso '(s z) q))
  '((set-tag true false)))

;; this test currently doesn't work!
;;
;; (test "termso-3"
;;   (run 1 (q) (termso '(s (s z)) q))
;;   '???)

#!eof


;; Can implement extend-set as a miniKanren relation, provided set
;; unification supports sets with tails.  Seems more general than, but
;; less efficient, than the ext-set Scheme constructor.
(define extend-set
  (lambda (e s-in s-out)
    (fresh (d)
      (set= `(,set-tag . ,d) s-in)
      (set= `(,set-tag ,e . ,d) s-out))))

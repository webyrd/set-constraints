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
              (remove-elemento e d res)
              (set= `(set-tag ,a . ,res) s-out)))))))))

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

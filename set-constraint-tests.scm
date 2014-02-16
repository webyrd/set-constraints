(load "mk.scm")
(load "test-check.scm")

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
  '((_.0 _.1)))

(test "memb-12"
  (run* (q)
    (fresh (x y)
      (memb q `((5 ,x) (5 ,y)))))
  '((5 _.0)))




(test "extracto-1"
  (run 1 (q) (fresh (t ls out) (extracto t ls out) (== `(,t ,ls ,out) q)))
  '((_.0 () ())))

(test "extracto-2"
  (run* (q) (extracto '5 '(5) q))
  '())

(test "extracto-3"
  (run* (q) (extracto '5 '(6) q))
  '(()))

(test "extracto-4"
  (run* (q) (fresh (z) (extracto z `(,z) q)))
  '())

(test "extracto-5"
  (run* (q)
    (fresh (v w out)
      (extracto v `(,w) out)
      (== `(,v ,w ,out) q)))
  '((_.0 _.1 (_.1))))

(test "extracto-6"
  (run* (q)
    (fresh (v w x y z out)
      (extracto v `(,w ,x ,y ,z) out)
      (== `(,v ,w ,x ,y ,z ,out) q)))
  '((_.0 _.1 _.2 _.3 _.4 (_.1 _.2 _.3 _.4))))

(test "extracto-7"
  (run* (q)
    (fresh (v w x y z out)
      (extracto `(,v) `(,w (,x) 5 (,y . 6) ,z) out)
      (== `(,v ,w ,x ,y ,z ,out) q)))
  '((_.0 _.1 _.2 _.3 _.4 (_.1 (_.2) _.4))))

(test "extracto-8"
  (run* (q)
    (fresh (v w out)
      (extracto v `(,w ,w) out)
      (== `(,v ,w ,out) q)))
  '((_.0 _.1 (_.1 _.1))))




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

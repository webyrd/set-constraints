(load "mk.scm")
(load "test-check.scm")

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

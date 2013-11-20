(comment "CPSA 2.3.1")
(comment "All input read from kerberos.scm")

(defprotocol kerberos basic
  (defrole init
    (vars (a b ks name) (t t-prime l text) (k skey))
    (trace (send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k))))
  (defrole resp
    (vars (a b ks name) (t t-prime l text) (k skey))
    (trace (recv (cat (enc a t k) (enc t l k a (ltk b ks))))
      (send (enc t-prime k))))
  (defrole keyserver
    (vars (a b ks name) (t l text) (k skey))
    (trace (recv (cat a b))
      (send (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks)))))
    (uniq-orig k)))

(defskeleton kerberos
  (vars (t t-prime l text) (a b ks name) (k skey))
  (defstrand init 4 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (non-orig (ltk a ks) (ltk b ks))
  (traces
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k))))
  (label 0)
  (unrealized (0 1))
  (origs)
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton kerberos
  (vars (t t-prime l text) (a b ks name) (k skey))
  (defstrand init 4 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a a) (b b) (ks ks) (k k))
  (precedes ((1 1) (0 1)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation encryption-test (added-strand keyserver 2)
    (enc t l k b (ltk a ks)) (0 1))
  (traces
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k)))
    ((recv (cat a b))
      (send (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))))
  (label 1)
  (parent 0)
  (unrealized (0 3))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton kerberos
  (vars (t t-prime l text) (a b ks name) (k skey))
  (defstrand init 4 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a b) (b a) (ks ks) (k k))
  (precedes ((1 1) (0 1)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation encryption-test (added-strand keyserver 2)
    (enc t l k b (ltk a ks)) (0 1))
  (traces
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k)))
    ((recv (cat b a))
      (send (cat (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks))))))
  (label 2)
  (parent 0)
  (unrealized (0 3))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton kerberos
  (vars (t t-prime l t-0 l-0 text) (a b ks a-0 b-0 ks-0 name) (k skey))
  (defstrand init 4 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a a) (b b) (ks ks) (k k))
  (defstrand resp 2 (t t-0) (t-prime t-prime) (l l-0) (a a-0) (b b-0)
    (ks ks-0) (k k))
  (precedes ((1 1) (0 1)) ((1 1) (2 0)) ((2 1) (0 3)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation encryption-test (added-strand resp 2) (enc t-prime k)
    (0 3))
  (traces
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k)))
    ((recv (cat a b))
      (send (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks)))))
    ((recv (cat (enc a-0 t-0 k) (enc t-0 l-0 k a-0 (ltk b-0 ks-0))))
      (send (enc t-prime k))))
  (label 3)
  (parent 1)
  (unrealized (2 0))
  (comment "3 in cohort - 3 not yet seen"))

(defskeleton kerberos
  (vars (t t-prime l text) (a b ks name) (k skey))
  (defstrand init 4 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a a) (b b) (ks ks) (k k))
  (deflistener k)
  (precedes ((1 1) (0 1)) ((1 1) (2 0)) ((2 1) (0 3)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation encryption-test (added-listener k) (enc t-prime k) (0 3))
  (traces
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k)))
    ((recv (cat a b))
      (send (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks)))))
    ((recv k) (send k)))
  (label 4)
  (parent 1)
  (unrealized (2 0))
  (comment "empty cohort"))

(defskeleton kerberos
  (vars (t t-prime l t-0 l-0 text) (a b ks a-0 b-0 ks-0 name) (k skey))
  (defstrand init 4 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a b) (b a) (ks ks) (k k))
  (defstrand resp 2 (t t-0) (t-prime t-prime) (l l-0) (a a-0) (b b-0)
    (ks ks-0) (k k))
  (precedes ((1 1) (0 1)) ((1 1) (2 0)) ((2 1) (0 3)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation encryption-test (added-strand resp 2) (enc t-prime k)
    (0 3))
  (traces
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k)))
    ((recv (cat b a))
      (send (cat (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))))
    ((recv (cat (enc a-0 t-0 k) (enc t-0 l-0 k a-0 (ltk b-0 ks-0))))
      (send (enc t-prime k))))
  (label 5)
  (parent 2)
  (unrealized (2 0))
  (comment "3 in cohort - 3 not yet seen"))

(defskeleton kerberos
  (vars (t t-prime l text) (a b ks name) (k skey))
  (defstrand init 4 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a b) (b a) (ks ks) (k k))
  (deflistener k)
  (precedes ((1 1) (0 1)) ((1 1) (2 0)) ((2 1) (0 3)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation encryption-test (added-listener k) (enc t-prime k) (0 3))
  (traces
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k)))
    ((recv (cat b a))
      (send (cat (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))))
    ((recv k) (send k)))
  (label 6)
  (parent 2)
  (unrealized (2 0))
  (comment "empty cohort"))

(defskeleton kerberos
  (vars (t t-prime l l-0 text) (a b ks b-0 ks-0 name) (k skey))
  (defstrand init 4 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a a) (b b) (ks ks) (k k))
  (defstrand resp 2 (t t) (t-prime t-prime) (l l-0) (a a) (b b-0)
    (ks ks-0) (k k))
  (precedes ((0 2) (2 0)) ((1 1) (0 1)) ((2 1) (0 3)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation encryption-test (displaced 3 0 init 3) (enc a-0 t-0 k)
    (2 0))
  (traces
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k)))
    ((recv (cat a b))
      (send (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks)))))
    ((recv (cat (enc a t k) (enc t l-0 k a (ltk b-0 ks-0))))
      (send (enc t-prime k))))
  (label 7)
  (parent 3)
  (unrealized (2 0))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton kerberos
  (vars (t t-prime l t-0 l-0 l-1 text)
    (a b ks a-0 b-0 ks-0 b-1 ks-1 name) (k skey))
  (defstrand init 4 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a a) (b b) (ks ks) (k k))
  (defstrand resp 2 (t t-0) (t-prime t-prime) (l l-0) (a a-0) (b b-0)
    (ks ks-0) (k k))
  (defstrand init 3 (t t-0) (l l-1) (a a-0) (b b-1) (ks ks-1) (k k))
  (precedes ((1 1) (0 1)) ((1 1) (3 1)) ((2 1) (0 3)) ((3 2) (2 0)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation encryption-test (added-strand init 3) (enc a-0 t-0 k)
    (2 0))
  (traces
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k)))
    ((recv (cat a b))
      (send (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks)))))
    ((recv (cat (enc a-0 t-0 k) (enc t-0 l-0 k a-0 (ltk b-0 ks-0))))
      (send (enc t-prime k)))
    ((send (cat a-0 b-1))
      (recv
        (cat (enc t-0 l-1 k b-1 (ltk a-0 ks-1))
          (enc t-0 l-1 k a-0 (ltk b-1 ks-1))))
      (send (cat (enc a-0 t-0 k) (enc t-0 l-1 k a-0 (ltk b-1 ks-1))))))
  (label 8)
  (parent 3)
  (unrealized (3 1))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton kerberos
  (vars (t t-prime l t-0 l-0 text) (a b ks a-0 b-0 ks-0 name) (k skey))
  (defstrand init 4 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a a) (b b) (ks ks) (k k))
  (defstrand resp 2 (t t-0) (t-prime t-prime) (l l-0) (a a-0) (b b-0)
    (ks ks-0) (k k))
  (deflistener k)
  (precedes ((1 1) (0 1)) ((1 1) (3 0)) ((2 1) (0 3)) ((3 1) (2 0)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation encryption-test (added-listener k) (enc a-0 t-0 k) (2 0))
  (traces
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k)))
    ((recv (cat a b))
      (send (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks)))))
    ((recv (cat (enc a-0 t-0 k) (enc t-0 l-0 k a-0 (ltk b-0 ks-0))))
      (send (enc t-prime k))) ((recv k) (send k)))
  (label 9)
  (parent 3)
  (unrealized (3 0))
  (comment "empty cohort"))

(defskeleton kerberos
  (vars (t t-prime l l-0 text) (a b ks b-0 ks-0 name) (k skey))
  (defstrand init 4 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a b) (b a) (ks ks) (k k))
  (defstrand resp 2 (t t) (t-prime t-prime) (l l-0) (a a) (b b-0)
    (ks ks-0) (k k))
  (precedes ((0 2) (2 0)) ((1 1) (0 1)) ((2 1) (0 3)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation encryption-test (displaced 3 0 init 3) (enc a-0 t-0 k)
    (2 0))
  (traces
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k)))
    ((recv (cat b a))
      (send (cat (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))))
    ((recv (cat (enc a t k) (enc t l-0 k a (ltk b-0 ks-0))))
      (send (enc t-prime k))))
  (label 10)
  (parent 5)
  (unrealized (2 0))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton kerberos
  (vars (t t-prime l t-0 l-0 l-1 text)
    (a b ks a-0 b-0 ks-0 b-1 ks-1 name) (k skey))
  (defstrand init 4 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a b) (b a) (ks ks) (k k))
  (defstrand resp 2 (t t-0) (t-prime t-prime) (l l-0) (a a-0) (b b-0)
    (ks ks-0) (k k))
  (defstrand init 3 (t t-0) (l l-1) (a a-0) (b b-1) (ks ks-1) (k k))
  (precedes ((1 1) (0 1)) ((1 1) (3 1)) ((2 1) (0 3)) ((3 2) (2 0)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation encryption-test (added-strand init 3) (enc a-0 t-0 k)
    (2 0))
  (traces
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k)))
    ((recv (cat b a))
      (send (cat (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))))
    ((recv (cat (enc a-0 t-0 k) (enc t-0 l-0 k a-0 (ltk b-0 ks-0))))
      (send (enc t-prime k)))
    ((send (cat a-0 b-1))
      (recv
        (cat (enc t-0 l-1 k b-1 (ltk a-0 ks-1))
          (enc t-0 l-1 k a-0 (ltk b-1 ks-1))))
      (send (cat (enc a-0 t-0 k) (enc t-0 l-1 k a-0 (ltk b-1 ks-1))))))
  (label 11)
  (parent 5)
  (unrealized (3 1))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton kerberos
  (vars (t t-prime l t-0 l-0 text) (a b ks a-0 b-0 ks-0 name) (k skey))
  (defstrand init 4 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a b) (b a) (ks ks) (k k))
  (defstrand resp 2 (t t-0) (t-prime t-prime) (l l-0) (a a-0) (b b-0)
    (ks ks-0) (k k))
  (deflistener k)
  (precedes ((1 1) (0 1)) ((1 1) (3 0)) ((2 1) (0 3)) ((3 1) (2 0)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation encryption-test (added-listener k) (enc a-0 t-0 k) (2 0))
  (traces
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k)))
    ((recv (cat b a))
      (send (cat (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))))
    ((recv (cat (enc a-0 t-0 k) (enc t-0 l-0 k a-0 (ltk b-0 ks-0))))
      (send (enc t-prime k))) ((recv k) (send k)))
  (label 12)
  (parent 5)
  (unrealized (3 0))
  (comment "empty cohort"))

(defskeleton kerberos
  (vars (t t-prime l text) (a b ks name) (k skey))
  (defstrand init 4 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a a) (b b) (ks ks) (k k))
  (defstrand resp 2 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (precedes ((0 2) (2 0)) ((1 1) (0 1)) ((2 1) (0 3)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation nonce-test (contracted (b-0 b) (ks-0 ks) (l-0 l)) k (2 0)
    (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))
  (traces
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k)))
    ((recv (cat a b))
      (send (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks)))))
    ((recv (cat (enc a t k) (enc t l k a (ltk b ks))))
      (send (enc t-prime k))))
  (label 13)
  (parent 7)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b) (ks ks) (t t) (t-prime t-prime) (l l) (k k))))
  (origs (k (1 1))))

(defskeleton kerberos
  (vars (t t-prime l l-0 text) (a b ks b-0 ks-0 name) (k skey))
  (defstrand init 4 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a a) (b b) (ks ks) (k k))
  (defstrand resp 2 (t t) (t-prime t-prime) (l l-0) (a a) (b b-0)
    (ks ks-0) (k k))
  (defstrand init 3 (t t) (l l) (a a) (b b) (ks ks) (k k))
  (precedes ((1 1) (0 1)) ((1 1) (3 1)) ((2 1) (0 3)) ((3 2) (2 0)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation nonce-test
    (contracted (a-0 a) (t-0 t) (b-1 b) (ks-1 ks) (l-1 l)) k (3 1)
    (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))
  (traces
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k)))
    ((recv (cat a b))
      (send (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks)))))
    ((recv (cat (enc a t k) (enc t l-0 k a (ltk b-0 ks-0))))
      (send (enc t-prime k)))
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))))
  (label 14)
  (parent 8)
  (unrealized (2 0))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton kerberos
  (vars (t t-prime l l-0 text) (a b ks b-0 ks-0 name) (k skey))
  (defstrand init 4 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a a) (b b) (ks ks) (k k))
  (defstrand resp 2 (t t) (t-prime t-prime) (l l-0) (a b) (b b-0)
    (ks ks-0) (k k))
  (defstrand init 3 (t t) (l l) (a b) (b a) (ks ks) (k k))
  (precedes ((1 1) (0 1)) ((1 1) (3 1)) ((2 1) (0 3)) ((3 2) (2 0)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation nonce-test
    (contracted (a-0 b) (t-0 t) (b-1 a) (ks-1 ks) (l-1 l)) k (3 1)
    (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))
  (traces
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k)))
    ((recv (cat a b))
      (send (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks)))))
    ((recv (cat (enc b t k) (enc t l-0 k b (ltk b-0 ks-0))))
      (send (enc t-prime k)))
    ((send (cat b a))
      (recv (cat (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks))))
      (send (cat (enc b t k) (enc t l k b (ltk a ks))))))
  (label 15)
  (parent 8)
  (unrealized (2 0))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton kerberos
  (vars (t t-prime l text) (a b ks name) (k skey))
  (defstrand init 4 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a b) (b a) (ks ks) (k k))
  (defstrand resp 2 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (precedes ((0 2) (2 0)) ((1 1) (0 1)) ((2 1) (0 3)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation nonce-test (contracted (b-0 b) (ks-0 ks) (l-0 l)) k (2 0)
    (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))
  (traces
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k)))
    ((recv (cat b a))
      (send (cat (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))))
    ((recv (cat (enc a t k) (enc t l k a (ltk b ks))))
      (send (enc t-prime k))))
  (label 16)
  (parent 10)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b) (ks ks) (t t) (t-prime t-prime) (l l) (k k))))
  (origs (k (1 1))))

(defskeleton kerberos
  (vars (t t-prime l l-0 text) (a b ks b-0 ks-0 name) (k skey))
  (defstrand init 4 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a b) (b a) (ks ks) (k k))
  (defstrand resp 2 (t t) (t-prime t-prime) (l l-0) (a a) (b b-0)
    (ks ks-0) (k k))
  (defstrand init 3 (t t) (l l) (a a) (b b) (ks ks) (k k))
  (precedes ((1 1) (0 1)) ((1 1) (3 1)) ((2 1) (0 3)) ((3 2) (2 0)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation nonce-test
    (contracted (a-0 a) (t-0 t) (b-1 b) (ks-1 ks) (l-1 l)) k (3 1)
    (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))
  (traces
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k)))
    ((recv (cat b a))
      (send (cat (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))))
    ((recv (cat (enc a t k) (enc t l-0 k a (ltk b-0 ks-0))))
      (send (enc t-prime k)))
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))))
  (label 17)
  (parent 11)
  (unrealized (2 0))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton kerberos
  (vars (t t-prime l l-0 text) (a b ks b-0 ks-0 name) (k skey))
  (defstrand init 4 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a b) (b a) (ks ks) (k k))
  (defstrand resp 2 (t t) (t-prime t-prime) (l l-0) (a b) (b b-0)
    (ks ks-0) (k k))
  (defstrand init 3 (t t) (l l) (a b) (b a) (ks ks) (k k))
  (precedes ((1 1) (0 1)) ((1 1) (3 1)) ((2 1) (0 3)) ((3 2) (2 0)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation nonce-test
    (contracted (a-0 b) (t-0 t) (b-1 a) (ks-1 ks) (l-1 l)) k (3 1)
    (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))
  (traces
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k)))
    ((recv (cat b a))
      (send (cat (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))))
    ((recv (cat (enc b t k) (enc t l-0 k b (ltk b-0 ks-0))))
      (send (enc t-prime k)))
    ((send (cat b a))
      (recv (cat (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks))))
      (send (cat (enc b t k) (enc t l k b (ltk a ks))))))
  (label 18)
  (parent 11)
  (unrealized (2 0))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton kerberos
  (vars (t t-prime l text) (a b ks name) (k skey))
  (defstrand init 4 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a a) (b b) (ks ks) (k k))
  (defstrand resp 2 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand init 3 (t t) (l l) (a a) (b b) (ks ks) (k k))
  (precedes ((1 1) (0 1)) ((1 1) (3 1)) ((2 1) (0 3)) ((3 2) (2 0)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation nonce-test (contracted (b-0 b) (ks-0 ks) (l-0 l)) k (2 0)
    (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))
  (traces
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k)))
    ((recv (cat a b))
      (send (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks)))))
    ((recv (cat (enc a t k) (enc t l k a (ltk b ks))))
      (send (enc t-prime k)))
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))))
  (label 19)
  (parent 14)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b) (ks ks) (t t) (t-prime t-prime) (l l) (k k))))
  (origs (k (1 1))))

(defskeleton kerberos
  (vars (t t-prime l text) (a b ks name) (k skey))
  (defstrand init 4 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a a) (b b) (ks ks) (k k))
  (defstrand resp 2 (t t) (t-prime t-prime) (l l) (a b) (b a) (ks ks)
    (k k))
  (defstrand init 3 (t t) (l l) (a b) (b a) (ks ks) (k k))
  (precedes ((1 1) (0 1)) ((1 1) (3 1)) ((2 1) (0 3)) ((3 2) (2 0)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation nonce-test (contracted (b-0 a) (ks-0 ks) (l-0 l)) k (2 0)
    (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))
  (traces
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k)))
    ((recv (cat a b))
      (send (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks)))))
    ((recv (cat (enc b t k) (enc t l k b (ltk a ks))))
      (send (enc t-prime k)))
    ((send (cat b a))
      (recv (cat (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks))))
      (send (cat (enc b t k) (enc t l k b (ltk a ks))))))
  (label 20)
  (parent 15)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b) (ks ks) (t t) (t-prime t-prime) (l l) (k k))))
  (origs (k (1 1))))

(defskeleton kerberos
  (vars (t t-prime l text) (a b ks name) (k skey))
  (defstrand init 4 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a b) (b a) (ks ks) (k k))
  (defstrand resp 2 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand init 3 (t t) (l l) (a a) (b b) (ks ks) (k k))
  (precedes ((1 1) (0 1)) ((1 1) (3 1)) ((2 1) (0 3)) ((3 2) (2 0)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation nonce-test (contracted (b-0 b) (ks-0 ks) (l-0 l)) k (2 0)
    (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))
  (traces
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k)))
    ((recv (cat b a))
      (send (cat (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))))
    ((recv (cat (enc a t k) (enc t l k a (ltk b ks))))
      (send (enc t-prime k)))
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))))
  (label 21)
  (parent 17)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b) (ks ks) (t t) (t-prime t-prime) (l l) (k k))))
  (origs (k (1 1))))

(defskeleton kerberos
  (vars (t t-prime l text) (a b ks name) (k skey))
  (defstrand init 4 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a b) (b a) (ks ks) (k k))
  (defstrand resp 2 (t t) (t-prime t-prime) (l l) (a b) (b a) (ks ks)
    (k k))
  (defstrand init 3 (t t) (l l) (a b) (b a) (ks ks) (k k))
  (precedes ((1 1) (0 1)) ((1 1) (3 1)) ((2 1) (0 3)) ((3 2) (2 0)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation nonce-test (contracted (b-0 a) (ks-0 ks) (l-0 l)) k (2 0)
    (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))
  (traces
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k)))
    ((recv (cat b a))
      (send (cat (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))))
    ((recv (cat (enc b t k) (enc t l k b (ltk a ks))))
      (send (enc t-prime k)))
    ((send (cat b a))
      (recv (cat (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks))))
      (send (cat (enc b t k) (enc t l k b (ltk a ks))))))
  (label 22)
  (parent 18)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b) (ks ks) (t t) (t-prime t-prime) (l l) (k k))))
  (origs (k (1 1))))

(comment "Nothing left to do")

(defprotocol kerberos basic
  (defrole init
    (vars (a b ks name) (t t-prime l text) (k skey))
    (trace (send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k))))
  (defrole resp
    (vars (a b ks name) (t t-prime l text) (k skey))
    (trace (recv (cat (enc a t k) (enc t l k a (ltk b ks))))
      (send (enc t-prime k))))
  (defrole keyserver
    (vars (a b ks name) (t l text) (k skey))
    (trace (recv (cat a b))
      (send (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks)))))
    (uniq-orig k)))

(defskeleton kerberos
  (vars (t t-prime l text) (a b ks name) (k skey))
  (defstrand resp 2 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (non-orig (ltk a ks) (ltk b ks))
  (traces
    ((recv (cat (enc a t k) (enc t l k a (ltk b ks))))
      (send (enc t-prime k))))
  (label 23)
  (unrealized (0 0))
  (origs)
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton kerberos
  (vars (t t-prime l text) (a b ks name) (k skey))
  (defstrand resp 2 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a b) (b a) (ks ks) (k k))
  (precedes ((1 1) (0 0)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation encryption-test (added-strand keyserver 2)
    (enc t l k a (ltk b ks)) (0 0))
  (traces
    ((recv (cat (enc a t k) (enc t l k a (ltk b ks))))
      (send (enc t-prime k)))
    ((recv (cat b a))
      (send (cat (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks))))))
  (label 24)
  (parent 23)
  (unrealized (0 0))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton kerberos
  (vars (t t-prime l text) (a b ks name) (k skey))
  (defstrand resp 2 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a a) (b b) (ks ks) (k k))
  (precedes ((1 1) (0 0)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation encryption-test (added-strand keyserver 2)
    (enc t l k a (ltk b ks)) (0 0))
  (traces
    ((recv (cat (enc a t k) (enc t l k a (ltk b ks))))
      (send (enc t-prime k)))
    ((recv (cat a b))
      (send (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))))
  (label 25)
  (parent 23)
  (unrealized (0 0))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton kerberos
  (vars (t t-prime l l-0 text) (a b ks b-0 ks-0 name) (k skey))
  (defstrand resp 2 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a b) (b a) (ks ks) (k k))
  (defstrand init 3 (t t) (l l-0) (a a) (b b-0) (ks ks-0) (k k))
  (precedes ((1 1) (2 1)) ((2 2) (0 0)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation encryption-test (added-strand init 3) (enc a t k) (0 0))
  (traces
    ((recv (cat (enc a t k) (enc t l k a (ltk b ks))))
      (send (enc t-prime k)))
    ((recv (cat b a))
      (send (cat (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))))
    ((send (cat a b-0))
      (recv
        (cat (enc t l-0 k b-0 (ltk a ks-0))
          (enc t l-0 k a (ltk b-0 ks-0))))
      (send (cat (enc a t k) (enc t l-0 k a (ltk b-0 ks-0))))))
  (label 26)
  (parent 24)
  (unrealized (2 1))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton kerberos
  (vars (t t-prime l text) (a b ks name) (k skey))
  (defstrand resp 2 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a b) (b a) (ks ks) (k k))
  (deflistener k)
  (precedes ((1 1) (2 0)) ((2 1) (0 0)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation encryption-test (added-listener k) (enc a t k) (0 0))
  (traces
    ((recv (cat (enc a t k) (enc t l k a (ltk b ks))))
      (send (enc t-prime k)))
    ((recv (cat b a))
      (send (cat (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))))
    ((recv k) (send k)))
  (label 27)
  (parent 24)
  (unrealized (2 0))
  (comment "empty cohort"))

(defskeleton kerberos
  (vars (t t-prime l l-0 text) (a b ks b-0 ks-0 name) (k skey))
  (defstrand resp 2 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a a) (b b) (ks ks) (k k))
  (defstrand init 3 (t t) (l l-0) (a a) (b b-0) (ks ks-0) (k k))
  (precedes ((1 1) (2 1)) ((2 2) (0 0)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation encryption-test (added-strand init 3) (enc a t k) (0 0))
  (traces
    ((recv (cat (enc a t k) (enc t l k a (ltk b ks))))
      (send (enc t-prime k)))
    ((recv (cat a b))
      (send (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks)))))
    ((send (cat a b-0))
      (recv
        (cat (enc t l-0 k b-0 (ltk a ks-0))
          (enc t l-0 k a (ltk b-0 ks-0))))
      (send (cat (enc a t k) (enc t l-0 k a (ltk b-0 ks-0))))))
  (label 28)
  (parent 25)
  (unrealized (2 1))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton kerberos
  (vars (t t-prime l text) (a b ks name) (k skey))
  (defstrand resp 2 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a a) (b b) (ks ks) (k k))
  (deflistener k)
  (precedes ((1 1) (2 0)) ((2 1) (0 0)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation encryption-test (added-listener k) (enc a t k) (0 0))
  (traces
    ((recv (cat (enc a t k) (enc t l k a (ltk b ks))))
      (send (enc t-prime k)))
    ((recv (cat a b))
      (send (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks)))))
    ((recv k) (send k)))
  (label 29)
  (parent 25)
  (unrealized (2 0))
  (comment "empty cohort"))

(defskeleton kerberos
  (vars (t t-prime l text) (a b ks name) (k skey))
  (defstrand resp 2 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a b) (b a) (ks ks) (k k))
  (defstrand init 3 (t t) (l l) (a a) (b b) (ks ks) (k k))
  (precedes ((1 1) (2 1)) ((2 2) (0 0)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation nonce-test (contracted (b-0 b) (ks-0 ks) (l-0 l)) k (2 1)
    (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))
  (traces
    ((recv (cat (enc a t k) (enc t l k a (ltk b ks))))
      (send (enc t-prime k)))
    ((recv (cat b a))
      (send (cat (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))))
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))))
  (label 30)
  (parent 26)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b) (ks ks) (t t) (t-prime t-prime) (l l) (k k))))
  (origs (k (1 1))))

(defskeleton kerberos
  (vars (t t-prime l text) (a b ks name) (k skey))
  (defstrand resp 2 (t t) (t-prime t-prime) (l l) (a a) (b b) (ks ks)
    (k k))
  (defstrand keyserver 2 (t t) (l l) (a a) (b b) (ks ks) (k k))
  (defstrand init 3 (t t) (l l) (a a) (b b) (ks ks) (k k))
  (precedes ((1 1) (2 1)) ((2 2) (0 0)))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (operation nonce-test (contracted (b-0 b) (ks-0 ks) (l-0 l)) k (2 1)
    (enc t l k a (ltk b ks)) (enc t l k b (ltk a ks)))
  (traces
    ((recv (cat (enc a t k) (enc t l k a (ltk b ks))))
      (send (enc t-prime k)))
    ((recv (cat a b))
      (send (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks)))))
    ((send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))))
  (label 31)
  (parent 28)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b) (ks ks) (t t) (t-prime t-prime) (l l) (k k))))
  (origs (k (1 1))))

(comment "Nothing left to do")

(defprotocol kerberos basic
  (defrole init
    (vars (a b ks name) (t t-prime l text) (k skey))
    (trace (send (cat a b))
      (recv (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))
      (send (cat (enc a t k) (enc t l k a (ltk b ks))))
      (recv (enc t-prime k))))
  (defrole resp
    (vars (a b ks name) (t t-prime l text) (k skey))
    (trace (recv (cat (enc a t k) (enc t l k a (ltk b ks))))
      (send (enc t-prime k))))
  (defrole keyserver
    (vars (a b ks name) (t l text) (k skey))
    (trace (recv (cat a b))
      (send (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks)))))
    (uniq-orig k)))

(defskeleton kerberos
  (vars (t l text) (a b ks name) (k skey))
  (defstrand keyserver 2 (t t) (l l) (a a) (b b) (ks ks) (k k))
  (non-orig (ltk a ks) (ltk b ks))
  (uniq-orig k)
  (traces
    ((recv (cat a b))
      (send (cat (enc t l k b (ltk a ks)) (enc t l k a (ltk b ks))))))
  (label 32)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b) (ks ks) (t t) (l l) (k k))))
  (origs (k (0 1))))

(comment "Nothing left to do")

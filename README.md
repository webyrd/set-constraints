set-constraints
===============

Stolzenburg-style set constraints for miniKanren, based on:

Membership-Constraints and Complexity in Logic Programming with Sets
Frieder Stolzenburg
Frontiers of Combining Systems
1996
http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.54.8356&rep=rep1&type=pdf

and

An Algorithm for General Set Unification and Its Complexity
Frieder Stolzenburg
Journal of Automated Reasoning
vol. 22, no. 1, pp. 45-63
1999



Current minimal miniKanren interface (see `mk-set-tests.scm` for more elaborate examples):

Set constructors:

* empty-set (constant representing the empty set)

(run* (q) (set= empty-set empty-set))
=>
(_.0)

* make-set (construct a finite set of arbitrary (non-set) elements)

(run* (q) (set= (make-set 5 6) (make-set 6 5)))
=>
(_.0)

* ext-set (add elements to an existing set)

(run* (q) (set= (make-set 5) (ext-set empty-set 5)))
=>
(_.0)


miniKanren operators:

* set= (set unification, distinct from ==)

* elem (states that the first argument is an element of the second argument, which must be a set)

(run* (q) (elem q (make-set 5 6)))
=>
(5 6)

* not-elem (states that the first argument is not an element of the second argument, which must be a set)

(run* (q)
  (elem q (make-set 5 6))
  (not-elem q (make-set 5 6)))
=>
()


Current limitations:

* Sets cannot contain subsets.

* Sets must be length instantiated.

* Not using optimizations from the Stolzenburg papers that should cut down the number of answers generated.

* The second argument to elem and not-elem cannot be a variable.

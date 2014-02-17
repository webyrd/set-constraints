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



Current minimal miniKanren interface:

Set constructors:

* empty-set (constant representing the empty set)

* make-set (construct a finite set of arbitrary (non-set) elements)

* ext-set


miniKanren operators:

* == (unification, extended to sets)

* elem

* not-elem


Current limitations:

* A set can only be unified with another set:

Legal: (fresh (x) (== (make-set 3 4) (make-set x 3)))

Not legal: (fresh (A B x) (== (make-set 3 4) A) (== (make-set x 3) B) (== A B))

* Sets cannot contain subsets.

* Sets must be length instantiated.

* Not using optimizations from the Stolzenburg papers that should cut down the number of answers generated.
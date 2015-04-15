# sgu-solution
Solution to acm.sgu.ru

### #161 Intuitionistic Logic

Pay attention to that the results of the operations between elements in H consist a close group. Therefor, the results are also in H.

So we can pre-compute all elements of H (D = |H| < 100), which can be done by a DFS. The "<=" relationship can be computed by Floyd algorithm. For every unknown variables A, B, ..., Z, they can be assigned any elements in H. The possible combination is less than Sum(Di) <= 10^6, so that it can be done with DFS too.

The only thing left is a classical expression evaluation problem.

### #162 Pyramids

Given the lengths of six edges, to calculate the volume of the tetrahedron, usually two formulae are used:

1. Heron-type formula for the volume of a tetrahedron
2. Euler formula for the volume of a tetrahedron

Here I use the second one which can be derived with vector operations.

### #163 Wise King

A wise king who cannot count over three...

### #164 Airlines

Assume we divide the edges into two groups arbitrarily. We color (or `buy` in the problem) the first group with color A, and the second group with color B. Assume `NeighborB(a)` to be the neighbors of `a` connected by B-edges. `NeighborA(a)` is similarly defined.

If two vertices cannot reach each other in less than 3 steps via A-edges, the `neighborA(a)+{a}` must connect `neighborA(b)+{b}` by B-edges. So `neighborA(a)` is connected with `neighborA(b)` via B-edges directly, and a, b must be so too (consider both the situation where `(a,b)` is A or `(a,b)` is B).

So if group A doesn't meet the requirements, choose group B instead.

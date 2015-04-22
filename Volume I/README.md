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

### #165 Basketball

Normalize heights of players to |h| <= 50 mm. Consider the following cases:

1. `|x| <= 50`, `|y| <= 50`, then `|x+y| <= 100`;
2. `-50 <= x <= 0`, `0 <= y <= 50`, then `|x+y| <= 50`;
3. Two players in Case 2 can be regarded as one person.

Therefore, we only need make sure that the absolutions of sums of every continuous parts are smaller than 50.

### #166 Editor

Simple string processing problem. But pay attention to the pointer processes which may occur errors easily.

### #167 I-country

`f[i][j1][j2][dl][dr][k]`: the maximum oils could be get when occupying `k` squares in the first `i` rows and columns `j1` to `j2`. `dl` and `dr` mean the direction of the i-th row. `dl == 0` when the left side in (i+1)-th row could expand towards left or right; `dl == 1` when the left side in (i+1)-th row could expand towards only right. `dr == 0` when the right side of the next row could expand towards both left and right, while `dr == 1` when the right side of the next row could expand only towards left.

`f[][][][][][]` occupies totally 15*15*15*2*2*15^2*4 = 12150000 bytes = 11.6 MiB.

There are four possible situations:
```
(dl, dr) =     (0,0)       (0,1)      (1,0)        (1,1)

               ****         ****       ****       ********
             ********     ****           ****        ***
next line
(dl, dr) =     (x,x)       (x,1)      (1,x)        (1,1)
```

We can use `f[i][j1][j2][dl][dr][k]` to update the next row.

Record the path when updating the array `f`. As it's too memory-consuming to store `j1, j2, dl, dr` at the same time, we can use bit-compression to reduce the memory usage. Notice all the variables are smaller than 16, which means they can be represented by 4-bit integers. So we can use a 16-bit integer to represent these four integers: `(j1<<12) + (j2<<8) + (dl<<4) + dr`.

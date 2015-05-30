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

### #168 Matrix

Draw several examples, it's easy to find that the right-down side of `(x,y)` is a square, and the right-up side of `(x,y)` is a triangle-like shape. The minimal values of these two parts can be calculated in `O(N^2)` time separately with the following equations:

- `min_right_side[i][j] = min{ a[i][k], k >= j }`
- `min_right_up_corner[i][j] = min{ min_right_side[i][j], min_right_up_corner[i-1][j+1] }`
- `min_right_down_square[i][j] = min{ min_right_side[i][j],
   min_right_down_square[i+1][j] }`

The answer is `b[i][j] = min { min_right_up_corner[i][j], min_right_down_square[i+1][j]`

### #169 Numbers

We can list the equations from the description of the problem:
```
   n = (x[n-1]*x[n-2]*...*x[1]*x[0]) * t1
 n+1 = (x[n-1]*x[n-2]*...*x[1]*(x[0]+1)) * t2
```

Minus `n+1` and `n`:
```
   1 = (x[n-1]*...*x[0]) * (t2-t1) + (x[n-1]*..*x[2]*x[1]) * t2
     = (x[n-1]*...*x[1]) * (x[0]*(t2-t1) + t2)
```

 When `t2 = 0`, t1 has to be equal to -1 which is impossible, so
 ```
  x[n-1] = x[n-2] = ... = x[2] = x[1] = x[0]*(t2-t1) + t2 = 1
```

The equations become
```
   n = x[0] * t1
 n+1 = (x[0]+1) * t2
   1 = x[0]*(t2-t1) + t2
```

The solutions are limited:
```
 x[0] = 1 ==> t1 = n, t2 = (n+1)/2
      = 2 ==> t1 = n/2, t2 = (n+1)/3 ==> check whether (k+2)%3==0
      = 3 ==> t1 = n/3, t2 = (n+1)/4 ==> last two digits of (n+1) is 14 ==> impossible
      = 4 ==> t1 = n/4 ==> impossible
      = 5 ==> t1 = n/5, t2 = (n+1)/6 ==> check whether (k+5)%3==0
      = 6 ==> t1 = n/6, t2 = (n+1)/7 ==> last digit of (n+1) is 7, 111111%7==0 ==> check whether (k-1)%6==0
      = 7 ==> t1 = n/7, t2 = (n+1)/8 ==> last three digits of (n+1) is 118 ==> impossible
      = 8 ==> t1 = n/8 ==> impossible
```

### #170 Particles

Here is an example:
```
++--++++   ===>   -++-++++
           ===>   --++++++
```

The "change" is like moving operation. Every time we need to move a psi+ or psi- to the correct position. It's obvious that the i-th psi+ in the first string should be moved to the i-th psi+'s position in the second.

### #171 Sarov zones

Hint: Some students will not be invited to the olympiad and their weights will not be summarized.

The students with heavier weights choose the zones first. They will take part in the zone where `P > Q` and `P - Q` is minimal. The students who cannot find such zones can attend any zones (they make no contribution).

### #172 eXam

Use two colors to paint the vertices to make sure that each pair of adjacent nodes don't have the same color.

Easily solve it with Depth-First-Search. Notice: the graph may own several connected components.

### #173 Coins

The transformation X contains two steps:
- Cyclic left shift
- Turn over (totally several times) k-th coin if i-th coin and A[i] are both 1 (i = 1.. k-1)

The problem also provides us L conditions. Suppose the coins are ordinarily `U = [u1, u2, ..., uk]`, and finally become `V = [v1, v2, ..., vk]`. Without loss of generality, here we assume `k = 4`. The shift operation can be represented as a matrix
```
    [0 0 0 1]
S = |1 0 0 0|
    |0 1 0 0|
    [0 0 1 0]
```

The vector `US` represents U after shifting one bit left. Remember: **each addition as well as multiplication is followed by modulo 2**.

The second step in the transformation can be represented as a matrix too
```
    [1 0 0 a0]
A = |0 1 0 a1|
    |0 0 1 a2|
    [0 0 0  1]
```

Therefore, we have the equation `USA = V`. Then use Partitioned Matrix to extract `X = [a0 a1 a2]`. Partition U as `U = [u1 u2 ... | uk]`, V as `V = [v1 v2 ... | vk]`, S and A as follows
```
    [0 0 0 | 1]
    |1 0 0 | 0|
S = |0 1 0 | 0|
    |------+--|  
    [0 0 1 | 0]

    [1 0 0 | a0]
    |0 1 0 | a1|
A = |0 0 1 | a2|
    |------+---|
    [0 0 0 |  1]
```

Symbolize the equation as
`(Ua Ub) (S1 S2; S3 0) (I X; 0 1) = (Va Vb)`

Simplify it as
`Ua*(S1*X + S2) + (Ub*S3*X) = Vb`

It means that `[u2 u3 ... uk]X = vk - u1`

We know L equations like that, so we can use Gaussian elimination to solve X.

Now if we already know V, U can be obtained by `U = V*A^(-1)*S^(-1)`. It can be seen that `A^(-1) = A` and `S^(-1) = S^T`, so `U = V*A*S^T`. In this way, the initial coins can be solved backwards. However, as the Di can be as large as 10^6, we should use [2k-ary method](http://en.wikipedia.org/wiki/Exponentiation_by_squaring#2k-ary_method) (Brauer, 1939) to calculate `V*(A*S^T)^Di`.

### #174 Walls

Designing a good Hash function is not a easy thing. Just use `std::map` to store the point and its root (in its Union Set). Define `std::map<Point, Point> mpoint`. The first point means the hash key, while the second point means the root of the first point in its Union Set.

Each time, we check whether the two ends of the walls own the same root (namely whether they belong to the same Union Set). Then insert them into the same set if they don't have the same root.

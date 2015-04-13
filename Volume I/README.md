# sgu-solution
Solution to acm.sgu.ru

### #161 Intuitionistic Logic

Pay attention to that the results of the operations between elements in H consist a close group. Therefor, the results are also in H.

So we can pre-compute all elements of H (D = |H| < 100), which can be done by a DFS. The "<=" relationship can be computed by Floyd algorithm. For every unknown variables A, B, ..., Z, they can be assigned any elements in H. The possible combination is less than Sum(Di) <= 10^6, so that it can be done with DFS too.

The only thing left is a classical expression evaluation problem.

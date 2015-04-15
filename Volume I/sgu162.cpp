/* SGU ID:  #162
 * Type  :  Mathematics
 * Author:  Hangchen Yu
 * Date  :  04/14/2015
 */
#include <cstdio>
#include <cstring>
#include <cctype>
#include <algorithm>
#include <vector>
#include <queue>
#include <list>
#include <map>
#include <stack>
#include <set>
#include <utility>
#include <cmath>

using std::swap;
using std::find;

#define MAXN    101
#define MAXH    101

int main() {
    // let O(0,0) as point D
    double ab, ac, oa, bc, ob, oc;
    scanf("%lf%lf%lf%lf%lf%lf", &ab, &ac, &oa, &bc, &ob, &oc);

    // two useful equations
    // 1. Heron-type formula for the volume of a tetrahedron
    // 2. Euler formula for the volume of a tetrahedron
    // here the second is used

    const double A[3][3] = {
        { oa*oa,                  (oa*oa+ob*ob-ab*ab)/2, (oa*oa+oc*oc-ac*ac)/2 },
        { (oa*oa+ob*ob-ab*ab)/2,  ob*ob,                 (ob*ob+oc*oc-bc*bc)/2 },
        { (oa*oa+oc*oc-ac*ac)/2,  (ob*ob+oc*oc-bc*bc)/2, oc*oc                 }
    };

    // the answer is sqrt(det(A))/6
    double ans = A[0][0]*A[1][1]*A[2][2] + A[0][1]*A[1][2]*A[2][0] + A[0][2]*A[1][0]*A[2][1]
               - A[0][0]*A[1][2]*A[2][1] - A[0][1]*A[1][0]*A[2][2] - A[0][2]*A[1][1]*A[2][0];
    ans = sqrt(ans)/6;
    printf("%.4lf\n", ans);
}

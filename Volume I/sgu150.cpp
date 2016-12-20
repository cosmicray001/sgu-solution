/* SGU ID:  #150
 * Type  :  Analytic Geometry
 * Author:  Hangchen Yu
 * Date  :  03/07/2015
 */
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

const double ESP = 1e-8;
long         n;
short        step;

long count_inner(long x, double y1, double y2) {
    long p = floor(y1+ESP), q = floor(y2+ESP);
    if (y1 > y2) {
        p -= p >= y1-ESP;
        if (n > p - q + 1)
            return p - q + 1;
        else {
            printf("%ld %ld\n", x-(step<1), p-n+1);
            exit(0);
        }
    }
    else {
        q -= q >= y2-ESP;
        if (n > q - p + 1)
            return q - p + 1;
        else {
            printf("%ld %ld\n", x-(step<1), p+n-1);
            exit(0);
        }
    }
}
int main() {
    long x1, y1, x2, y2;
    scanf("%ld%ld%ld%ld%ld", &x1, &y1, &x2, &y2, &n);
    
    if (x1 == x2 || y1 == y2) {
        printf("no solution\n");
        return 0;
    }

    step = x1 < x2 ? 1:-1;
    double k = 1.0 * (y2-y1)/(x2-x1);
    double t1, t2;
    for (long i = x1; i != x2 && n > 0; i += step) {
        t1 = y1 * 1.0 + k * (i-x1);
        t2 = y1 * 1.0 + k * (i+step-x1);
        //count the number
        n -= count_inner(i, t1, t2);
    }
    printf("no solution\n");
    return 0;
}

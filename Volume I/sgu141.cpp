/* SGU ID:  #141
 * Type  :  Extended Euclidean Algorithm
 * Author:  Hangchen Yu
 * Date  :  02/20/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

long ext_gcd(long a, long b, long &x, long &y) {
    if (b == 0) {
        x = 1; y = 0;
        return a;
    }
    else {
        long gcd = ext_gcd(b, a%b, x, y);
        long t = x;
        x = y;
        y = t - a/b*y;
        return gcd;
    }
}

int main() {
    long x1, x2, p, k;
    scanf("%ld%ld%ld%ld", &x1, &x2, &p, &k);

    long p1_sub_n1, p2_sub_n2, p1, n1, p2, n2;
    long gcd = ext_gcd(x1, x2, p1_sub_n1, p2_sub_n2);
    if (p%gcd != 0)
        puts("NO");
    else {
        p1_sub_n1 *= p/gcd;
        p2_sub_n2 *= p/gcd;

        //abs(p1_sub_n1) + abs(p2_sub_n2) <= k
        bool flag = false;
        long t1, t2;
        for (long i = -40000; i <= 40000; i++) {
            t1 = p1_sub_n1 + x2/gcd*i;
            t2 = p2_sub_n2 - x1/gcd*i;
            if ((k+t1+t2)%2 == 0 && fabs(t1) + fabs(t2) <= k) {
                flag = true;
                break;
            }
        }
        if (!flag) {
            puts("NO");
            return 0;
        }

        //n1 >= max(0, -p1_sub_n1)
        n1 = std::max(0L, -t1);
        p1 = n1 + t1;
        n2 = (k-t1-t2)/2 - n1;
        p2 = n2 + t2;
        puts("YES");
        printf("%ld %ld %ld %ld\n", p1, n1, p2, n2);
    }

    return 0;
}

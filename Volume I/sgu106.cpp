/* SGU ID:  #106
 * Type  :  Number Theory
 * Author:  Hangchen Yu
 * Date  :  01/16/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>

long long extended_gcd(long long a, long long b, long long &x, long long &y) {
    if (b == 0) {
        x = 1; y = 0;
        return a;
    }
    long long gcd = extended_gcd(b, a%b, x, y);
    long long t = x;
    x = y;
    y = t - a/b*y;
    return gcd;
}

int main() {
    long long a, b, c, x1, x2, y1, y2;
    scanf("%lld%lld%lld%lld%lld%lld%lld", &a, &b, &c, &x1, &x2, &y1, &y2);

    if (x1 > x2 || y1 > y2) {
        printf("0\n");
        return 0;
    }

    long long t1, t2, ans;

    if (a == 0) {
        if (b == 0)
            ans = (c == 0)? (y2-y1+1)*(x2-x1+1): 0;             //a = 0, b = 0
        else {
            if (c%b == 0 && -c/b >= y1 && -c/b <= y2)           //a = 0, b != 0
                ans = x2 - x1 + 1;
            else
                ans = 0;
        }
    }
    else {
        if (b == 0) {                                           //a != 0, b = 0
            if (c%a == 0 && -c/a >= x1 && -c/a <= x2)
                ans = y2 - y1 + 1;
            else
                ans = 0;
        }
        if (a < 0) {
            a = -a;
            b = -b;
            c = -c;
        }

        long long x = 0, y = 0;
        long long gcd_ab;
        if (b > 0) {                                            //a > 0, b > 0
            t1 = (-a * x2 - c) / b;
            t2 = (-a * x1 - c) / b;
            gcd_ab = extended_gcd(a, b, x, y);
        }
        else {                                                  //a > 0, b < 0
            t2 = (-a * x2 - c) / b;
            t1 = (-a * x1 - c) / b;
            gcd_ab = extended_gcd(a, -b, x, y);
            y = -y;
        }
        y1 = std::max(y1, t1);
        y2 = std::min(y2, t2);
        if (y1 > y2 || c%gcd_ab != 0)
            ans = 0;
        else {
            a /= gcd_ab;
            b /= gcd_ab;
            c /= gcd_ab;
            x *= -c; y*= -c;                                    //one of the solutions
            long long y_min;
            y_min = y - ((y-y1)/a)*a;
            if (y_min < y1) y_min += a;
            long long y_max;
            y_max = y + ((y2-y)/a)*a;
            if (y_max > y2) y_max -= a;
            if (y_min > y_max)
                ans = 0;
            else
                ans = (y_max - y_min)/a + 1;
        }
    }

    printf("%lld\n", ans);

    return 0;
}

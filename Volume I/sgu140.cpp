/* SGU ID:  #140
 * Type  :  Euclidean Algorithm
 * Author:  Hangchen Yu
 * Date  :  02/19/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

long extended_gcd(long a, long b, long &x, long &y) {
    if (b == 0) {
        x = 1; y = 0;
        return a;
    }
    else {
        long gcd = extended_gcd(b, a%b, x, y);
        long t = x;
        x = y;
        y = t - a/b*y;
        return gcd;
    }
}

int main() {
    int n, p, bn;
    long a[100];
    scanf("%d%d%d", &n, &p, &bn);
    for (int i = 0; i < n; i++) {
        scanf("%ld", a+i);
        a[i] %= p;
    }

    //a0*x0 + a1*x1 = gcd(a0, a1) = b1
    //b1*y1 + a2*x2 = gcd(b1, a2) = b2
    //b2*y2 + a3*x3 = gcd(b2, a3) = b3
    //...
    //b(n-2)*y(n-2) + a(n-1)*x(n-1) = gcd(b(n-2), a(n-1)) = b(n-1)
    //b(n-1)*y(n-1) + p*x(n) = gcd(b(n-1), p)
    long b[n+1], x[n+1], y[n+1];
    b[0] = a[0];
    for (int i = 1; i < n; i++) {
        b[i] = extended_gcd(b[i-1], a[i], y[i-1], x[i]);
        //printf("gcd=%ld, a=%ld, b=%ld, x=%ld, y=%ld\n", b[i], b[i-1], a[i], y[i-1], x[i]);
    }

    //n==1
    b[n] = extended_gcd(b[n-1], p, y[n-1], x[n]);

    if (bn % b[n] != 0)
        printf("NO\n");
    else {
        x[0] = 1;
        y[n] = bn/b[n];
        int t = 1;
        for (int i = n; i >= 0; i--) {
            while (x[i] < 0) x[i] += p;
            while (y[i] < 0) y[i] += p;
            t = (t*y[i])%p;
            x[i] = (x[i]*t)%p;
            //printf("%ld %ld==>%d", x[i], t, i);
        }
        printf("YES\n%ld", x[0]);
        for (int i = 1; i < n; i++) printf(" %ld", x[i]);
        printf("\n");
    }

    return 0;
}

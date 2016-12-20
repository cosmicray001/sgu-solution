/* SGU ID:  #136
 * Type  :  Gaussian Elimination
 * Author:  Hangchen Yu
 * Date  :  02/14/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

int main() {
    int n;
    scanf("%d", &n);
    double x[n], y[n];
    for (int i = 0; i < n; i++)
        scanf("%lf%lf", &x[i], &y[i]);

    double ansx[n], ansy[n];
    if ((n&1) == 1) {
        //solution exists
        ansx[0] = ansy[0] = 0;
        for (int i = 0; i < n; i++)
            if ((i&1) == 0) {
                ansx[0] += x[i];
                ansy[0] += y[i];
            }
            else {
                ansx[0] -= x[i];
                ansy[0] -= y[i];
            }
        for (int i = 0; i < n-1; i++) {
            ansx[i+1] = x[i]*2 - ansx[i];
            ansy[i+1] = y[i]*2 - ansy[i];
        }

    }
    else {
        double totx = 0, toty = 0;
        for (int i = 0; i < n-1; i++)
            if ((i&1) == 0) {
                totx += x[i];
                toty += y[i];
            }
            else {
                totx -= x[i];
                toty -= y[i];
            }
        if (totx != x[n-1] || toty != y[n-1]) {
            printf("NO\n");
            return 0;
        }
        ansx[0] = totx - 3.14;
        ansy[0] = toty - 3.14;
    }

    for (int i = 0; i < n-1; i++) {
        ansx[i+1] = x[i]*2 - ansx[i];
        ansy[i+1] = y[i]*2 - ansy[i];
    }

    printf("YES\n");
    for (int i = 0; i < n; i++)
        printf("%.3lf %.3lf\n", ansx[i], ansy[i]);
    return 0;
}

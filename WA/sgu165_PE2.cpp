/* SGU ID:  #165
 * Type  :  Greedy
 * Author:  Hangchen Yu
 * Date  :  04/17/2015
 */
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cctype>
#include <algorithm>
#include <cmath>

using std::abs;

int main() {
    int n;
    scanf("%d", &n);
    long h[n];
    double he;
    for (int i = 0; i < n; i++) {
        scanf("%lf", &he);
        h[i] = long(round(he*1e6-2e6));
    }

    // Normalize heights of players to |h| <= 50 mm.
    // Case 1: |x| <= 50, |y| <= 50, then |x+y| <= 100;
    // Case 2: -50 <= x <= 0, 0 <= y <= 50, then |x+y| <= 50;
    // Case 3: Two players in Case 2 can be regarded as one person.

    bool flag[n];
    memset(flag, false, sizeof(flag));
    long sum = 0;
    int ans[n], t = 0;
    long absmax; int maxj;
    for (int i = 0; i < n; i++) {
        absmax = -1;
        for (int j = 0; j < n; j++) {
            if (!flag[j] && h[j]*sum <= 0)
                if (abs(h[j]) > absmax) {
                    maxj = j;
                    absmax = abs(h[j]);
                }
        }
        ans[t++] = maxj;
        sum += h[maxj];
        flag[maxj] = true;
        printf("%ld %d\n", h[maxj], maxj);
    }

    printf("yes\n");
    for (int i = 0; i < n-1; i++)
        printf("%d ", ans[i]+1);
    printf("%d\n", ans[n-1]+1);

    return 0;
}

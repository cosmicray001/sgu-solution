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
using std::sort;

#define MAXN 6001

long h[MAXN];

bool cmp(int a, int b) {
    return h[a] < h[b];
}

int main() {
    int n;
    scanf("%d", &n);
    int pos[n];
    double he;
    for (int i = 0; i < n; i++) {
        scanf("%lf", &he);
        h[i] = long(round(he*1e6-2e6));
        pos[i] = i;
    }

    // Normalize heights of players to |h| <= 50 mm.
    // Case 1: |x| <= 50, |y| <= 50, then |x+y| <= 100;
    // Case 2: -50 <= x <= 0, 0 <= y <= 50, then |x+y| <= 50;
    // Case 3: Two players in Case 2 can be regarded as one person.

    sort(pos, pos+n, cmp);
    long sum = 0;
    int ans[n], t = 0;
    int l = 0, r = n-1;
    for (; l <= r;) {
        if (sum <= 0) {
            sum += h[pos[r]];
            ans[t++] = pos[r--];
        }
        else {
            sum += h[pos[l]];
            ans[t++] = pos[l++];
        }
    }

    printf("yes\n");
    for (int i = 0; i < n-1; i++)
        printf("%d ", ans[i]+1);
    printf("%d\n", ans[n-1]+1);

    return 0;
}

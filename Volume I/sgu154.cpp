/* SGU ID:  #154
 * Type  :  Binary Search
 * Author:  Hangchen Yu
 * Date  :  03/05/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

const long long MAXN = 5e8 + 1;

int main() {
    long q;
    scanf("%ld", &q);

    long long left = 1, right = MAXN;
    long long mid = (left + right) >> 1;
    long long tot, t;
    while (left < right) {
        tot = 0;
        t = mid;
        while (t > 0) {
            tot += t/5;
            t /= 5;
        }
        if (tot >= q) right = mid;
        else left = mid + 1;
        mid = (left + right) >> 1;
    }

    tot = 0;
    t = mid;
    while (t > 0) {
        tot += t/5;
        t /= 5;
    }
    if (tot != q) printf("No solution\n");
    else printf("%lld\n", mid);
    return 0;
}

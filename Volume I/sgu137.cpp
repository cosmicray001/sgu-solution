/* SGU ID:  #137
 * Type  :  Construction
 * Author:  Hangchen Yu
 * Date  :  02/15/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

int main() {
    int n, k;
    scanf("%d%d", &n, &k);
    
    bool bj[n];
    int num, t;
    for (int shift = 1; shift < n; shift++) {
        memset(bj, false, sizeof(bj));
        num = 0;
        t = shift;
        while (t != 0 && t != shift-1 && !bj[t]) {
            bj[t] = true;
            num++;
            t = (t+shift)%n;
        }
        if (bj[n-1] && (k-num)%n == 0) break;
    }
    for (int i = 0; i < n-1; i++)
        printf("%d ", (k-num)/n + (bj[i]?1:0));
    printf("%d\n", (k-num)/n + (bj[n-1]?1:0));
    return 0;
}

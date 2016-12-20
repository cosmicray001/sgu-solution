/* SGU ID:  #140
 * Type  :  
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
    long n;
    scanf("%ld\n", &n);
    bool s[n];
    char c;
    for (long i = 0; i < n; i++) {
        scanf("%c", &c);
        s[i] = (c=='b');
    }

    bool bj[1<<20];
    long t;
    memset(bj, false, sizeof(bj));
    for (long i = 0; i < n; i++) {
        t = 1;
        for (int j = 1; j <= 19; j++) {
            if (i+j-1 >= n) break;
            t = (t<<1)|(s[i+j-1]?1:0);
            bj[t] = true;
        }
    }

    int ans[20], len = 0;
    for (long i = 2; i < (1<<20); i++)
        if (!bj[i]) {
            t = i;
            while (t > 1) {
                ans[len++] = t&1;
                t >>= 1;
            }
            break;
        }
    printf("%d\n", len);
    for (int i = len-1; i >= 0; i--)
        printf("%c", ans[i]==0?'a':'b');
    printf("\n");
    
    return 0;
}

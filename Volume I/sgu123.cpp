/* SGU ID:  #123
 * Type  :  Enumeration
 * Author:  Hangchen Yu
 * Date  :  01/31/2015
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
    long f[n+1], tot;
    f[0] = 0; f[1] = 1;
    if (n == 1) printf("1\n");
    else {
        tot = 1;
        for (int i = 2; i <= n; i++) {
            f[i] = f[i-1] + f[i-2];
            tot += f[i];
        }
        printf("%ld\n", tot);
    }

    return 0;
}

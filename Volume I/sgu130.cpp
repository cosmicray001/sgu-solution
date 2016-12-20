/* SGU ID:  #130
 * Type  :  Mathematics
 * Author:  Hangchen Yu
 * Date  :  02/06/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

int main() {
    int k;
    scanf("%d", &k);

    long long f[31];
    memset(f, 0, sizeof(f));
    f[0] = 1;
    for (int i = 1; i <= k; i++)
        for (int j = 0; j < i; j++)
            f[i] += f[j] * f[i-j-1];

    printf("%lld %d\n", f[k], k+1);
    return 0;
}

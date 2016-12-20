/* SGU ID:  #152
 * Type  :  Enumeration
 * Author:  Hangchen Yu
 * Date  :  03/08/2015
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
    long a[n];
    long sum = 0;
    for (int i = 0; i < n; i++) {
        scanf("%ld", a+i);
        sum += a[i];
        a[i] *= 100;
    }

    bool truncted[n];
    memset(truncted, false, sizeof(truncted));
    int ans_sum, ans[n], truncted_sum;
    for (int i = 0; i < n; i++) {
        truncted[i] = a[i] % sum != 0;
        ans[i] = a[i]/sum;
        ans_sum += ans[i];
        truncted_sum += truncted[i];
    }

    if (truncted_sum < 100 - ans_sum) {
        printf("No solution\n");
        return 0;
    }
    for (int i = 0; i < n && 100 - ans_sum > 0; i++)
        if (truncted[i]) {
            ans_sum++;
            ans[i]++;
        }

    printf("%d", ans[0]);
    for (int i = 1; i < n; i++)
        printf(" %d", ans[i]);
    printf("\n");
    
    return 0;
}

/* SGU ID:  #118
 * Type  :  Mathematics 
 * Author:  Hangchen Yu
 * Date  :  01/25/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

int main() {
    int k, n;
    scanf("%d", &k);

    long a[1001];
    long long root;
    while (k-- > 0) {
        scanf("%d", &n);
        for (int i = 1; i <= n; i++)
            scanf("%ld", &a[i]);
        root = 0;
        for (int i = n; i >= 1; i--)
            root = ((root + 1) * a[i]) % 9;
        if (root == 0 && a[1] != 0) printf("9\n");
        else printf("%lld\n", root);
    }

    return 0;
}

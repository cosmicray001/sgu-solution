/* SGU ID:  #160
 * Type  :  Dynamic Programming
 * Author:  Hangchen Yu
 * Date  :  03/16/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <queue>
#include <list>
#include <map>
#include <stack>
#include <set>
#include <utility>
#include <cmath>

int main() {
    int n, m;
    scanf("%d%d", &n, &m);
    int a[n], f[n][m];
    memset(f, -1, sizeof(f));

    for (int i = 0; i < n; i++)
        scanf("%d", a+i);
    f[0][a[0]%m] = 0;
    for (int i = 1; i < n; i++) {
        f[i][a[i]%m] = i;
        for (int j = 0; j < m; j++) {
            if (f[i-1][j] >= 0) f[i][j] = f[i-1][j];
            if (f[i-1][j] >= 0)
                f[i][(j*a[i])%m] = i;
        }
    }

    int k;
    for (int i = m-1; i >= 0; i--)
        if (f[n-1][i] >= 0) {
            k = i;
            break;
        }

    if (k == 0) {
        printf("1\n");
        return 0;
    }

    printf("%d\n", k);
    std::vector<int> ans;
    bool bj[n];
    int t = f[n-1][k];
    memset(bj, false, sizeof(bj));
    ans.push_back(a[t]);
    bj[t] = true;

    for (int i = n-2; i >= 0; i--)
        for (int j = 0; j < m; j++) {
            if (f[i][j] >= 0 && ((j*a[t])%m == k)) {
                k = j;
                t = f[i][j];
                if (!bj[t]) ans.push_back(a[t]);
                bj[t] = true;
                break;
            }
        }

    sort(ans.begin(), ans.end());
    printf("%d", ans[0]);
    for (int i = 1; i < ans.size(); i++)
        printf(" %d", ans[i]);
    printf("\n");

    return 0;
}

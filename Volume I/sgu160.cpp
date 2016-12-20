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
    int a[n], pre[m], index[m];
    memset(pre, -1, sizeof(pre));
    memset(index, -1, sizeof(index));
    for (int i = 0; i < n; i++)
        scanf("%d", a+i);

    for (int i = 0; i < n; i++) {
        if (index[a[i]%m] < 0)
            index[a[i]%m] = i;
        for (int j = 0; j < m; j++) {
            if (index[j] >= 0 && index[j] != i && index[(j*a[i])%m] < 0) {
                index[(j*a[i])%m] = i;
                pre[(j*a[i])%m] = j;
            }
        }
    }

    int k;
    for (int i = m-1; i >= 0; i--)
        if (index[i] >= 0) {
            k = i;
            break;
        }

    if (k == 0) {
        printf("1\n");
        return 0;
    }
    printf("%d\n", k);
    std::vector<int> ans;
    while (k >= 0) {
        ans.push_back(index[k]+1);
        k = pre[k];
    }
    //sort(ans.begin(), ans.end());
    printf("%d", ans[ans.size()-1]);
    for (int i = ans.size()-2; i >= 0; i--)
        printf(" %d", ans[i]);
    printf("\n");

    return 0;
}

/**
 * output the indexes (1, 2, ..., n) instead of the numbers (a1, a2, ..., an)!!!!!!
 */

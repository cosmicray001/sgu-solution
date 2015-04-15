/* SGU ID:  #164
 * Type  :  Mathematics, Graph Theory
 * Author:  Hangchen Yu
 * Date  :  04/14/2015
 */
#include <cstdio>
#include <cstring>
#include <cctype>
#include <algorithm>
#include <vector>
#include <queue>
#include <list>
#include <map>
#include <stack>
#include <set>
#include <utility>
#include <cmath>

using std::swap;
using std::find;

#define MAXN    210

/**
 * Assume we divide the edges into two groups. We color (or buy in
 * the problem) the first group with color A, and the second group
 * with color B.
 *
 * Assume NeighborB(a) to be the neighbors of a connected by B 
 * edges. NeighborA(a) is similar.
 *
 * If two vertices cannot reach each other in less than 3 steps 
 * via A-edges, the neighborA(a)+{a} must connect neighborA(b)+{b}
 * by B-edges. So neighborA(a) is connected with neighborA(b) via 
 * B-edges directly, and a, b must be so too (consider both the
 * situation where (a,b) is A or (a,b) is B).
 *
 * So if group A is not available, choose group B instead.
 */
int main() {
    int n, m;
    int g[MAXN][MAXN];
    memset(g, 0, sizeof(g));
    scanf("%d%d", &n, &m);
    int mid = (m+1)/2;
    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= n; j++) {
            scanf("%d", &g[i][j]);
            if (g[i][j] <= mid && g[i][j] > 0) g[i][j] = 1;
            else g[i][j] = -1;
        }
    
    if (n == 1) {
        printf("0\n");
        return 0;
    }

    for (int k = 1; k <= n; k++)
        for (int i = 1; i <= n; i++)
            for (int j = 1; j <= n; j++)
                if (g[i][k] > 0 && g[k][j] > 0 && (g[i][j] < 0 || g[i][j] > g[i][k] + g[k][j]))
                    g[i][j] = g[i][k] + g[k][j];

    bool flag = false;
    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= n; j++)
            if (g[i][j] < 0 || g[i][j] > 3) {
                flag = true;
                break;
            }
    if (flag) {
        printf("%d\n", m-mid);
        for (int i = mid+1; i < m; i++)
            printf("%d ", i);
        printf("%d\n", m);
    }
    else {
        printf("%d\n", mid);
        for (int i = 1; i < mid; i++)
            printf("%d ", i);
        printf("%d\n", mid);
    }

    return 0;
}

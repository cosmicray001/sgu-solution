/* SGU ID:  #172
 * Type  :  Graph, Two-color
 * Author:  Hangchen Yu
 * Date  :  04/27/2015
 */
#include <iostream>
#include <cstdlib>
#include <cstdio>
#include <cstring>
#include <cctype>
#include <algorithm>
#include <cassert>
#include <vector>
#include <queue>
#include <list>
#include <map>
#include <stack>
#include <set>
#include <utility>
#include <cmath>
#include <climits>

#define pb(x)   push_back(x)
#define fi      first
#define se      second

using namespace std;

#define MAXN    201

bool g[MAXN][MAXN];
int  color[MAXN];
int  n, m;

bool dfs(int u, int c) {
    color[u] = c;
    for (int i = 1; i <= n; i++)
        if (g[u][i]) {
            if (!color[i]) {
                if (!dfs(i, 3-c)) return false;
            }
            else if (color[i] == c)
                return false;
        }
    return true;
}

// use two colors to paint the vertices to make sure that each pair
// of adjacent nodes don't have the same color
int main() {
    scanf("%d%d", &n, &m);
    int a, b;
    memset(g, false, sizeof(g));
    for (int i = 0; i < m; i++) {
        scanf("%d%d", &a, &b);
        g[a][b] = g[b][a] = true;
    }

    memset(color, 0, sizeof(color));
    bool flag = true;
    for (int i = 1; i <= n; i++)
        if (!color[i])
            if (!dfs(i, 1)) {
                flag = false;
                break;
            }

    if (flag) {
        puts("yes");
        int tot = 0, ans[MAXN];
        for (int i = 1; i <= n; i++)
            if (color[i] == 1) ans[tot++] = i;
        printf("%d\n", tot);
        for (int i = 0; i < tot; i++)
            printf("%d%s", ans[i], (i==tot-1)?"\n":" ");
    }
    else puts("no");

    return 0;
}

/* SGU ID:  #145
 * Type  :  DFS + Dichotomy
 * Author:  Hangchen Yu
 * Date  :  02/24/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>
#include <queue>

#define MAXN 101
#define MAXK 501

int     g[MAXN][MAXN];
bool    visited[MAXN];
int     n, m, k;
int     xs, xe;

long    min_dis[MAXN][MAXN];
int     path_num;
long    mid;

bool    flag;
int     path_len;
int     path[MAXN];

void dfs(int now, long dis) {
    //count the road
    if (now == xe)
    {
        path_num++;
        return;
    }
    //#now is too far from the destination
    if (dis + min_dis[now][xe] > mid)
        return;

    for (int i = 1; i <= n; i++) {
        if (!visited[i] && g[now][i] >= 0 && dis + g[now][i] <= mid) {
            visited[i] = true;
            dfs(i, dis+g[now][i]);
            visited[i] = false;
        }
        if (path_num > k) return;
    }
}

void floyd() {
    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= n; j++)
            min_dis[i][j] = g[i][j];

    for (int k = 1; k <= n; k++) {
        for (int i = 1; i <= n; i++)
            for (int j = 1; j <= n; j++)
                if (min_dis[i][k] >= 0 && min_dis[k][j] >= 0 && (min_dis[i][j] < 0 || min_dis[i][j] > min_dis[i][k] + min_dis[k][j]))
                    min_dis[i][j] = min_dis[i][k] + min_dis[k][j];
            }
}

void find_path(int now, long dis) {
    if (now == xe) {
        if (dis == mid)
            flag = true;
        return;
    }
    if (dis + min_dis[now][xe] > mid)
        return;

    for (int i = 1; i <= n; i++) {
        if (!visited[i] && g[now][i] >= 0 && dis + g[now][i] <= mid) {
            visited[i] = true;
            path[path_len++] = i;
            find_path(i, dis+g[now][i]);
            if (flag) return;
            path_len--;
            visited[i] = false;
        }
    }
}

int main() {
    scanf("%d%d%d", &n, &m, &k);
    memset(g, -1, sizeof(g));
    int a, b, c;
    for (int i = 0; i < m; i++)
    {
        scanf("%d%d%d", &a, &b, &c);
        g[b][a] = g[a][b] = c;
    }
    scanf("%d%d", &xs, &xe);

    //shortest path, used for pruning
    floyd();
    
    //bidivide the length of the path
    long left = 1, right = 1000001;
    while (left < right) {
        mid = (left + right) >> 1;
        //find the number of the paths whose lengths are shorter than mid
        memset(visited, false, sizeof(visited));
        path_num = 0;
        visited[xs] = true;
        dfs(xs, 0);
        //check
        if (path_num < k)
            left = mid + 1;
        else
            right = mid;
    }
    mid = (left + right) >> 1;
    
    //find path
    flag = false;
    path_len = 0;
    memset(visited, false, sizeof(visited));
    visited[xs] = true;
    find_path(xs, 0);
    //print path
    printf("%ld %d\n%d", mid, path_len+1, xs);
    for (int i = 0; i < path_len; i++)
        printf(" %d", path[i]);
    printf("\n");
    
    return 0;
}

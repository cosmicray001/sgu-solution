/* SGU ID:  #134
 * Type  :  DFS
 * Author:  Hangchen Yu
 * Date  :  02/13/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

#define MAXN    16001

struct Edge {
    int u, v;
};

bool cmp(Edge a, Edge b) {
    return a.u < b.u;
}

bool bj[MAXN];
int n, m;
int start[MAXN];
std::vector<Edge> edge;
int tot[MAXN], max[MAXN];

void dfs(int now) {
    int t = start[now], next;
    tot[now] = 1;
    bj[now] = true;
    //check the children
    while (t < m && edge[t].u == now) {
        next = edge[t].v;
        if (!bj[next]) {
            dfs(next);
            tot[now] += tot[next];
            if (max[now] == 0 || tot[next] > max[now])
                max[now] = tot[next];
        }
        t++;
    }
    //check the parents
    if (max[now] == 0 || n - tot[now] > max[now])
        max[now] = n - tot[now];
}

int main() {
    Edge e1, e2;
    scanf("%d", &n);
    
    //n==1
    if (n == 1) {
        printf("0 1\n1\n");
        return 0;
    }
    
    for (int i = 1; i < n; i++) {
        scanf("%d%d", &e1.u, &e1.v);
        edge.push_back(e1);
        e2.u = e1.v; e2.v = e1.u;
        edge.push_back(e2);
    }

    //build link list
    m = (n-1) << 1;
    sort(edge.begin(), edge.end(), cmp);
    memset(start, -1, sizeof(start));
    for (int i = 0; i < m; i++)
        if (start[edge[i].u] < 0)
            start[edge[i].u] = i;

    //dfs from node 1
    memset(bj, false, sizeof(bj));
    memset(tot, 0, sizeof(tot));
    memset(max, 0, sizeof(max));
    dfs(1);
    
    int minnum = MAXN, nummin = 0;
    for (int i = 1; i <= n; i++)
        if (max[i] < minnum) minnum = max[i];
    for (int i = 1; i <= n; i++)
        if (minnum == max[i]) nummin++;
    printf("%d %d\n", minnum, nummin);
    for (int i = 1; i <= n; i++) {
        if (minnum == max[i]) {
            printf("%d", i);
            if (--nummin == 0) {
                printf("\n");
                break;
            }
            else
                printf(" ");
        }
    }

    return 0;
}

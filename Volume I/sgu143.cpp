/* SGU ID:  #143
 * Type  :  Tree Dynamic Programming
 * Author:  Hangchen Yu
 * Date  :  02/23/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

#define MAXN    16010

struct Edge {
    int u, v;
    int next;
};

Edge edges[MAXN<<1];
int  node[MAXN];
int  num_edge = 0;
long opt[MAXN];

void addEdge(int u, int v) {
    Edge e = {u, v, node[u]};
    edges[num_edge] = e;
    node[u] = num_edge++;
}

void dfs(int u, int father) {
    int v;
    for (int i = node[u]; i >= 0; i = edges[i].next) {
        v = edges[i].v;
        if (v != father) {
            dfs(v, u);
            if (opt[v] > 0)
                opt[u] += opt[v];
        }
    }
}

int main() {
    int n;
    scanf("%d", &n);
    for (int i = 1; i <= n; i++)
        scanf("%ld", &opt[i]);
    int u, v;
    memset(node, -1, sizeof(node));
    for (int i = 0; i < n - 1; i++) {
        scanf("%d%d", &u, &v);
        addEdge(u, v);
        addEdge(v, u);
    }

    dfs(1, 1);

    long best = -10000;
    for (int i = 1; i <= n; i++)
        best = std::max(best, opt[i]);
    printf("%ld\n", best);

    return 0;
}

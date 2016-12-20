/* SGU ID:  #156
 * Type  :  Graph Theory, Hamilton, Euler
 * Author:  Hangchen Yu
 * Date  :  03/14/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

const int  MAXN     = 10001;
const long MAXM     = 200001;

struct Edge {
    int     u, v;
    long    next;
};

int     n;
long    m, cnt;
Edge    edge[MAXM];
long    head[MAXM];
int     deg[MAXN];
bool    visited[MAXN];
int     father[MAXN];

void addEdge(int u, int v) {
    edge[++cnt].u = u;
    edge[cnt].v = v;
    edge[cnt].next = head[u];
    head[u] = cnt;
}

void combineCompleteGraph() {
    memset(visited, false, sizeof(visited));
    for (int i = 1; i <= n; i++)
        father[i] = i;

    int v;
    for (int i = 1; i <= n; i++)
        if (deg[i] > 2 && !visited[i])
            for (long j = head[i]; j != 0; j = edge[j].next) {
                v = edge[j].v;
                if (deg[v] > 2) {
                    father[v] = father[i];
                    visited[v] = true;
                }
            }
}

void EulerTour(int u, bool inside) {
    visited[u] = true;
    int v;
    for (long i = head[u]; i != 0; i = edge[i].next) {
        v = edge[i].v;
        if (!visited[v]) {
            if (!inside && father[u] == father[v]) {
                EulerTour(v, true);
            }
            if ((inside && father[u] != father[v]) || deg[u] == 2) {
                EulerTour(v, false);
            }
        }
    }
    printf("%d ", u);
}

int main() {
    scanf("%d%ld", &n, &m);
    int u, v;
    cnt = 0;
    memset(head, 0, sizeof(head));
    for (long i = 0; i < m; i++) {
        scanf("%d%d", &u, &v);
        addEdge(u, v);
        addEdge(v, u);
        deg[u]++; deg[v]++;
    }

    //unionSet
    combineCompleteGraph();
    
    //Euler Tour
    for (int i = 1; i <= n; i++)
        if (deg[i] & 1) {
            printf("-1\n");
            return 0;
        }
    memset(visited, false, sizeof(visited));
    EulerTour(1, true);
    printf("\n");
    return 0;
}

/*    +---------------+
 *    |               |
 *    u ----- a ----- b
 *    |       |       |
 *    x       y       z
 *    |       |       |
 *
 *    {u, a, b} is a full-connected graph. Regard this complete graph
 *    as a node, and search the Euler tour.
 */

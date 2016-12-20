/* SGU ID:  #149
 * Type  :  Tree Dynamic Programming + DFS
 * Author:  Hangchen Yu
 * Date  :  03/06/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

#define MAXN    10001

struct Edge {
    int v, next;
    long l;
};

int     n, m;
Edge    edge[MAXN<<1];
int     head[MAXN];
bool    visited[MAXN];
long    longest_1[MAXN];    //the largest distance in subtree
int     longest_1_id[MAXN]; //the root of the path
long    longest_2[MAXN];    //the sub-largest distance in subtree
int     longest_2_id[MAXN]; //the root of the path

void addEdge(int u, int v, long l) {
    edge[m].v = v;
    edge[m].l = l;
    edge[m].next = head[u];
    head[u] = m++;
}

void find_longest_path(int i, int father) {
    int t = head[i];
    int v;
    longest_1[i] = longest_2[i] = longest_1_id[i] = longest_2_id[i] = 0;
    while (t != 0) {
        if ((v = edge[t].v) != father) {
            find_longest_path(v, i);
            if (longest_1[v] + edge[t].l > longest_1[i]) {
                longest_2[i] = longest_1[i];
                longest_2_id[i] = longest_1_id[i];
                longest_1[i] = longest_1[v] + edge[t].l;
                longest_1_id[i] = v;
            }
            else if (longest_1[v] + edge[t].l > longest_2[i]) {
                longest_2[i] = longest_1[v] + edge[t].l;
                longest_2_id[i] = v;
            }
            else if (longest_2[v] != 0 && longest_2[v] + edge[t].l > longest_2[i]) {
                longest_2[i] = longest_2[v] + edge[t].l;
                longest_2_id[i] = v;
            }
        }
        t = edge[t].next;
    }
}

void calculate_longest(int i, int father, long len_father) {
    int t = head[i];
    int v;
    //update with father's longest path
    if (father != 0 && longest_1_id[father] != i) {
        if (longest_1[father] + len_father > longest_1[i]) {
            longest_2[i] = longest_1[i];
            longest_2_id[i] = longest_1_id[i];
            longest_1[i] = longest_1[father] + len_father;
            longest_1_id[i] = father;
        }
        else if (longest_1[father] + len_father > longest_2[i]) {
            longest_2[i] = longest_1[father] + len_father;
            longest_2_id[i] = father;
        }
    }
    //update with father's second longest path
    if (father != 0 && longest_1_id[i] != father && longest_2_id[father] != i) {
        if (longest_2[father] + len_father > longest_1[i]) {
            longest_2[i] = longest_1[i];
            longest_2_id[i] = longest_1_id[i];
            longest_1[i] = longest_2[father] + len_father;
            longest_1_id[i] = father;
        }
        else if (longest_2[father] + len_father > longest_2[i]) {
            longest_2[i] = longest_2[father] + len_father;
            longest_2_id[i] = father;
        }
    }
    while (t != 0) {
        if ((v = edge[t].v) != father)
            calculate_longest(v, i, edge[t].l);
        t = edge[t].next;
    }
}

int main() {
    m = 1;
    memset(head, 0, sizeof(head));
    scanf("%d", &n);
    int v; long l;
    for (int i = 2; i <= n; i++) {
        scanf("%d%ld", &v, &l);
        addEdge(i, v, l);
        addEdge(v, i, l);
    }

    find_longest_path(1, 0);
    calculate_longest(1, 0, 0);
    
    for (int i = 1; i <= n; i++)
        printf("%ld\n", longest_1[i]);
    
    return 0;
}

//keep the longest and second longest subtree routes

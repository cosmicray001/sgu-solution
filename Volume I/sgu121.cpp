/* SGU ID:  #121
 * Type  :  Graph Theory
 * Author:  Hangchen Yu
 * Date  :  01/28/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

#define MAXN 102

int edge[MAXN][MAXN];
int color[MAXN][MAXN];
bool visited[MAXN];

void dfs(int t, int c) {
    visited[t] = true;
    for (int i = 1; i <= edge[t][0]; i++)
	if (color[t][edge[t][i]] == 0) {
	    color[t][edge[t][i]] = c;
	    color[edge[t][i]][t] = c;
	    c = 3 - c;
	    //visited[t][edge[t][i]] = true;
	    //visited[edge[t][i]][t] = true;
	    dfs(edge[t][i], c);
	}
}

int main() {
    int n;
    memset(edge, false, sizeof(edge));
    memset(color, 0, sizeof(color));

    //input
    scanf("%d", &n);
    for (int i = 1; i <= n; i++) {
	while (1) {
	    scanf("%d", &edge[i][++edge[i][0]]);
	    if (edge[i][edge[i][0]] == 0) break;
	}
	edge[i][0]--;
    }
    
    //DFS, toggle the color when reaching a vertex
    //start from a vertex with odd degree
    //**there may be several subgraphs
    int start = 1;
    memset(visited, false, sizeof(visited));
    while (start != 0) {
	start = 0;
	for (int i = 1; i <= n; i++)
	    if (!visited[i] && edge[i][0]&1 == 1) {
		start = i;
		break;
	    }
	if (start == 0)
	    for (int i = 1; i <= n; i++)
		if (!visited[i]) {
		    start = i;
		    break;
		}
	if (start != 0) dfs(start, 1);
    }

    //print
    bool flag = true;
    int sum;
    for (int i = 1; i <= n; i++) {
	sum = 0;
	for (int j = 1; j <= edge[i][0]; j++)
	     sum += color[i][edge[i][j]];
	if (edge[i][0] > 1 && (sum == edge[i][0] || sum == edge[i][0] << 1)) {
	    flag = false;
	    break;
	}
    }

    if (!flag) {
	printf("No solution\n");
	return 0;
    }

    for (int i = 1; i <= n; i++) {
	for (int j = 1; j <= edge[i][0]; j++)
	    printf("%d ", color[i][edge[i][j]]);
	printf("0\n");
    }

    return 0;
}

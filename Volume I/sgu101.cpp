#include <cstdio>
#include <cstring>

void dfs(int &k, int now, int ans[], int g[][7], int degree[]) {
    if (degree[now] == 0)
	ans[k++] = now;
    else
	for (int i = 0; i <= 6; i++)
	    if (g[now][i] > 0) {
		g[now][i]--;
		g[i][now]--;
		degree[now]--;
		degree[i]--;
		dfs(k, i, ans, g, degree);
		ans[k++] = now;
	    }
}

int main() {
    int n, a[100], b[100];
    int g[7][7], degree[7];
    int k = 0, ans[100];

    memset(g, 0, sizeof(g));
    memset(degree, 0, sizeof(degree));
    scanf("%d", &n);
    for (int i = 0; i < n; i++) {
	scanf("%d%d", &a[i], &b[i]);
	g[a[i]][b[i]]++;
	g[b[i]][a[i]]++;
	degree[a[i]]++;
	degree[b[i]]++;
    }

    int start = a[0], odd_degree = 0;
    for (int i = 0; i <= 6; i++)
	if (degree[i] & 1 == 1) {
	    odd_degree++;
	    start = i;
	}
    if (odd_degree != 0 && odd_degree != 2)
	printf("No solution\n");
    else
	dfs(k, start, ans, g, degree);

    for (int i = 0; i <= k - 1; i++) printf("%d ", ans[i]);
    printf("\n");

    for (int i = 0; i < k - 1; i++)
	for (int j = 0; j < n; j++)
	    if (a[j] == ans[i] && b[j] == ans[i+1]) {
		printf("%d +\n", j+1);
		a[j] = -1;
		break;
	    }
	    else
	    if (a[j] == ans[i+1] && b[j] == ans[i]) {
		printf("%d -\n", j+1);
		a[j] = -1;
		break;
	    }

    return 0;
}

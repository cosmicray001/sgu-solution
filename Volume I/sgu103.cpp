/* SGU ID:  #103
 * Type  :  Shortest Path 
 * Author:  Hangchen Yu
 * Date  :  01/13/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>

#define MAXN 301
#define MAXD 100000

int g[MAXN][MAXN];
char color[MAXN];
int remainTime[MAXN];
int purpleTime[MAXN], blueTime[MAXN];
int source, destination, n, m;

int calDistance(int a, int b, int time) {
    if (g[a][b] == -1 || color[a] != color[b] && remainTime[a] == remainTime[b] && blueTime[a] == purpleTime[b] && purpleTime[a] == blueTime[b])
	return -1;

    char nowColorA, nowColorB;
    int remainA, remainB;
    int t;

    //for a
    if (time < remainTime[a]) {
	nowColorA = color[a];
	remainA = remainTime[a] - time;
    }
    else {
	t = (time - remainTime[a])%(purpleTime[a] + blueTime[a]);
	if (color[a] == 'B') {
	    if (t < purpleTime[a]) {
	       	nowColorA = 'P';
		remainA = purpleTime[a] - t;
	    }
	    else {
		nowColorA = 'B';
		remainA = purpleTime[a] + blueTime[a] - t;
	    }
	}
	else {
	    if (t < blueTime[a]) {
	       	nowColorA = 'B';
		remainA = blueTime[a] - t;
	    }
	    else {
		nowColorA = 'P';
		remainA = purpleTime[a] + blueTime[a] - t;
	    }
	}
    }

    //for b
    if (time < remainTime[b]) {
        nowColorB = color[b];
	remainB = remainTime[b] - time;
    }
    else {
	t = (time - remainTime[b])%(purpleTime[b] + blueTime[b]);
	if (color[b] == 'B') {
	    if (t < purpleTime[b]) {
	       	nowColorB = 'P';
		remainB = purpleTime[b] - t;
	    }
	    else {
		nowColorB = 'B';
		remainB = purpleTime[b] + blueTime[b] - t;
	    }
	}
	else {
	    if (t < blueTime[b]) {
	       	nowColorB = 'B';
		remainB = blueTime[b] - t;
	    }
	    else {
		nowColorB = 'P';
		remainB = purpleTime[b] + blueTime[b] - t;
	    }
	}
    }
    
    //distance
    if (nowColorA == nowColorB) return g[a][b];
    else {
	t = std::min(remainA, remainB);
	if (remainA == remainB) {
	    if (nowColorA == 'B') {
		t += std::min(purpleTime[a], blueTime[b]);
		if (purpleTime[a] == blueTime[b])
		    t += std::min(blueTime[a], purpleTime[b]);
	    }
	    else {
		t += std::min(blueTime[a], purpleTime[b]);
		if (purpleTime[b] == blueTime[a])
		    t += std::min(blueTime[b], purpleTime[a]);
	    }
	}
	return g[a][b] + t;
    }
}

bool dijkstra(long long &best, int &len, int path[]) {
    long long distance[MAXN];
    int previous[MAXN];
    bool included[MAXN];
    memset(distance, -1, sizeof(distance));
    distance[source] = 0;
    memset(included, false, sizeof(included));

    int k;
    long long minDis, dis;
    for (int i = 1; i <= n; i++) {
	minDis = MAXD;
	k = -1;
	for (int j = 1; j <= n; j++) {
	    if (!included[j] && distance[j] >= 0 && distance[j] < minDis)
	    {
		k = j;
		minDis = distance[j];
	    }
	}
	if (k == -1) break;
	included[k] = true;
	for (int j = 1; j <= n; j++) {
	    if (!included[j])
		dis = calDistance(k, j, distance[k]);
	    if (!included[j] && dis >= 0 && (distance[j] == -1 || distance[k] + dis < distance[j])) {
		distance[j] = distance[k] + dis;
		previous[j] = k;
	    }
	}
    }

    if (distance[destination] == -1)
	return false;

    len = 0;
    int now = destination;
    while (now != source) {
	path[len++] = now;
	now = previous[now];
    }
    path[len] = source;
    best = distance[destination];
    return true;
}

int main() {
    scanf("%d%d%d%d\n", &source, &destination, &n, &m);
    for (int i = 1; i <= n; i++) {
	scanf("%c%d%d%d\n", &color[i], &remainTime[i], &blueTime[i], &purpleTime[i]);
    }

    int a, b, c;
    memset(g, -1, sizeof(g));
    for (int i = 0; i < m; i++) {
	scanf("%d%d%d", &a, &b, &c);
	if (g[a][b] < 0 || g[a][b] > c) {
	    g[a][b] = c;
	    g[b][a] = c;
	}
    }

    long long best;
    int len, path[MAXN];
    if (!dijkstra(best, len, path))
	printf("0\n");
    else {
	printf("%lld\n", best);
	for (int i = len; i >= 1; i--)
	    printf("%d ", path[i]);
	printf("%d\n", path[0]);
    }
    
    return 0;
}

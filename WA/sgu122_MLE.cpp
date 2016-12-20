/* SGU ID:  #122
 * Type  :  Graph Theory (Hamilton)
 * Author:  Hangchen Yu
 * Date  :  01/30/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

#define MAXN  1005

struct Vertex {
    Vertex *next;
    int id;
    Vertex(int _id = 0, Vertex *_next = NULL) {
	id = _id;
	next = _next;
    }
};

bool g[MAXN][MAXN];
int edge[MAXN][MAXN];
int degree[MAXN];
int not_added[MAXN];
Vertex v[MAXN];
bool bj[MAXN];

class Path {
public:
    Vertex *head;
    Vertex *tail;
    int num;

    Path() {
	head = NULL;
	tail = NULL;
	num = 0;
    }

    bool extend_font() {
	int i = head->id;
	int j;
	for (int k = 1; k <= degree[i]; k++) {
	    j = edge[i][k];
	    if (!bj[j]) {
		num++;
		v[j].next = head;
		head = &v[j];
		bj[j] = true;
		for (int t = 1; t <= degree[j]; t++)
		    not_added[edge[j][t]]--;
		return true;
	    }
	}
	return false;
    }

    bool extend_end() {
	int i = tail->id;
	int j;
	for (int k = 1; k <= degree[i]; k++) {
	    j = edge[i][k];
	    if (!bj[j]) {
		num++;
		tail->next = &v[j];
		tail = &v[j];
		bj[j] = true;
		for (int t = 1; t <= degree[j]; t++)
		    not_added[edge[j][t]]--;
		return true;
	    }
	}
	return false;
    }

    void print() {
	Vertex *t = head;
	do {
	    printf("%d ", t->id);
	    t = t->next;
	} while (t != head);
	printf("%d\n", head->id);
    }
};

Path path;

int main() {
    int n;
    scanf("%d", &n);
    char r;
    memset(g, false, sizeof(g));
    memset(edge, 0, sizeof(edge));
    memset(degree, 0, sizeof(degree));
    memset(not_added, 0, sizeof(not_added));
    memset(bj, false, sizeof(bj));
    for (int i = 1; i <= n; i++) v[i].id = i;
    for (int i = 1; i <= n; i++) {
	while (1) {
    	    scanf("%d%c", &edge[i][++degree[i]], &r);
	    not_added[i]++;
	    g[i][edge[i][degree[i]]] = true;
	    if (r == '\n') break;
	}
	v[i].id = i;
    }

    path.head = &v[1];
    path.tail = &v[edge[1][1]];
    path.head->next = path.tail;
    path.num = 2;
    bj[path.head->id] = true;
    bj[path.tail->id] = true;
    for (int t = 1; t <= degree[1]; t++)
        not_added[edge[1][t]]--;
    for (int t = 1; t <= degree[path.tail->id]; t++)
        not_added[edge[path.tail->id][t]]--;

    Vertex *x, *y, *prev, *succ, *now;
    bool flag;
    while (path.num < n) {
        //get the longest path
	while (path.extend_font());
	while (path.extend_end());

	//check whether a loop
	flag = g[path.head->id][path.tail->id];

	//get a loop
	if (flag)
	    path.tail->next = path.head;
	else {
	    x = path.head;
	    y = x->next;
	    while (y != NULL) {
		if (g[x->id][path.tail->id] && g[path.head->id][y->id]) {
		    x->next = path.tail;
		    //invert from y to tail
		    prev = path.head;
		    now = y;
		    while (now != NULL) {
			succ = now->next;
			now->next = prev;
			prev = now;
			now = succ;
		    }
		    path.tail = y;
		    break;
		}
		x = y;
		y = x->next;
    	    }
	}
	
	if (path.num == n) continue;

	//get a longer path
	now = path.head;
	while (now != path.tail)
	    if (not_added[now->id] == 0)
		now = now->next;
	for (int i = 1; i <= degree[now->id]; i++)
	    if (!bj[edge[now->id][i]]) {
		succ = &v[edge[now->id][i]];
		break;
	    }
	path.head = now->next;
	now->next = succ;
	path.tail = succ;
    }

    path.print();
    return 0;
}

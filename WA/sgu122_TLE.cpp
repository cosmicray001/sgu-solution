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
#include <string>
#include <iostream>

#define MAXN  1002

struct Vertex {
    Vertex *next;
    int id;
    Vertex(int _id = 0, Vertex *_next = NULL) {
	id = _id;
	next = _next;
    }
};

bool g[MAXN][MAXN];
int not_added[MAXN];
Vertex v[MAXN];
bool bj[MAXN];
int n;

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
	for (int j = 1; j <= n; j++)
	    if (g[i][j] && !bj[j]) {
		num++;
		v[j].next = head;
		head = &v[j];
		bj[j] = true;
		for (int t = 1; t <= n; t++)
		    if (g[j][t]) not_added[t]--;
		return true;
	    }
	return false;
    }

    bool extend_end() {
	int i = tail->id;
	int j;
	for (int j = 1; j <= n; j++)
	    if (g[i][j] && !bj[j]) {
		num++;
		tail->next = &v[j];
		tail = &v[j];
		bj[j] = true;
		for (int t = 1; t <= n; t++)
		    if (g[j][t]) not_added[t]--;
		return true;
	    }
	return false;
    }

    void print() {
	Vertex *t = head;
	int i = 0, k;
	int ans[MAXN];
	do {
    	    if (t->id == 1) k = i;
	    ans[i++] = t->id;
	    t = t->next;
	} while (t != head);
	
	i = 0;
	while (i++ < n) {
	    printf("%d ", ans[k]);
	    k = (k+1)%n;
	}
	printf("1\n");
    }
};

Path path;

int main() {
    scanf("%d\n", &n);
    memset(g, false, sizeof(g));
    memset(not_added, 0, sizeof(not_added));
    memset(bj, false, sizeof(bj));
    for (int i = 1; i <= n; i++) v[i].id = i;
    std::string s;
    int m;
    for (int i = 1; i <= n; i++) {
	getline(std::cin, s);
	m = 0;
	for (int j = 0; j < s.size(); j++)
	    if (s[j] != ' ') m = m*10 + s[j] - '0';
	    else {
    		not_added[i]++;
		g[i][m] = true;
		m = 0;
	    }
	if (m != 0) {
	    not_added[i]++;
	    g[i][m] = true;
	    m = 0;
	}
    }

    path.head = &v[1];
    for (int i = 2; i <= n; i++)
	if (g[1][i]) {
	    path.tail = &v[i];
	    m = i;
	    break;
	}
    path.head->next = path.tail;
    path.num = 2;
    bj[path.head->id] = true;
    bj[path.tail->id] = true;
    for (int i = 1; i <= n; i++)
	if (g[1][i]) not_added[i]--;
    for (int i = 1; i <= n; i++)
        if (g[m][i]) not_added[i]--;

    Vertex *x, *y, *prev, *succ, *now;
    bool flag;
    while (path.num <= n) {
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
	
	if (path.num == n) break;

	//get a longer path
	now = path.head;
	while (now != path.tail)
	    if (not_added[now->id] == 0)
		now = now->next;
	for (int i = 1; i <= n; i++)
	    if (g[now->id][i] && !bj[i]) {
		succ = &v[i];
		bj[i] = true;
		break;
	    }
	path.head = now->next;
	now->next = succ;
	path.tail = succ;
    }

    path.print();
    return 0;
}

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
#include <cstdlib>
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

bool   g[MAXN][MAXN];
Vertex v[MAXN];
bool   bj[MAXN];
int    n;

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
    	for (int j = 2; j <= n; j++)
	        if (g[i][j] && !bj[j]) {
		        num++;
    		    v[j].next = head;
    	    	head = &v[j];
        		bj[j] = true;
	        	return true;
    	    }
	    return false;
    }

    bool extend_end() {
	    int i = tail->id;
	    for (int j = 2; j <= n; j++)
    	    if (g[i][j] && !bj[j]) {
        		num++;
	        	tail->next = &v[j];
    		    tail = &v[j];
    	    	bj[j] = true;
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
    memset(bj, false, sizeof(bj));
    for (int i = 1; i <= n; i++) v[i].id = i;
    char buffer[5001], *token;
    int m;
    for (int i = 1; i <= n; i++) {
        gets(buffer);
        token = strtok(buffer, " ");
        while (token != NULL) {
            m = atoi(token);
            g[i][m] = true;
            token = strtok(NULL, " ");
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
    bj[1] = true;
    bj[m] = true;

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
        		    //reverse from y to tail
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
	    for (int i = 2; i <= n; i++)
    	    if (!bj[i]) {
		        succ = &v[i];
		        bj[i] = true;
		        break;
	        }
	    now = path.head;
	    do {
	        if (g[succ->id][now->id]) break;
	        else now = now->next;
	    } while (now != path.head);
	    path.head = now->next;
	    now->next = succ;
	    path.tail = succ;
        path.num++;
    }

    path.print();
    return 0;
}

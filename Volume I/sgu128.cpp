/* SGU ID:  #128
 * Type  :  Segment Tree
 * Author:  Hangchen Yu
 * Date  :  02/04/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

#define SEGMENT pair<Point, Point>

using namespace std;

struct Point {
	int x, y;
	int id;
	int next1, next2;
	Point(int xx = 0, int yy = 0) {
		x = xx; y = yy;
		id = 0;
		next1 = next2 = -1;
	}
};

bool cmp1(Point p1, Point p2) {
	return p1.x < p2.x || (p1.x == p2.x && p1.y < p2.y);
}

bool cmp2(Point p1, Point p2) {
	return p1.y < p2.y || (p1.y == p2.y && p1.x < p2.x);
}

bool cmp3(SEGMENT s1, SEGMENT s2) {
   	if (s1.first.x < s2.first.x) return true;
	else return false;
}

bool cmp4(SEGMENT s1, SEGMENT s2) {
	if (s1.second.x < s2.second.x || s1.second.x == s2.second.x && s1.first.x < s2.first.x) return true;
    else return false;
}

struct Node {
	Node *left;
	Node *right;
	int l, r;
	int num;

	Node(int ll = 0, int rr = 0) {
		left = right = NULL;
		l = ll; r = rr;
		num = 0;
	}
};

void build_tree(Node *p) {
	p->num = 0;
	int l = p->l, r = p->r;
	if (l == r) return;
	p->left = new Node(l, (l+r)/2);
	p->right = new Node((l+r)/2+1, r);
	build_tree(p->left);
	build_tree(p->right);
}

void push_into_tree(Node *p, int &y) {
	p->num++;
	if (p->l == p->r) return;
	if (y <= (p->l + p->r)/2)
		push_into_tree(p->left, y);
	else
		push_into_tree(p->right, y);
}

void clear_from_tree(Node *p, int &y) {
	p->num--;
	if (p->l == p->r) return;
	if (y <= (p->l + p->r)/2)
		clear_from_tree(p->left, y);
	else
		clear_from_tree(p->right, y);
}

bool count_exist(Node *p, int l, int r) {
	if (l > r) return false;
	if (p->l == l && p->r == r) return (p->num != 0);
	if (r <= (p->l+p->r)/2)
		return count_exist(p->left, l, r);
	if (l > (p->l+p->r)/2)
		return count_exist(p->right, l, r);
	return count_exist(p->left, l, (p->l+p->r)/2) || count_exist(p->right, (p->l+p->r)/2+1, r);
}

int main() {
    int n;
    scanf("%d", &n);
	vector<Point> vertex;
	Point p;
	int YMAX = 0, YMIN = 20000;
	for (int i = 0; i < n; i++) {
		scanf("%d%d", &p.x, &p.y);
		p.x += 10000; p.y += 10000;
		p.id = i;
		if (p.y > YMAX) YMAX = p.y;
		if (p.y < YMIN) YMIN = p.y;
		vertex.push_back(p);
	}
	
    //odd number
    if (n & 1 == 1) {
        printf("0\n");
        return 0;
    }

	vector<SEGMENT > segment;
	SEGMENT seg;
	//build vertical segments
	sort(vertex.begin(), vertex.end(), cmp1);
	long long sum = 0;
	for (int i = 0; i < n; i+=2) {
		if (vertex[i].x == vertex[i+1].x) {
			vertex[i+1].next1 = vertex[i].id;
            vertex[i].next1 = vertex[i+1].id;
			seg.first = vertex[i];
			seg.second = vertex[i+1];
			segment.push_back(seg);
			sum += vertex[i+1].y - vertex[i].y;
		}
        else {
			printf("0\n");
			return 0;
		}
	}

    //check duplicated points
    //8
    //3 0
    //6 0
    //3 3
    //6 3
    //3 3
    //0 3
    //0 6
    //3 6
//    for (int i = 0; i < n - 1; i++)
//        if (vertex[i].x == vertex[i+1].x && vertex[i].y == vertex[i+1].y) {
//            printf("0\n");
//            return 0;
//        }

	//build horizontal segments
    vector<SEGMENT > buffer;    //for right-end sort
	sort(vertex.begin(), vertex.end(), cmp2);
	for (int i = 0; i < n; i+=2) {
		if (vertex[i].y == vertex[i+1].y) {
			vertex[i+1].next2 = vertex[i].id;
			vertex[i].next2 = vertex[i+1].id;
			seg.first = vertex[i];
			seg.second = vertex[i+1];
			segment.push_back(seg);
        	buffer.push_back(seg);
            sum += vertex[i+1].x - vertex[i].x;
		}
        else {
			printf("0\n");
			return 0;
		}
	}

	//check whether unique
	int no[n];
	bool bj[n];
	memset(bj, false, sizeof(bj));
	for (int i = 0; i < n; i++)
		no[vertex[i].id] = i;
	int t = 0;
	while (true) {
		bj[t] = true;
		if (!bj[vertex[no[t]].next1])
			t = vertex[no[t]].next1;
		else 
		if (!bj[vertex[no[t]].next2])
			t = vertex[no[t]].next2;
		else
			break;
	}
	for (int i = 0; i < n; i++)
		if (!bj[i]) {
			printf("0\n");
			return 0;
		}

	//sort the segments
	//segments with smaller x is in the front
	//segments with the same x: 
	//	left-end horizontal segment first
	//	vertical in the middle
	//	right-end horizontal at last (store it in a buffer)
	sort(segment.begin(), segment.end(), cmp3);

    //sort the right-end (leave first)
    sort(buffer.begin(), buffer.end(), cmp4);

	//check the crossing
	Node *root = new Node(YMIN, YMAX);
	build_tree(root);
	int t_buffer = 0;
	for (int i = 0; i < n; i++) {
		//insert left-end
		if (segment[i].first.y == segment[i].second.y) {
			push_into_tree(root, segment[i].first.y);
			continue;
		}
		//clear right-end
		while (t_buffer < buffer.size() && buffer[t_buffer].second.x <= segment[i].first.x) {
            clear_from_tree(root, buffer[t_buffer].second.y);
			t_buffer++;
		}

		//check vertical segment
		if (count_exist(root, segment[i].first.y+1, segment[i].second.y-1)) {
			printf("0\n");
			return 0;
		}
	}

    printf("%lld\n", sum);
    return 0;
}

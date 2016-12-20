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

#define SEGMENT pair<pair<int, int>, pair<int, int> >
using namespace std;

bool cmp1(pair<int, int> p1, pair<int, int> p2) {
	return p1.first < p2.first || p1.first == p2.first && p1.second < p2.second;
}

bool cmp2(pair<int, int> p1, pair<int, int> p2) {
	return p1.second < p2.second || p1.second == p2.second && p1.first < p2.first;
}

bool cmp3(SEGMENT s1, SEGMENT s2) {
	if (s1.first.first < s2.first.first) return true;
	if (s1.first.first > s2.first.first) return false;
	if (s1.first.second == s1.second.second) return true;
	return false;
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
	if (y <= (p->l + p->r)/2 && p->left != NULL)
		push_into_tree(p->left, y);
	else
		push_into_tree(p->right, y);
}

void clear_from_tree(Node *p, int &y) {
	p->num--;
	if (p->l == p->r) return;
	if (y <= (p->l + p->r)/2 && p->left != NULL)
		push_into_tree(p->left, y);
	else
		push_into_tree(p->right, y);
}

bool count_exist(Node *p, int l, int r) {
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
	vector<pair<int, int> > vertex;
	pair<int, int> p;
	int YMAX = 0, YMIN = 20000;
	for (int i = 0; i < n; i++) {
		scanf("%d%d", &p.first, &p.second);
		p.first += 10000; p.second += 10000;
		if (p.second > YMAX) YMAX = p.second;
		if (p.second < YMIN) YMIN = p.second;
		vertex.push_back(p);
	}
	
	vector<SEGMENT > segment;
	SEGMENT seg;
	//build vertical segments
	sort(vertex.begin(), vertex.end(), cmp1);
	long sum = 0;
	int num, t;
	for (int i = 0; i < n; i++) {
		t = i; num = 0;
		while (t < n && vertex[i].first == vertex[t].first) {
			num++;
			if ((num & 1) == 0) {
				seg.first = vertex[t-1];
				seg.second = vertex[t];
				segment.push_back(seg);
				sum += vertex[t].second - vertex[t-1].second;
			}
			t++;
		}
		i = t - 1;
		if ((num & 1) == 1) {
			printf("0\n");
			return 0;
		}
	}

	//build horizontal segments
	sort(vertex.begin(), vertex.end(), cmp2);
	for (int i = 0; i < n; i++) {
		t = i; num = 0;
		while (t < n && vertex[i].second == vertex[t].second) {
			num++;
			if ((num & 1) == 0) {
				seg.first = vertex[t-1];
				seg.second = vertex[t];
				segment.push_back(seg);
				sum += vertex[t].first - vertex[t-1].first;
			}
			t++;
		}
		i = t - 1;
		if ((num & 1) == 1) {
			printf("0\n");
			return 0;
		}
	}

	//sort the segments
	//segments with smaller x is in the front
	//segments with the same x: 
	//	left-end horizontal segment first
	//	vertical in the middle
	//	right-end horizontal at last (store it in a buffer)
	sort(segment.begin(), segment.end(), cmp3);

	//check the crossing
	Node *root = new Node(YMIN, YMAX);
	build_tree(root);
	vector<SEGMENT > buffer;
	int t_buffer = 0;
	for (int i = 0; i < n; i++) {
		//insert left-end
		if (segment[i].first.second == segment[i].second.second) {
			push_into_tree(root, segment[i].first.second);
			buffer.push_back(segment[i]);
			continue;
		}
		//clear right-end
		while (t_buffer < buffer.size() && buffer[t_buffer].second.first <= segment[i].first.first) {
			clear_from_tree(root, buffer[t_buffer].second.second);
			t_buffer++;
		}

		//check vertical segment
		if (count_exist(root, segment[i].first.second+1, segment[i].second.second-1)) {
			printf("0\n");
			return 0;
		}
	}

    printf("%ld\n", sum);
    return 0;
}

/* SGU ID:  #155
 * Type  :  Construction
 * Author:  Hangchen Yu
 * Date  :  03/13/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

const int   MAXNUM      = 30001;
const long  MAXN        = 50000;
const int   MAXLOGN     = 16;

struct Node {
    int  k, a;
    long id;
};

struct Leaf {
    long left, right, parent;
};


long n;
std::vector<Node> node;
int  f[MAXN][MAXLOGN];
long m[MAXN][MAXLOGN];
Leaf leaves[MAXN+1];

bool cmp(Node n1, Node n2) {
    return n1.k < n2.k;
}

void pre_RMQ() {
    memset(f, 0, sizeof(f));
    for (long i = 0; i < n; i++)
        for (int j = 0; j < MAXLOGN; j++)
            f[i][j] = MAXNUM;
    for(long i = 0; i < n; i++) {
        f[i][0] = node[i].a;
        m[i][0] = i;
    }
    for (long j = 1; j < MAXLOGN; j++)
        for (long i = 0; i < n; i++)
            if (i+(1<<j)-1 < n) {
                if (f[i][j-1] < f[i+(1<<(j-1))][j-1]) {
                    f[i][j] = f[i][j-1];
                    m[i][j] = m[i][j-1];
                }
                else {
                    f[i][j] = f[i+(1<<(j-1))][j-1];
                    m[i][j] = m[i+(1<<(j-1))][j-1];
                }
            }
}

long RMQ(long left, long right) {
    int k = log(right-left+1)/log(2);
    if (f[left][k] < f[right-(1<<k)+1][k])
        return m[left][k];
    else
        return m[right-(1<<k)+1][k];
}

void work(long left, long right, long father, bool left_or_right) {
    if (left > right) return;

    long mid = RMQ(left, right);
    leaves[node[mid].id].parent = father;
    leaves[node[mid].id].left = leaves[node[mid].id].right = 0;
    if (father != 0) {
        if (left_or_right)
            leaves[father].left = node[mid].id;
        else
            leaves[father].right = node[mid].id;
    }
    work(left, mid-1, node[mid].id, true);
    work(mid+1, right, node[mid].id, false);
}

int main() {
    scanf("%ld", &n);
    Node tmpNode;
    for (long i = 1; i <= n; i++) {
        scanf("%d%d", &tmpNode.k, &tmpNode.a);
        tmpNode.id = i;
        node.push_back(tmpNode);
    }
    sort(node.begin(), node.end(), cmp);
    pre_RMQ();
    work(0, n-1, 0, true);

    printf("YES\n");
    for (long i = 1; i <= n; i++)
        printf("%ld %ld %ld\n", leaves[i].parent, leaves[i].left, leaves[i].right);
    return 0;
}

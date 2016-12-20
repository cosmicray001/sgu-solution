/* SGU ID:  #155
 * Type  :  Construction
 * Author:  Hangchen Yu
 * Date  :  03/05/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

struct Node {
    int k, a;
    long id;
};

struct Leaf {
    long left, right, parent;
};

bool cmp(Node n1, Node n2) {
    return n1.a < n2.a;
}

int main() {
    long n;
    scanf("%ld", &n);
    std::vector<Node> node;
    Node tmpNode;
    for (long i = 1; i <= n; i++) {
        scanf("%d%d", &tmpNode.k, &tmpNode.a);
        tmpNode.id = i;
        node.push_back(tmpNode);
    }

    sort(node.begin(), node.end(), cmp);
    
    Leaf leaves[n+1];
    leaves[node[0].id].parent = 0;
    leaves[node[0].id].left = leaves[node[0].id].right = 0;
    for (long i = 1; i < n; i++) {
        leaves[node[i].id].parent = node[i-1].id;
        leaves[node[i].id].left = leaves[node[i].id].right = 0;
        if (node[i].k > node[i-1].k)
            leaves[node[i-1].id].right = node[i].id;
        else
            leaves[node[i-1].id].left = node[i].id;
    }

    printf("YES\n");
    for (long i = 1; i <= n; i++)
        printf("%ld %ld %ld\n", leaves[i].parent, leaves[i].left, leaves[i].right);
    return 0;
}

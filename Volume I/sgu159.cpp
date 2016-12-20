/* SGU ID:  #159
 * Type  :  Search
 * Author:  Hangchen Yu
 * Date  :  03/15/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <queue>
#include <list>
#include <map>
#include <stack>
#include <set>
#include <utility>
#include <cmath>

#define MAXLEN  2001

int b, n;

struct Number {
    short d[MAXLEN];
    bool operator < (const Number &a) const {
        for (int i = n; i > 0; i--) {
            if (a.d[i] > d[i]) return true;
            if (a.d[i] < d[i]) return false;
        }
        return true;
    }
};

Number num;
int cal[MAXLEN << 1];
std::vector<Number> ans;

bool square(int len) {
    for (int i = 1; i <= len; i++)
        cal[len] += num.d[i] * num.d[len-i+1];
    cal[len+1] = cal[len]/b;
    cal[len] %= b;
    if (cal[len] != num.d[len]) return false;
    else return true;
}

void dfs(int len, int left) {
    if (len == n+1) {
        if (num.d[n] != 0 || n == 1)
            ans.push_back(num);
        return;
    }
    for (int i = 0; i < b; i++) {
        num.d[len] = i;
        cal[len] = left;
        if (square(len)) dfs(len+1, cal[len+1]);
    }
}

int main() {
    scanf("%d%d", &b, &n);
    memset(num.d, 0, sizeof(num.d));
    memset(cal, 0, sizeof(cal));
    dfs(1, 0);
    sort(ans.begin(), ans.end());

    printf("%lu\n", ans.size());
    for (int i = 0; i < ans.size(); i++) {
        for (int j = n; j > 0; j--) {
            if (ans[i].d[j] < 10) printf("%d", ans[i].d[j]);
            else printf("%c", 'A'+ans[i].d[j]-10);
        }
        printf("\n");
    }
    return 0;
}

/*
 * The distribution of the solution is very sparse. Depth-First-Search
 * would be a good method. Suppose cal = num * num. Search from one d-
 * igit number, and each step (length==k) we add one digit on the left,
 * only need calculate cal[k] instead of cal[1], cal[2], ..., cal[k].
 */

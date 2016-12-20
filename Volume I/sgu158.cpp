/* SGU ID:  #158
 * Type  :  Enumeration + Queue
 * Author:  Hangchen Yu
 * Date  :  03/16/2015
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

int main() {
    int l, m, n;
    scanf("%d%d", &l, &m);
    int p[m];
    for (int i = 0; i < m; i++) scanf("%d", p+i);
    scanf("%d", &n);
    int d[n];
    d[0] = 0;
    for (int i = 1; i < n; i++) scanf("%d", d+i);

    double s, ans = 0;
    double max = -1, t;
    int pos;    //the nearest door
    for (s = 0; s <= l - d[n-1]; s += 0.5) {
        t = pos = 0;
        for (int i = 0; i < m; i++) {
            while (pos < n-1 && fabs(d[pos+1]+s-p[i]) < fabs(d[pos]+s-p[i]))
                pos++;
            t += fabs(d[pos]+s-p[i]);
        }
        if (t > max) {
            max = t;
            ans = s;
        }
    }

    printf("%.1lf %.1lf\n", ans, max);
    return 0;
}

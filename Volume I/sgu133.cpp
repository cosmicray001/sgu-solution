/* SGU ID:  #133
 * Type  :  Sort
 * Author:  Hangchen Yu
 * Date  :  02/09/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

typedef std::pair<long, long> segment;

bool cmp(segment a, segment b) {
    return a.first < b.first;
}

int main() {
    int n;
    scanf("%d", &n);
    std::vector<segment> seg;
    segment p;
    for (int i = 0; i < n; i++) {
        scanf("%ld%ld", &p.first, &p.second);
        seg.push_back(p);
    }
    sort(seg.begin(), seg.end(), cmp);

    int k = 0, num = 0;
    for (int i = 1; i < n; i++) {
        if (seg[i].second < seg[k].second)
            num++;
        else
            k = i;
    }

    printf("%d\n", num);
    return 0;
}

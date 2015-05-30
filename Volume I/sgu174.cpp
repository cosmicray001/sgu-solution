/* SGU ID:  #174
 * Type  :  UnionSet + Map
 * Author:  Hangchen Yu
 * Date  :  05/30/2015
 */
#include <iostream>
#include <cstdlib>
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <list>
#include <map>
#include <set>
#include <utility>
#include <cmath>
#include <climits>

using namespace std;

#define map_i(x,y) mpoint.insert(pair<Point, Point> (x,y))

typedef struct {
    long x, y;
} Point;

bool operator==(const Point &p1, const Point &p2) {
    return (p1.x == p2.x && p1.y == p2.y);
}

bool operator<(const Point &p1, const Point &p2) {
    return (p1.x < p2.x) || (p1.x == p2.x && p1.y < p2.y);
}

map<Point, Point> mpoint;

Point getfather(Point p) {
    map<Point, Point>::iterator it;
    it = mpoint.find(p);
    if (it->second == p) return p;
    mpoint[p] = getfather(it->second);
    return mpoint[p];
}

int main() {
    long n, ans = 0;
    Point p1, p2;
    map<Point, Point>::iterator it1, it2;
    
    scanf("%ld", &n);
    for (long i = 1; i <= n; i++) {
        scanf("%ld%ld%ld%ld", &p1.x, &p1.y, &p2.x, &p2.y);
        // if the length of wall is zero
        if (p1 == p2) {
            ans = i;
            break;
        }

        it1 = mpoint.find(p1);
        it2 = mpoint.find(p2);
        if (it1 == mpoint.end() && it2 != mpoint.end()) {
            Point tmp = getfather(p2);
            map_i(p1, tmp);
        }
        else if (it1 != mpoint.end() && it2 == mpoint.end()) {
            Point tmp = getfather(p1);
            map_i(p2, tmp);
        }
        else if (it1 == mpoint.end() && it2 == mpoint.end()) {
            map_i(p1, p2);
            map_i(p2, p2);
        }
        else {
            Point tmp1 = getfather(p1);
            Point tmp2 = getfather(p2);

            if (tmp1 == tmp2) {
                ans = i;
                break;
            }
            else {
                Point root = it1->second;
                mpoint[root] = tmp2;
                map_i(p1, tmp2);
                map_i(p2, tmp2);
            }
        }
    }

    printf("%ld\n", ans);

    return 0;
}

/* SGU ID:  #147
 * Type  :  Mathematics + Enumeration
 * Author:  Hangchen Yu
 * Date  :  03/05/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

struct Point {
    long x, y;
};

void swap(long &p, long &q) {
    long t = p;
    p = q; q = t;
}

int check_dis(Point p, Point center, long step) {
    long t = long(std::max(fabs(p.x-center.x), fabs(p.y-center.y)));
    if (t > step) return 1;
    else if (t < step) return -1;
    return 0;
}

bool check_inside(Point p1, Point p2, Point center, long step) {
    return (check_dis(p1, center, step)*check_dis(p2,center, step) <= 0);
}

int main() {
    long n;
    Point p1, p2, p3;
    scanf("%ld", &n);
    scanf("%ld%ld%ld%ld%ld%ld", &p1.x, &p1.y, &p2.x, &p2.y, &p3.x, &p3.y);

    if (fabs(p1.x-p2.x) < fabs(p1.y-p2.y)) {
        swap(p1.x, p1.y);
        swap(p2.x, p2.y);
        swap(p3.x, p3.y);
    }

    if (p1.x > p2.x) {
        swap(p1.x, p2.x);
        swap(p1.y, p2.y);
    }

    //now p1 is on the left, p2 is on the right
    Point p1_up, p1_down, p2_up, p2_down;
    p1_up = p1_down = p1;
    p2_up = p2_down = p2;

    long best;
    for (best = 1; best <= (p2.x-p1.x)/2; best++) {
        //left
        if (p1_up.y < n && p2.x - p1_up.x - 1 >= p1_up.y - p2.y + 1) p1_up.y++;
        else if (p2.x - p1_up.x == p1_up.y - p2.y) p1_up.y--;
        p1_up.x++;
        if (p1_down.y > 1 && p2.x - p1_down.x - 1 >= p2.y - p1_down.y + 1) p1_down.y--;
        else if (p2.x - p1_down.x == p2.y - p1_down.y) p1_down.y++;
        p1_down.x++;

        //right
        if (p2_up.y < n && p2_up.x - p1.x - 1 >= p2_up.y - p1.y + 1) p2_up.y++;
        else if (p2_up.x - p1.x == p2_up.y - p1.y) p2_up.y--;
        p2_up.x--;
        if (p2_down.y > 1 && p2_down.x - p1.x - 1 >= p1.y - p2_down.y) p2_down.y--;
        else if (p2_down.x - p1.x == p1.y - p2_down.y) p2_down.y++;
        p2_down.x--;

        //test
        //printf("p1_up: (%ld, %ld), p2_up: (%ld, %ld), p1_down: (%ld, %ld), p2_down: (%ld, %ld)\n", p1_up.x, p1_up.y, p2_up.x, p2_up.y, p1_down.x, p1_down.y, p2_down.x, p2_down.y);

        //check
        if (check_inside(p1_up, p1_down, p3, best) || check_inside(p2_up, p2_down, p3, best))
            break;
    }

    if (best >= (p2.x - p1.x)/2)
        printf("NO\n%ld\n", p2.x-p1.x-1);
    else {
        printf("YES\n");
        printf("%ld\n", best);
    }

    return 0;
}


/* Suppose deltaX (two kings position difference along X-axis) is
 * larger than deltaY. As the black and white king walks through 
 * the shortest way, they must walk one step towards each other 
 * along X-axis. So the boundary of their possible routes is a 
 * leaning rectangle.
 *
 * The possible positions of black-white king after k steps com-
 * pose a square obviously.
 *
 * Therefore, enumerate the points whose x-coordinates are small-
 * er than (x1 + x2)/2, and check whether the black-white king is
 * there after such number of steps.
 */

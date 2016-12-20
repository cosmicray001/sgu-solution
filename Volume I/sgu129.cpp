/* SGU ID:  #129
 * Type  :  Computational Geometry
 * Author:  Hangchen Yu
 * Date  :  02/05/2015
 */
#include <cstdio>
#include <algorithm>
#include <vector>
#include <cmath>

#define MAXXY   40000
#define EPS     1e-9

struct Point {
    double x, y;
    double angle;
    Point(double xx = 0, double yy = 0) {
        x = xx; y = yy;
    }
};

int n;
std::vector<Point> points;

bool cmp(Point a, Point b) {
    return a.angle < b.angle;
}

double distance(Point a, Point b) {
    return std::sqrt((a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y));
}

long long cross(Point a1, Point a2, Point b1, Point b2) {
    //(a2-a1)x(b2-b1)
    return (long long)((a2.x-a1.x)*(b2.y-b1.y) - (a2.y-a1.y)*(b2.x-b1.x));
}

bool onborder(Point a1, Point a2, Point b1, Point b2) {
    //(b1-a1)x(a2-a1), (a2-a1)x(b2-a1)
    long long t1 = cross(a1, b1, a1, a2);
    long long t2 = cross(a1, a2, a1, b2);
    return t1 == 0 && t2 == 0;
}

bool crossing(Point a1, Point a2, Point b1, Point b2) {
    //(b1-a1)x(a2-a1) * (a2-a1)x(b2-a1)
    long long t1 = cross(a1, b1, a1, a2);
    long long t2 = cross(a1, a2, a1, b2);
    //(a1-b1)x(b2-b1) * (b2-b1)x(a2-b1)
    long long t3 = cross(b1, a1, b1, b2);
    long long t4 = cross(b1, b2, b1, a2);
    return (t1 * t2 >= 0) && (t3 * t4 >= 0);
}

const Point inf(33456, 44567);
bool inPoly(Point p) {
    int num = 0, k;
    for (int i = 0; i < n; i++) {
        k = (i+1)%n;
        if (crossing(p, inf, points[i], points[k]))
            num++;
    }
    for (int i = 0; i < n; i++)
        if (points[i].x == p.x && points[i].y == p.y)
            return true;
    return (num&1)==1;
}

Point cross_point(Point a1, Point a2, Point b1, Point b2) {
    double u = cross(a1, b2, a1, a2);
    double v = cross(a1, b1, a1, a2);
    double w = u - v;
    Point tmp;
    tmp.x = (u * b1.x - v * b2.x) / w;
    tmp.y = (u * b1.y - v * b2.y) / w;
    return tmp;
}

int main() {
    scanf("%d", &n);
    Point p, minp;
    int mink = 0;
    minp.x = minp.y = MAXXY;
    for (int i = 0; i < n; i++) {
        scanf("%lf%lf", &p.x, &p.y);
        points.push_back(p);
        if (p.x < minp.x || (p.x == minp.x && p.y < minp.y)) {
            minp = p;
            mink = i;
        }
    }

    //construct the polygon
    //Graham Scan
    for (int i = 0; i < n; i++) {
        if (mink != i)
            points[i].angle = acos(-(points[i].y-minp.y)/distance(points[i], minp));
        else
            points[i].angle = -1;
    }
    sort(points.begin(), points.end(), cmp);

    //check the crossing
    int m;
    scanf("%d", &m);
    Point p1, p2, newp;
    Point cp[2];
    int num, k;
    double tot;
    for (int i = 0; i < m; i++) {
        scanf("%lf%lf%lf%lf", &p1.x, &p1.y, &p2.x, &p2.y);
        num = 0;
        tot = 0;
        for (int j = 0; j < n; j++) {
            k = (j+1)%n;
            if (onborder(points[j], points[k], p1, p2)) {
                num = -1;
                break;
            }
            if (crossing(points[j], points[k], p1, p2)) {
                newp = cross_point(points[j], points[k], p1, p2);
                if (num == 0 || (num == 1 && (fabs(newp.x-cp[0].x) > EPS || fabs(newp.y-cp[0].y) > EPS)))
                   cp[num++] = cross_point(points[j], points[k], p1, p2);
            }
        }

        if (num == 0) {
            if (inPoly(p1) && inPoly(p2))   //both p1 and p2 are in the polygon
                tot = distance(p1, p2);
        }
        else if (num == 1) {
            if (inPoly(p1) && fabs(distance(p1, cp[0])) > EPS)
                tot = distance(p1, cp[0]); //p1 is inside, p2 is outside
            else if (inPoly(p2) && fabs(distance(p2, cp[0])) > EPS)
                tot = distance(p2, cp[0]); //p1 is outside, p2 is inside
        }
        else if (num == 2)
            tot = distance(cp[0], cp[1]);  //has two crossing
        printf("%.2lf\n", tot);
    }

    return 0;
}

/* SGU ID:  #110
 * Type  :  Analytic Geometry 
 * Author:  Hangchen Yu
 * Date  :  01/22/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <cmath>

#define MAXN	50
#define EPS	1e-10
#define INF	1e10

struct Point {
    double x, y, z;
};

Point p1, p2, pnew, vect;

struct Sphere {
    Point c;
    double r;
} sphere[MAXN];

double distance(Point p1, Point p2) {
    return (p2.x-p1.x)*(p2.x-p1.x) + (p2.y-p1.y)*(p2.y-p1.y) + (p2.z-p1.z)*(p2.z-p1.z);
}

int main() {
    int n;
    scanf("%d", &n);
    for (int i = 0; i < n; i++)
	scanf("%lf%lf%lf%lf", &sphere[i].c.x, &sphere[i].c.y, &sphere[i].c.z, &sphere[i].r);
    scanf("%lf%lf%lf%lf%lf%lf", &p1.x, &p1.y, &p1.z, &p2.x, &p2.y, &p2.z);

    double mink, k1, k2, k;
    double a, b, c, delta;
    double innerproduct;
    int ans[11], mint;
    memset(ans, -1, sizeof(ans));

    for (int i = 0; i < 11; i++) {
	//find the insection
	mink = INF;
	mint = -1;
	for (int j = 0; j < n; j++) {
	    a = distance(p1, p2);
	    b = 2 * ((p2.x-p1.x)*(p1.x-sphere[j].c.x) + (p2.y-p1.y)*(p1.y-sphere[j].c.y) + (p2.z-p1.z)*(p1.z-sphere[j].c.z));
	    c = distance(p1, sphere[j].c) - sphere[j].r*sphere[j].r;
	    delta = b*b - 4*a*c;
	    if (delta < 0) continue;
	    
	    k1 = (-b+std::sqrt(delta))/(2*a);
	    k2 = (-b-std::sqrt(delta))/(2*a);
	    if (k1 < EPS && k2 < EPS) continue;
	    if (k1 < EPS || k2 > EPS && k2 < k1) k = k2;
	    else k = k1;

	    if (k < mink) {
		mink = k;
		mint = j;
	    }
	}

	//finish the reflection
	if (mint == -1) break;

	ans[i] = mint;
	pnew.x = (p2.x-p1.x)*mink + p1.x;
	pnew.y = (p2.y-p1.y)*mink + p1.y;
	pnew.z = (p2.z-p1.z)*mink + p1.z;

	//find reflect vector
	innerproduct = (p1.x-pnew.x)*(pnew.x-sphere[mint].c.x) + (p1.y-pnew.y)*(pnew.y-sphere[mint].c.y) + (p1.z-pnew.z)*(pnew.z-sphere[mint].c.z);
	vect.x = (pnew.x-p1.x) + 2*innerproduct/(sphere[mint].r*sphere[mint].r) * (pnew.x - sphere[mint].c.x);
	vect.y = (pnew.y-p1.y) + 2*innerproduct/(sphere[mint].r*sphere[mint].r) * (pnew.y - sphere[mint].c.y);
	vect.z = (pnew.z-p1.z) + 2*innerproduct/(sphere[mint].r*sphere[mint].r) * (pnew.z - sphere[mint].c.z);

	//new start and end points
	p1 = pnew;
	p2.x = vect.x + pnew.x;
	p2.y = vect.y + pnew.y;
	p2.z = vect.z + pnew.z;
    }

    for (int i = 0; i < 10; i++) {
	if (ans[i] == -1) break;
	printf("%d", ans[i]+1);
	if (ans[i+1] != -1) printf(" ");
    }
    if (ans[10] != -1) printf("etc.");
    if (ans[0] != -1) printf("\n");

    return 0;
}

/* SGU ID:  #228
 * Type  :  Analytic Geometry
 * Author:  Hangchen Yu
 * Date  :  01/27/2015
 * Same  :  #120
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

//#define PI  3.1415926535  <--this is wrong
//#define PI  acos(-1)      <--this is right
#define EPS 1e-10

struct Matrix {
    double a1, a2;
    double a3, a4;
    Matrix(double theta = 0) {
        a1 = cos(theta);
        a2 = sin(theta);
        a3 = -a2;
        a4 = a1;
    }
};

struct Vector {
    double x, y;
};

Vector v_minus_v(Vector v1, Vector v2) {
    Vector t;
    t.x = v1.x - v2.x;
    t.y = v1.y - v2.y;
    return t;
}

Vector v_plus_v(Vector v1, Vector v2) {
    Vector t;
    t.x = v1.x + v2.x;
    t.y = v1.y + v2.y;
    return t;
}

Matrix m_minus_m(Matrix m1, Matrix m2) {
    Matrix t;
    t.a1 = m1.a1 - m2.a1;
    t.a2 = m1.a2 - m2.a2;
    t.a3 = m1.a3 - m2.a3;
    t.a4 = m1.a4 - m2.a4;
    return t;
}

Vector m_multiply_v(Matrix m, Vector v) {
    Vector t;
    t.x = m.a1*v.x + m.a2*v.y;
    t.y = m.a3*v.x + m.a4*v.y;
    return t;
}

Matrix m_inversion(Matrix m) {
    double d = m.a1*m.a4 - m.a2*m.a3;
    Matrix t;
    t.a1 = m.a4/d;
    t.a2 = -m.a2/d;
    t.a3 = -m.a3/d;
    t.a4 = m.a1/d;
    return t;
}

int main() {
    const double PI = acos(-1);

    int n, n1, n2;
    scanf("%d%d%d", &n, &n1, &n2);
    Vector v1, v2;
    scanf("%lf%lf%lf%lf", &v1.x, &v1.y, &v2.x, &v2.y);
    if (n1 > n2) {
        int t = n1; n1 = n2; n2 = t;
        Vector tv = v1; v1 = v2; v2 = tv;
    }

    //calculate the center
    double theta = PI*2/n*(n2-n1);
    Matrix M(theta), I(0);
    Vector v0;
    v0 = m_multiply_v(m_inversion(m_minus_m(M, I)), v_minus_v(m_multiply_v(M, v1), v2));
//  printf("%lf %lf\n", v0.x, v0.y);

    //calculate the vertices
    double theta2 = PI*2/n;
    Matrix M2(theta2);
    Vector v[n+1];
    v[n1] = v1;
    int k = n1, pre;
    for (int i = 1; i < n; i++) {
        pre = k;
        if (++k > n) k = 1;
        v[k] = v_plus_v(v0, m_multiply_v(M2, v_minus_v(v[pre], v0)));
        //solve -0.000000
        if (fabs(v[k].x) < EPS) v[k].x = 0;
        if (fabs(v[k].y) < EPS) v[k].y = 0;
    }

    //print
    for (int i = 1; i <= n; i++)
        printf("%.6lf %.6lf\n", v[i].x, v[i].y);

    return 0;
}

/*
 * Suppose (x0,y0) is the center of the equiangular.
 * vector(x2-x0,y2-y0) = M * vector(x1-x0,y1-y0)
 * M is the rotation vector (clockwise), M =
 *    | cos(theta) sin(theta) |
 *    |-sin(theta) cos(theta) |
 * where theta = 360/N*(n2-n1).
 * Therefore, v2 - v0 = M * (v1 - v0)
 *            v0 = (M-I)^(-1) * (M*v1-v2)
 */

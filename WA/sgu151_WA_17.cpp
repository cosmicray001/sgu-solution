/* SGU ID:  #151
 * Type  :  Mathematics
 * Author:  Hangchen Yu
 * Date  :  03/06/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

const double ESP = 1e-8;

int main() {
    double c, b, m;
    scanf("%lf%lf%lf", &c, &b, &m);

    double t = (b*b + c*c)/2 - m*m;
    //the test data is wrong. Actually the area of the
    //triangle should not be zero
    if (t + ESP < 0) {
        printf("Mission impossible\n");
        return 0;
    }
    
    printf("%.5f %.5f\n", 0.0, 0.0);
    printf("%.5lf %.5lf\n", c, 0.0);
    double a = sqrt(fabs(t)) * 2;
    double cos_angleA = (b*b + c*c - a*a)/(2*b*c);
    double sin_angleA = sqrt(1-cos_angleA*cos_angleA);
    printf("%.5lf %.5lf\n", (fabs(b*cos_angleA)<=ESP)?0.0:b*cos_angleA, b*sin_angleA);

    return 0;
}

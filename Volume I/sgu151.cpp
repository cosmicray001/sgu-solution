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

    //the test data is wrong. Actually the area of the
    //triangle should not be zero
    if (fabs(b-c) > m*2 || b+c < m*2) {
        printf("Mission impossible\n");
        return 0;
    }
    
    printf("%.5f %.5f\n", 0.0, 0.0);
    printf("%.5lf %.5lf\n", c, 0.0);
    double x = (m*m*4 - b*b - c*c)/2/c;
    double y = sqrt(fabs(b*b - x*x));
    printf("%.5lf %.5lf\n", (fabs(x)<=ESP)?0.0:x, y);

    return 0;
}

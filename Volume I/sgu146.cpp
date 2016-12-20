/* SGU ID:  #146
 * Type  :  Mathematics
 * Author:  Hangchen Yu
 * Date  :  02/25/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

int main() {
    double ll;
    long l, n;
    long long t, v;
    scanf("%lf%ld", &ll, &n);
    l = round(ll*10000);

    long dis = 0, min = l;
    for (long i = 0; i < n; i++) {
        scanf("%lld%lld", &t, &v);
        v *= 10000;
        t %= l;
        v %= l;
        dis = (dis + (t*v)%l)%l;
        //there're some mistakes with the description
        //if (dis < min) min = dis;
        //if (l - dis < min) min = l - dis;
    }
    
    min = dis;
    if (l - dis < min) min = l - dis;

    printf("%.4f\n", double(min)/10000);
    return 0;
}

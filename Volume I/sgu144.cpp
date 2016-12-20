/* SGU ID:  #144
 * Type  :  Mathematics
 * Author:  Hangchen Yu
 * Date  :  02/23/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

int main() {
    int x, y;
    double z;
    scanf("%d%d%lf", &x, &y, &z);

    double len = (y-x)*60;
    printf("%.7lf\n", 1-(len-z)*(len-z)/(len*len));

    return 0;
}

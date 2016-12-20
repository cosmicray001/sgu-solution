/* SGU ID:  #126
 * Type  :  Mathematics
 * Author:  Hangchen Yu
 * Date  :  02/02/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

int main() {
    long a, b;
    scanf("%ld%ld", &a, &b);

    bool exist = true;
    int tot = 0;
    while (a != 0 && b != 0) {
        while ((a&1 == 0) && (b&1 == 0)) {
            a /= 2;
            b /= 2;
        }
        if (((a+b)&1) == 1 || tot > 100) {
            exist = false;
            break;
        }

        //pour the balls
        tot++;
        if (a == b) break;
        if (a > b) {
            a -= b;
            b <<= 1;
        }
        else {
            b -= a;
            a <<= 1;
        }
    }

    if (exist) printf("%d\n", tot);
    else printf("-1\n");
    return 0;
}

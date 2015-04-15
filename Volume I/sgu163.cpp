/* SGU ID:  #163
 * Type  :  Enumeration
 * Author:  Hangchen Yu
 * Date  :  04/15/2015
 */
#include <cstdio>
#include <cstring>
#include <cctype>
#include <algorithm>
#include <vector>
#include <queue>
#include <list>
#include <map>
#include <stack>
#include <set>
#include <utility>
#include <cmath>

int main() {
    int n, exp, t;
    scanf("%d%d", &n, &exp);
    int tot = 0;
    for (int i = 0; i < n; i++) {
        scanf("%d", &t);
        int tmp = 1;
        for (int j = 0; j < exp; j++)
            tmp *= t;
        if (tmp > 0) tot += tmp;
    }

    printf("%d\n", tot);

    return 0;
}

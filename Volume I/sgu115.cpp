/* SGU ID:  #115
 * Type  :  Enumeration
 * Author:  Hangchen Yu
 * Date  :  01/25/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

int main() {
    const int day[13] = {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    int n, m;
    scanf("%d%d", &n, &m);
    if (m > 12 || n > day[m])
        printf("Impossible\n");
    else {
        int tot = 0;
        for (int i = 1; i < m; i++)
            tot += day[i];
        tot += n;
        printf("%d\n", tot%7==0?7:tot%7);
    }

    return 0;
}

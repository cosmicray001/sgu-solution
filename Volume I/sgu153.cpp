/* SGU ID:  #153
 * Type  :  Game Theory
 * Author:  Hangchen Yu
 * Date  :  03/08/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

int main() {
    int k;
    scanf("%d", &k);

    long n;
    int  m, p[10], maxp, maxPeriod;
    bool win[100];
    int  t;

    while (k-- > 0) {
        scanf("%ld%d", &n, &m);
        p[0] = 1;
        maxp = 1;
        for (int i = 1; i <= m; i++) {
            scanf("%d", p+i);
            if (maxp < p[i])
                maxp = p[i];
        }

        //flag the status
        //the maximum period is two times the maxp
        memset(win, false, sizeof(win));
        win[0] = true;
        maxp = maxp << 1;
        maxPeriod = maxp << 1;
        t = 0;
        while (t <= maxPeriod) {
            for (int i = 0; i <= m; i++)
                if (t + p[i] <= maxPeriod)
                    win[t+p[i]] = win[t+p[i]] || (!win[t]);
            t++;
        }

        //enumerate the period
        bool flag;
        int period;
        for (int i = maxp; i >= 1; i--) {
            flag = true;
            for (int j = 1; j <= i; j++) {
                if (win[j] != win[j+i]) {
                    flag = false;
                    break;
                }
            }
            if (flag) {
                period = i;
                break;
            }
        }

        if (win[n%period==0?period:n%period]) printf("FIRST PLAYER MUST WIN\n");
        else printf("SECOND PLAYER MUST WIN\n");
    }
    return 0;
}

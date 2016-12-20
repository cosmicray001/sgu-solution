/* SGU ID:  #108
 * Type  :  Enumeration
 * Author:  Hangchen Yu
 * Date  :  01/18/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>

#define MAXK 5000
#define MAXMOD 64

int main() {
    long n, s[MAXK];
    int k, no[MAXK];
    scanf("%ld%d", &n, &k);
    for (int i = 0; i < k; i++) {
        scanf("%ld", &s[i]);
        no[i] = i;
    }

    long temps;
    int tempi;
    for (int i = 0; i < k-1; i++)
        for (int j = i+1; j < k; j++)
            if (s[i] > s[j]) {
                tempi = no[i]; no[i] = no[j]; no[j] = tempi;
                temps = s[i];  s[i] = s[j];   s[j] = temps;
            }

    bool bj[MAXMOD];
    memset(bj, false, sizeof(bj));
    long now = 1, t, j;
    long self[MAXK], pointer = 0, num = 0;

    for (long i = 1; i <= n; i++) {
        if (!bj[now]) {
            num++;
            while (pointer < k && s[pointer] == num)
                self[pointer++] = i;
        }
        t = i; j = now;
        while (t > 0) {
            j += t % 10;
            t /= 10;
        }
        bj[j%MAXMOD] = true;

        bj[now] = false;
        if (now < MAXMOD - 1)
            now++;
        else
            now = 0;
    }

    long ans[MAXK];
    for (int i = 0; i < k; i++)
        ans[no[i]] = self[i];

    printf("%ld\n", num);
    for (int i = 0; i < k-1; i++)
        printf("%ld ", ans[i]);
    printf("%ld\n", ans[k-1]);
    return 0;
}

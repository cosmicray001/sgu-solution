/* SGU ID:  #104
 * Type  :  Dynamic Programming
 * Author:  Hangchen Yu
 * Date  :  01/15/2015
 */
#include <cstdio>
#include <cstring>

#define MAXF    101
#define MAXV    101
#define INF     10000

int main() {
    int F, V;
    scanf("%d%d", &F, &V);

    int value[MAXF][MAXV];
    for (int i = 1; i <= F; i++)
        for (int j = 1; j <= V; j++)
            scanf("%d", &value[i][j]);

    // opt[i][j]: i flowers, and the last vase is j
    // opt[i][j] = max{opt[i-1][k] + value[i][j] | i-1<=k<j}
    int opt[MAXF][MAXV];
    for (int i = 0; i <= F; i++)
        for (int j = 0; j <= V; j++)
            opt[i][j] = -INF;
    for (int j = 1; j <= F; j++)
        opt[1][j] = value[1][j];

    for (int i = 2; i <= F; i++)
        for (int j = i; j <= V; j++)
            for (int k = i - 1; k < j; k++)
                if (opt[i-1][k] + value[i][j] > opt[i][j])
                    opt[i][j] = opt[i-1][k] + value[i][j];

    int best = -INF;
    int place[MAXF];
    for (int j = F; j <= V; j++)
        if (best < opt[F][j]) {
            best = opt[F][j];
            place[F] = j;
        }
    printf("%d\n", best);

    for (int i = F - 1; i >= 1; i--)
        for (int j = i; j < place[i+1]; j++)
            if (opt[i][j] + value[i+1][place[i+1]] == best) {
                best = opt[i][j];
                place[i] = j;
                break;
            }

    for (int i = 1; i < F; i++)
        printf("%d ", place[i]);
    printf("%d\n", place[F]);

    return 0;
}

/* SGU ID:  #167
 * Type  :  Dynamic Programming
 * Author:  Hangchen Yu
 * Date  :  04/22/2015
 */
#include <cstdio>
#include <cstring>
#include <cctype>
#include <algorithm>
#include <cmath>

using namespace std;

int  n, m, k;
int  a[16][16];
long f[16][16][16][2][2][226];
long pre[16][16][16][2][2][226];
long best = -1;
int  besti, bestj1, bestj2, bestdl, bestdr;

void update_next_row(int i, int j1, int j2, int dl, int dr, int s);

/**
 * f[i][j1][j2][dl][dr][k]: the maximum oils could be get when occupying k squares
 * in the first i rows and columns j1 to j2. `dl` and `dr` mean the direction of
 * the i-th row. `dl == 0` when the left side in (i+1)-th row could expand towards
 * left or right; `dl == 1` when the left side in (i+1)-th row could expand towards
 * only right. `dr == 0` when the right side of the next row could expand towards
 * both left and right, while `dr == 1` when the right side of the next row could
 * expand only towards left.
 *
 * f[][][][][][] occupies totally 15*15*15*2*2*15^2*4 = 12150000 bytes = 11.6 MiB.
 *
 * There are four possible situations:
 *
 * (dl, dr) =     (0,0)       (0,1)      (1,0)        (1,1)
 *
 *                ****         ****       ****       ********
 *              ********     ****           ****        ***
 * next line
 * (dl, dr) =     (x,x)       (x,1)      (1,x)        (1,1)
 *
 * Use f[i][j1][j2][dl][dr][k] to update the next row.
 *
 * Record the path when updating the array `f`. As it's too memory-consuming to
 * store `j1, j2, dl, dr` at the same time, we can use bit-compression to reduce
 * the memory usage. Notice all the variables are smaller than 16, which means
 * they can be represented by 4-bit integers. So we can use a 16-bit integer to
 * represent these four integers: `(j1<<12) + (j2<<8) + (dl<<4) + dr`.
 */
void dp() {
    memset(f, -1, sizeof(f));
    for (int i = 1; i <= n; i++)
        for (int j1 = 1; j1 <= m; j1++)
            for (int j2 = j1; j2 <= m; j2++)
                for (int dl = 0; dl < 2; dl++)
                    for (int dr = 0; dr < 2; dr++) {
                        f[i][j1][j2][dl][dr][j2-j1+1] = a[i][j2] - a[i][j1-1];
                        for (int s = j2-j1+1; s <= k; s++)
                            if (f[i][j1][j2][dl][dr][s] >= 0) {
                                update_next_row(i, j1, j2, dl, dr, s);
                                if (s == k && f[i][j1][j2][dl][dr][k] > best) {
                                    best = f[i][j1][j2][dl][dr][k];
                                    besti = i; bestj1 = j1; bestj2 = j2; bestdl = dl; bestdr = dr;
                                }
                            }
                    }
}

void update_next_row(int i, int j1, int j2, int dl, int dr, int s) {
    if (i == n) return;

    int next_dl, next_dr;
    for (int l = (dl==0?1:j1); l <= j2; l++)
        for (int r = max(j1, l); r <= (dr==0?m:j2); r++) {
            if (l == j1) next_dl = dl;
            else next_dl = (l<j1 ? 0 : 1);
            if (r == j2) next_dr = dr;
            else next_dr = (r>j2 ? 0 : 1);

            if (s+(r-l+1) <= k && f[i+1][l][r][next_dl][next_dr][s+(r-l+1)] < f[i][j1][j2][dl][dr][s] + a[i+1][r]-a[i+1][l-1]) {
                f[i+1][l][r][next_dl][next_dr][s+(r-l+1)] = f[i][j1][j2][dl][dr][s] + a[i+1][r]-a[i+1][l-1];
                pre[i+1][l][r][next_dl][next_dr][s+(r-l+1)] = (j1<<12) + (j2<<8) + (dl<<4) + dr;
            }
        }
}

void getPath(int i, int j1, int j2, int dl ,int dr, int s) {
    if (i == 0 || s == 0) return;
    for (int j = j1; j <= j2; j++)
        printf("%d %d\n", i, j);
    
    long t = pre[i][j1][j2][dl][dr][s];
    getPath(i-1, t>>12, (t>>8)%16, (t>>4)%16, t%16, s-(j2-j1+1));
}

int main() {
    scanf("%d%d%d", &n, &m, &k);
    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= m; j++) {
            scanf("%d", &a[i][j]);
            a[i][j] += a[i][j-1];
        }

    dp();
    printf("Oil : %ld\n", best);
    
    getPath(besti, bestj1, bestj2, bestdl, bestdr, k);
    
    return 0;
}

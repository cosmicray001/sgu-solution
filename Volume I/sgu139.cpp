/* SGU ID:  #139
 * Type  :  Mathematics
 * Author:  Hangchen Yu
 * Date  :  02/15/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

int main() {
    int a[16];
    int steps;
    for (int i = 0; i < 4; i++)
        for (int j = 0; j < 4; j++) {
            scanf("%d", &a[i*4+j]);
            if (a[i*4+j] == 0) {
                steps = 6-j-i;
                a[i*4+j] = 16;
            }
        }

    int sum_inv = 0;
    for (int i = 0; i < 15; i++)
        for (int j = i+1; j < 16; j++)
            if (a[i] > a[j]) sum_inv++;

    if ((steps&1) == (sum_inv&1))
        printf("YES\n");
    else
        printf("NO\n");

    return 0;
}

/* The inversion of the final state of the puzzle
 * is zero (0 is regarded as 16).
 *
 * When two up-down aligned squares are switched,
 * the inversion changes 7.
 * When two left-right aligned squares are switc-
 * hed, the inversion changes 1.
 *
 * Therefore, if the steps that needed to move 0
 * to the right-buttom place, should have the sa-
 * me parity as the initial inversion.
 *
 */

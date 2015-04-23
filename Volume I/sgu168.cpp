/* SGU ID:  #168
 * Type  :  Dynamic Programming
 * Author:  Hangchen Yu
 * Date  :  04/23/2015
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
#include <climits>

using namespace std;

int main() {
    int n, m;
    scanf("%d%d", &n, &m);

    int a[n+1][m+1];
    int min_right_side[n+1][m+1], min_right_up_corner[n+1][m+1], min_right_down_square[n+1][m+1];

    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= m; j++)
            scanf("%d", &a[i][j]);

    for (int i = 0; i <= n+1; i++)
        for (int j = 0; j <= m+1; j++) {
            min_right_side[i][j] = INT_MAX;
            min_right_up_corner[i][j] = INT_MAX;
            min_right_down_square[i][j] = INT_MAX;
        }

    // min_right_side[i][j] = min{ a[i][k], k >= j }
    // min_right_up_corner[i][j] = min { min_right_side[i][j], min_right_up_corner[i-1][j+1] }
    // min_right_down_square[i][j] = min { min_right_side[i][j], min_right_down_square[i+1][j] }
    // b[i][j] = min { min_right_up_corner[i][j], min_right_down_square[i+1][j] }

    for (int i = 1; i <= n; i++)
        for (int j = m; j >= 1; j--) {
            min_right_side[i][j] = min(min_right_side[i][j+1], a[i][j]);
            min_right_up_corner[i][j] = min(min_right_up_corner[i-1][j+1], min_right_side[i][j]);
        }
    for (int i = n; i >= 1; i--)
        for (int j = m; j >= 1; j--)
            min_right_down_square[i][j] = min(min_right_down_square[i+1][j], min_right_side[i][j]);

    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= m; j++) {
            printf("%d", min(min_right_up_corner[i-1][j+1], min_right_down_square[i][j]));
            printf(j==m?"\n":" ");
        }

    return 0;
}

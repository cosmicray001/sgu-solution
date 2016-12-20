/* SGU ID:  #124
 * Type  :  Computational Geometry
 * Author:  Hangchen Yu
 * Date  :  01/31/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

int main() {
    int n;
    scanf("%d", &n);
    int x1[n], y1[n], x2[n], y2[n];
    int x, y;
    for (int i = 0; i < n; i++)
        scanf("%d%d%d%d", &x1[i], &y1[i], &x2[i], &y2[i]);
    scanf("%d%d", &x, &y);

    bool flag = false;

    //whether on the border
    for (int i = 0; i < n; i++) {
        if (x1[i] == x2[i] && x1[i] == x && (y1[i]-y)*(y-y2[i]) >= 0) {
            flag = true;
            break;
        }
        if (y1[i] == y2[i] && y1[i] == y && (x1[i]-x)*(x-x2[i]) >= 0) {
            flag = true;
            break;
        }
    }

    if (flag) {
        printf("BORDER\n");
        return 0;
    }

    //whether inside or outside
    //draw a radial towards the left or the right side
    //check the crossing numbers
    int tot = 0;
    for (int i = 0; i < n; i++) {
        if (y1[i] == y2[i]) continue;               //ignore the horizontal
        if (x1[i] <= x && x2[i] <= x) continue;     //draw towards the right
        if (y1[i] <= y && y < y2[i] || y2[i] <= y && y < y1[i]) tot++;
    }

    if ((tot&1) == 1) printf("INSIDE\n");
    else printf("OUTSIDE\n");
    
    return 0;
}

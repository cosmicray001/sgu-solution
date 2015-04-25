/* SGU ID:  #169
 * Type  :  Mathematics
 * Author:  Hangchen Yu
 * Date  :  04/23/2015
 */
#include <iostream>
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

/**
 *   n = (x[n-1]*x[n-2]*...*x[1]*x[0]) * t1
 * n+1 = (x[n-1]*x[n-2]*...*x[1]*(x[0]+1)) * t2
 *
 * Minus (n+1) and (n)
 *   1 = (x[n-1]*...*x[0]) * (t2-t1) + (x[n-1]*..*x[2]*x[1]) * t2
 *     = (x[n-1]*...*x[1]) * (x[0]*(t2-t1) + t2)
 *
 * When t2 = 0, t1 has to be equal to -1 which is impossible, so
 *     x[n-1] = x[n-2] = ... = x[2] = x[1] = x[0]*(t2-t1) + t2 = 1
 *
 * The equations become
 *   n = x[0] * t1
 * n+1 = (x[0]+1) * t2
 *   1 = x[0]*(t2-t1) + t2
 *
 * x[0] = 1 ==> t1 = n, t2 = (n+1)/2
 *      = 2 ==> t1 = n/2, t2 = (n+1)/3 ==> check whether (k+2)%3==0
 *      = 3 ==> t1 = n/3, t2 = (n+1)/4 ==> last two digits of (n+1) is 14 ==> impossible
 *      = 4 ==> t1 = n/4 ==> impossible
 *      = 5 ==> t1 = n/5, t2 = (n+1)/6 ==> check whether (k+5)%3==0
 *      = 6 ==> t1 = n/6, t2 = (n+1)/7 ==> last digit of (n+1) is 7, 111111%7==0 ==> check whether (k-1)%6==0
 *      = 7 ==> t1 = n/7, t2 = (n+1)/8 ==> last three digits of (n+1) is 118 ==> impossible
 *      = 8 ==> t1 = n/8 ==> impossible
 */
int main() {
    long k;
    scanf("%ld", &k);

    if (k == 1) {
        printf("8\n");
        return 0;
    }

    int tot = 1;                //1
    if ((k+2)%3 == 0) tot++;    //2
    if ((k+5)%3 == 0) tot++;    //5
    if ((k-1)%6 == 0) tot++;    //6
    printf("%d\n", tot);

    return 0;
}

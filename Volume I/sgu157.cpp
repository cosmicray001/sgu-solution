/* SGU ID:  #157
 * Type  :  LookUpTable
 * Author:  Hangchen Yu
 * Date  :  03/15/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <queue>
#include <list>
#include <map>
#include <stack>
#include <set>
#include <utility>
#include <cmath>

int n;
int space;      //the position of space
int f[14];
long long total = 0;

void solve() {
    int t = space;
    total++;
    for (int i = 1; i <= n; i++)
        if (i != space && f[i-1] == f[i] - 1) {
            f[space] = f[i];
            f[i] = n;
            space = i;
            solve();
            space = t;
            f[i] = f[space];
            f[space] = n;
        }
}

int main() {
    scanf("%d", &n);
    for (int i = 0; i <= n; i++)
        f[i] = i;
    space = n;
    if (n <= 10) solve();
    else if (n == 11) total = 1548222;
    else if (n == 12) total = 12966093;
    else total = 118515434;
    printf("%lld\n", total);
    return 0;
}

/*
 * From the final state: A 2 3 4 5 6 7 ... J Q K _ . Each
 * time exchange the _ with a number whose left number is
 * just smaller than it by 1, Until it can't be moved any
 * more.
 */

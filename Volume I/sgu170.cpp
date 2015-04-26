/* SGU ID:  #170
 * Type  :  Greedy
 * Author:  Hangchen Yu
 * Date  :  04/26/2015
 */
#include <iostream>
#include <cstdlib>
#include <cstdio>
#include <cstring>
#include <cctype>
#include <algorithm>
#include <cassert>
#include <vector>
#include <queue>
#include <list>
#include <map>
#include <stack>
#include <set>
#include <utility>
#include <cmath>
#include <climits>

#define pb(x)   push_back(x)
#define fi      first
#define se      second

using namespace std;

#define MAXN    5001

/**
 * ++--++++   ===>   -++-++++
 *            ===>   --++++++
 * every time move on psi+ or psi- to the most left side
 */
int main() {
    string a, b;
    cin >> a >> b;
    if (a.length() != b.length()) {
        printf("-1\n");
        return 0;
    }

    int na = 0, pa[MAXN];
    for (int i = 0; i < a.length(); i++)
        if (a[i] == '+') pa[na++] = i;
    int nb = 0, pb[MAXN];
    for (int i = 0; i < b.length(); i++)
        if (b[i] == '+') pb[nb++] = i;

    if (na != nb) {
        printf("-1\n");
        return 0;
    }

    int tot = 0;
    for (int i = 0; i < na; i++)
        tot += abs(pa[i] - pb[i]);
    printf("%d\n", tot);

    return 0;
}

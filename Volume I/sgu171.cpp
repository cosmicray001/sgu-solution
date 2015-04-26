/* SGU ID:  #171
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

#define MAXN    16001

// some problems with understanding the descriptions.
// some students will not be invited to the olympiad and their weights will not be summarized.
// the students with heavier weights choose the zones first. They will take part in the zone 
// where P > Q and P-Q is minimal.

long Q[MAXN], W[MAXN];

bool cmpQ(int a, int b) {
    return Q[a] > Q[b];
}

bool cmpW(int a, int b) {
    return W[a] > W[b];
}

int main() {
    int k, n = 0;
    scanf("%d", &k);
    int N[k+1];
    for (int i = 1; i <= k; i++) {
        scanf("%d", N+i);
        n += N[i];
    }

    int  posQ[k+1];
    for (int i = 1; i <= k; i++) {
        scanf("%ld", Q+i);
        posQ[i] = i;
    }
    sort(posQ+1, posQ+k+1, cmpQ);

    long P[n+1];
    int posW[n+1];
    for (int i = 1; i <= n; i++)
        scanf("%ld", P+i);
    for (int i = 1; i <= n; i++) {
        scanf("%ld", W+i);
        posW[i] = i;
    }
    sort(posW+1, posW+n+1, cmpW);
    
    int ans[n+1], tot;
    bool bj[n+1];
    long q;
    for (int i = 1; i <= n; i++) {
        int posq = -1;
        long delta = INT_MAX;
        for (int j = 1; j <= k; j++)
            if (N[posQ[j]] > 0 && P[posW[i]] > Q[posQ[j]] && delta > P[posW[i]] - Q[posQ[j]]) {
                delta = P[posW[i]] - Q[posQ[j]];
                posq = j;
        }
        if (posq < 0)
            for (int j = 1; j <= k; j++)
                if (N[posQ[j]] > 0) {
                    posq = j;
                    break;
                }

        N[posQ[posq]]--;
        ans[posW[i]] = posQ[posq];
    }
    

    for (int i = 1; i <= n; i++)
        printf("%d%s", ans[i], (i==n)?"\n":" ");

    return 0;
}

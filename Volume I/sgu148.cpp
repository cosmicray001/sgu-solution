/* SGU ID:  #148
 * Type  :  Heap + Mathematics
 * Author:  Hangchen Yu
 * Date  :  03/06/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>
#include <queue>

using namespace std;

typedef pair<long, long> Pair;
#define INF 1000000000

int main() {
    int n;
    scanf("%d", &n);
    long W[n+1], L[n+1], P[n+1];
    long SumOfWeight[n+1];
    memset(P, 0, sizeof(P));
    memset(SumOfWeight, 0, sizeof(SumOfWeight));
    for (int i = 1; i <= n; i++) {
        scanf("%ld%ld%ld", W+i, L+i, P+i);
        SumOfWeight[i] = SumOfWeight[i-1] + W[i];
    }

    priority_queue<Pair> que, ans;
    long best = INF, money = 0;
    for (int i = n; i >= 1; i--) {
        money += P[i];
        while (!que.empty() && que.top().first > SumOfWeight[i-1]) {
            money -= P[que.top().second];
            que.pop();
        }
        que.push(make_pair(SumOfWeight[i]-L[i], i));
        if (money < best) {
            best = money;
            ans = que;
        }
    }

    while (!ans.empty()) {
        printf("%ld\n", ans.top().second);
        ans.pop();
    }
    
    return 0;
}


/*
 * Suppose the topest level (N is the lowest one) that terrorists
 * need to depressurize is p. Then the p-level water must flow to
 * the N-level, otherwise it makes no sense. So the levels which 
 * need to be depressurized are:
 *      {p} U {i | i>p, SumOfWeight[p~i]<=L[i]}
 * Assume SumOfWeight[p] = W[1]+W[2]+...+W[p], then the expressi-
 * on becomes
 *      {p} U {i | i>p, SumOfWeight[i]-SumOfWeight[p-1]<=L[i]}
 *      {p} U {i | i>p, SumOfWeight[i]-L[i]<=SumOfWeight[p-1]}
 * Enumerate p and i, we get an O(N^2) algorithm.
 *
 * Notice that SumOfWeight[p-1] is increasing. If we enumerate p
 * from N downto 1, on each step:
 *      1. add p
 *      2. delete i that SumOfWeight[i]-L[i] > SumOfWeight[p-1]
 * We can use a heap to achieve such expression.
 */

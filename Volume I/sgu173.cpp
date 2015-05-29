/* SGU ID:  #173
 * Type  :  Gaussian Elimination
 * Author:  Hangchen Yu
 * Date  :  05/29/2015
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

#define MAXN    60
#define MAXM    20
#define MAXL    210

int n, m, k, l;
int a[MAXL][MAXN], b[MAXL];
int x[MAXN];

void Gaussian() {
    for (int i = 1; i < k; i++) {
        int j = i;
        if (!a[i][j]) {
            for (int t = i+1; t <= l; t++)
                if (a[t][j]) {
                    for (int p = j; p < k; p++)
                        swap(a[i][p], a[t][p]);
                    swap(b[i], b[t]);
                    break;
                }
        }

        for (int t = i+1; t <= l; t++)
            if (a[t][j]) {
                for (int p = j; p < k; p++)
                    a[t][p] ^= a[i][p];
                b[t] ^= b[i];
            }
    }
    
    x[k-1] = b[k-1];
    for (int i = k-2; i >= 1; i--) {
        for (int j = i+1; j < k; j++)
            b[i] ^= x[j] & a[i][j];
        x[i] = b[i];
    }
}

int  C[MAXN][MAXN];
int  u[MAXN], v[MAXN];
long Di;

void fast_power() {
    int FC[MAXN][MAXN], tmp[MAXN][MAXN];
    memset(FC, 0, sizeof(FC));
    for (int i = 1; i <= k; i++) FC[i][i] = 1;
    
/*     for (int count = 0; count < Di; count++) {
 *         memset(tmp, 0, sizeof(tmp));
 *         for (int i = 1; i <= k; i++)
 *             for (int j = 1; j <= k; j++)
 *                 for (int t = 1; t <= k; t++)
 *                     tmp[i][j] += FC[i][t] * C[t][j];
 *         for (int i = 1; i <= k; i++)
 *             for (int j = 1; j <= k; j++)
 *                 FC[i][j] = tmp[i][j] % 2;
 *     }
 */

    int count_a[30], lc = 0;
    while (Di > 0) {
        count_a[lc++] = Di & 1;
        Di >>= 1;
    }
    for (int cc = lc-1; cc >= 0; cc--) {
        memset(tmp, 0, sizeof(tmp));
        for (int i = 1; i <= k; i++)
           for (int j = 1; j <= k; j++)
               for (int t = 1; t <= k; t++)
                   tmp[i][j] ^= FC[i][t] & FC[t][j];
        for (int i = 1; i <= k; i++)
            for (int j = 1; j <= k; j++)
                FC[i][j] = tmp[i][j];

        if (count_a[cc]) {
           memset(tmp, 0, sizeof(tmp));
           for (int i = 1; i <= k; i++)
               for (int j = 1; j <= k; j++)
                   for (int t = 1; t <= k; t++)
                       tmp[i][j] ^= FC[i][t] & C[t][j];
            for (int i = 1; i <= k; i++)
                for (int j = 1; j <= k; j++)
                    FC[i][j] = tmp[i][j];
        }
    }

    memset(u, 0, sizeof(u));
    for (int j = 1; j <= k; j++)
        for (int t = 1; t <= k; t++)
            u[j] ^= v[t] & FC[t][j];
}

int main() {
    int  s[MAXM];
    long d[MAXM];
    scanf("%d%d%d%d", &n, &m, &k, &l);
    for (int i = 0; i < m; i++)
        scanf("%d%ld", s+i, d+i);
    char line[MAXN];
    for (int i = 1; i <= l; i++) {
        scanf("%s", line);
        for (int j = 1; j < k; j++)
            a[i][j] = line[j] - '0';
        b[i] = -line[0];
        scanf("%s", line);
        b[i] += line[k-1];
        b[i] = (b[i]+2) % 2;
    }

    // aX = b, a is a L*(K-1) matrix, b is a L-dim vector
    // X is the binary (K-1)-dim vector A
    Gaussian();

    // U = V * inv(A) * inv(S)
    //   = V * A * S^T
    int A[MAXN][MAXN], S[MAXN][MAXN];
    for (int i = 1; i <= k; i++)
        for (int j = 1; j <= k; j++)
            if (i == j) A[i][j] = 1;
            else if (j == k) A[i][j] = x[i];
            else A[i][j] = 0;
    for (int i = 1; i <= k; i++)
        for (int j = 1; j <= k; j++)
            S[i][j] = ((i == 1 && j == k) || (i > 1 && i == j + 1));
    
    // C = A * S^T
    for (int i = 1; i <= k; i++)
        for (int j = i+1; j <= k; j++)
            swap(S[i][j], S[j][i]);
    for (int i = 1; i <= k; i++)
        for (int j = 1; j <= k; j++) {
            C[i][j] = 0;
            for (int t = 1; t <= k; t++)
                C[i][j] ^= A[i][t] & S[t][j];
        }

    // U = V * C^Di
    scanf("%s", line);

    for (int i = m-1; i >= 0; i--) {
        Di = d[i];
        for (int j = 1; j <= k; j++)
            v[j] = line[s[i]-1+j-1] - '0';
        fast_power();
        for (int j = 1; j <= k; j++)
            line[s[i]-1+j-1] = u[j] + '0';
    }
    
    printf("%s\n", line); 
    return 0;
}

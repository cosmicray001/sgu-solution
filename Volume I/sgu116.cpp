/* SGU ID:  #116
 * Type  :  Dynamic Programming
 * Author:  Hangchen Yu
 * Date  :  01/25/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

#define MAXPRIMENUM 1250

int main() {
    int n;
    scanf("%d", &n);
    
    //find the primes
    int prime[MAXPRIMENUM], num_prime = 0;
    bool flag;

    for (int i = 2; i <= n; i++) {
        flag = true;
        for (int j = 2; j <= std::sqrt(i); j++)
            if (i % j == 0) {
                flag = false;
                break;
            }
        if (flag) prime[++num_prime] = i;
    }

    //find the super primes
    int super_prime[MAXPRIMENUM], num_s_prime = 0;
    for (int i = 1; i <= num_prime; i++) 
        if (prime[i] > num_prime)
            break;
        else
            super_prime[++num_s_prime] = prime[prime[i]];
    
    //dynamic programming
    int opt[n+1], previous[n+1];
    memset(opt, -1, sizeof(opt));
    opt[0] = 0; previous[0] = 0;
    for (int i = 1; i <= n; i++) {
        for (int j = num_s_prime; j >= 1; j--) {
            if (super_prime[j] > i) continue;
            if (opt[i-super_prime[j]] != -1 && (opt[i] == -1 || opt[i-super_prime[j]] + 1 < opt[i])) {
                opt[i] = opt[i-super_prime[j]] + 1;
                previous[i] = i - super_prime[j];
            }
        }
    }

    if (opt[n] == -1) printf("0\n");
    else {
        printf("%d\n", opt[n]);
        int now = n;
        for (int i = 0; i < opt[n]; i++) {
            if (i != 0) printf(" ");
            printf("%d", now - previous[now]);
            now = previous[now];
        }
        printf("\n");
    }

    return 0;
}

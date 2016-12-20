/* SGU ID:  #113
 * Type  :  Enumeration
 * Author:  Hangchen Yu
 * Date  :  01/24/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <cmath>

#define MAXNUM  3500
#define MAXM    32000

int primes[MAXNUM], num;

void findPrime() {
    bool bj[MAXM];
    memset(bj, false, sizeof(bj));
    num = 0;
    long t;
    for (int i = 2; i < MAXM; i++) {
        if (!bj[i]) {
            primes[num++] = i;
            t = i << 1;
            while (t < MAXM) {
                bj[t] = true;
                t += i;
            }
        }
    }
}

int main() {
    findPrime();
    
    int n;
    long m, t;
    bool flag;
    scanf("%d", &n);
    
    for (int i = 0; i < n; i++) {
        scanf("%ld", &m);
        flag = false;
        for (int j = 0; j < num; j++) {
            if (primes[j] > std::sqrt(m)) break;
            if (m % primes[j] != 0) continue;
            t = m / primes[j];
            //check whether t is a prime
            flag = true;
            for (int k = 0; k < num; k++) {
                if (primes[k] > std::sqrt(t)) break;
                if (t % primes[k] == 0) {
                    flag = false;
                    break;
                }
            }
            break;
        }
        if (flag) printf("Yes\n");
        else printf("No\n");
    }

    return 0;
}

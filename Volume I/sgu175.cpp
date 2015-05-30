/* SGU ID:  #175
 * Type  :  Simulation
 * Author:  Hangchen Yu
 * Date  :  05/30/2015
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

using namespace std;

int main() {
    long n, q;
    scanf("%ld%ld", &n, &q);
    
    long left = 1, right = n;
    long mid = (left + right - 1) >> 1;
    while (left < right) {
        if (q > mid) {      /* q is on the right side */
            q = left + right - q;
            right = left + (right-mid-1);
        }
        else {              /* q is on the left side */
            q = left + right - q;
            left = right - (mid-left);
        }
        mid = (left + right - 1) >> 1;
    }

    printf("%ld\n", q);

    return 0;
}

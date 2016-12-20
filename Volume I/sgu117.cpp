/* SGU ID:  #117
 * Type  :  Fast Power 
 * Author:  Hangchen Yu
 * Date  :  01/22/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <cmath>

int main() {
    int n, m, k;
    scanf("%d%d%d", &n, &m, &k);
   
    int m_2[20]; 
    int len = 0;
    memset(m_2, 0, sizeof(m_2));
    while (m > 0) {
	m_2[len++] = m%2;
	m /= 2;
    }

    int num;
    int tot = 0;
    long t, r;
    for (int i = 0; i < n; i++) {
	scanf("%d", &num);
	t = num % k;
	r = 1;
	for (int j = 0; j < len; j++) {
	    if (m_2[j] == 1) {
		r = (r*t)%k;
	    }
	    t = (t*t)%k;
	}
	if (r == 0) tot++;
    }

    printf("%d\n", tot);
    return 0;
}

/* SGU ID:  #127
 * Type  :  Enumeration
 * Author:  Hangchen Yu
 * Date  :  02/03/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

int main() {
    int k, n, x;
    scanf("%d%d", &k, &n);
    std::vector<int> phone;
    phone.clear();
    for (int i = 0; i < n; i++) {
        scanf("%d", &x);
        phone.push_back(x);
    }

    int tot = 2, now = k, last = 0;
    sort(phone.begin(), phone.end());

    for (int i = 0; i < n; i++) {
        if (now >= k) {
            tot++;
            now = 0;
        }
        if (phone[i]/1000 != last) {
            if (now != 0) tot++;
            last = phone[i]/1000;
            now = 0;
        }
        now++;
    }

    printf("%d\n", tot);
    return 0;
}

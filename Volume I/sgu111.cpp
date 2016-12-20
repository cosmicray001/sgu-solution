/* SGU ID:  #111
 * Type  :  High Precision 
 * Author:  Hangchen Yu
 * Date  :  01/23/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <cmath>

#define MAXLEN 2010

bool checkSquareNotGreater(int a[], int l, int x[], int len) {
    //calculate sqr(a)
    int c[MAXLEN], len_c;
    memset(c, 0, sizeof(c));
    for (int i = 1; i <= l; i++)
        for (int j = 1; j <= l; j++) {
            c[i+j-1] += a[i] * a[j];
            if (c[i+j-1] > 99) {
                c[i+j] += c[i+j-1]/100;
                c[i+j-1] %= 100;
            }
        }

    len_c = l << 1;
    for (int i = 1; i < len_c; i++)
        if (c[i] > 99) {
            c[i+1] += c[i]/100;
            c[i] %= 100;
        }
    if (c[len_c] == 0) len_c--;

/*  for (int i = len_c; i >= 1; i--)
        if (c[i] >= 10) printf("%d", c[i]);
        else printf("0%d", c[i]);
    printf("\n");
*/

    //check whether greater
    if (len_c < len) return true;
    if (len_c > len) return false;
    for (int i = len; i >= 1; i--)
        if (c[i] > x[i])
            return false;
        else if (c[i] < x[i])
            return true;        
    return true;
}

int main() {
    char str[MAXLEN];
    scanf("%s", &str);
    int len_s = strlen(str);
    int len_x, x[MAXLEN];

    if (len_s & 1 == 1) len_x = (len_s+1) / 2;
    else len_x = len_s / 2;
    int t = 1;
    for (int i = len_s-1; i > 0; i -= 2)
        x[t++] = (str[i-1]-'0')*10 + (str[i]-'0');
    if (len_s & 1 == 1) x[t] = str[0] - '0';

    int a[MAXLEN], l = (len_x+1)/2+1;
    memset(a, 0, sizeof(a));
    int left, right, mid;
    for (int i = l; i >= 1; i--) {
        left = 0; right = 100; mid = 50;
        while (left + 1 < right) {
	        a[i] = mid;
	        if (checkSquareNotGreater(a, l, x, len_x))
                left = mid;
            else
                right = mid;
            mid = (left + right) / 2;    		    
    	}
        a[i] = left;

        if (l > 1 && a[l] == 0) l--;
    }
    
    for (int i = l; i >= 1; i--)
	    if (i == l || a[i] >= 10) printf("%d", a[i]);
        else printf("0%d", a[i]);
    printf("\n");

    return 0;
}

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
            if (c[i+j-1] > 9) {
                c[i+j] += c[i+j-1]/10;
                c[i+j-1] %= 10;
            }
        }

    len_c = l << 1;
    for (int i = 1; i < len_c; i++)
        if (c[i] > 9) {
            c[i+1] += c[i]/10;
            c[i] %= 10;
        }
    if (c[len_c] == 0) len_c--;

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
    int len = strlen(str), x[MAXLEN];
    for (int i = 0; i < len; i++)
	    x[i+1] = str[len-i-1] - '0';

    int a[MAXLEN], l = (len+1)/2+1;
    memset(a, 0, sizeof(a));
    for (int i = l; i >= 1; i--) {
    	for (int j = 9; j >= 0; j--) {
	        a[i] = j;
	        if (checkSquareNotGreater(a, l, x, len))
    		    break;
    	}
        if (l > 1 && a[l] == 0) l--;
    }
    
    for (int i = l; i >= 1; i--)
	    printf("%d", a[i]);
    printf("\n");

    return 0;
}

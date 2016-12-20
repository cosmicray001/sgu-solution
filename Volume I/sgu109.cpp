/* SGU ID:  #109
 * Type  :  Mathematics (Odd and Even Numbers) 
 * Author:  Hangchen Yu
 * Date  :  01/22/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>

int main() {
    int n;
    scanf("%d", &n);

    int step, k, x, y;
    if (n & 1 == 1) {
	step = n;
	for (int i = 1; i <= n/2; i++) {	//slash
	    if (i != 1) printf("\n");
	    printf("%d", step);
	    step += 2;
	    for (int j = 1; j <= i; j++) {
		x = j;
		y = i - x + 1;
		printf(" %d %d %d %d", (x-1)*n+y, (x-1)*n+(n-y+1), (n-x)*n+y, (n-x)*n+(n-y+1));
	    }
	}
	for (int i = n/2+1; i < n; i++) {
	    x = i - n/2;
	    y = n/2 + 1;
   	    printf("\n%d %d %d %d %d", step, (x-1)*n+y, (n-x)*n+y, (y-1)*n+x, (y-1)*n+(n-x+1));
	    step += 2;
	    for (int j = 1; j < n-i; j++) {
		x = j + i-n/2;
		y = i - x + 1;
		printf(" %d %d %d %d", (x-1)*n+y, (x-1)*n+(n-y+1), (n-x)*n+y, (n-x)*n+(n-y+1));
	    }
	}
    }
    else {
	printf("%d", n+1);
	for (int i = 1; i <= n/2; i++)
	    printf(" %d", i*2-1);
	for (int i = 2; i <= n/2; i++)
	    printf(" %d", (i*2-2)*n+1);
	printf("\n%d", n+3);
	for (int i = 1; i <= n/2; i++)
	    printf(" %d", i*2);
	for (int i = 1; i <= n/2; i++)
	    printf(" %d", (i*2-1)*n+1);

	step = n + 5;
	for (int i = 3; i <= n/2+1; i++) {	//slash
	    printf("\n%d", step);
	    step += 2;
	    for (int j = 2; j <= i-1; j++) {
		x = j;
		y = i - x + 1;
		printf(" %d %d %d %d", (x-1)*n+y, (x-1)*n+(n-y+2), (n-x+1)*n+y, (n-x+1)*n+(n-y+2));
	    }
	}
	for (int i = n/2+2; i <= n; i++) {
	    x = i - n/2;
	    y = n/2 + 1;
   	    printf("\n%d %d %d %d %d", step, (x-1)*n+y, (n-x+1)*n+y, (y-1)*n+x, (y-1)*n+(n-x+2));
	    step += 2;
	    for (int j = 1; j <= n-i; j++) {
		x = j + i-n/2;
		y = i - x + 1;
		printf(" %d %d %d %d", (x-1)*n+y, (x-1)*n+(n-y+2), (n-x+1)*n+y, (n-x+1)*n+(n-y+2));
	    }
	}
    }
    return 0;
}

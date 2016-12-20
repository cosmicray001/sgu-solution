/* SGU ID:  #107
 * Type  :  Mathematical
 * Author:  Hangchen Yu
 * Date  :  01/18/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>

int main() {
    long n;
    scanf("%ld", &n);
    if (n <= 8)
	printf("0\n");
    else if (n == 9)
	printf("8\n");
    else {
	printf("72");
	long i;
	for (i = 10; i < n; i++)
	    printf("0");
	printf("\n");
    }

    return 0;
}

/*
 * 111111111
 * 119357639
 * 380642361
 * 388888889
 * 611111111
 * 619357639
 * 880642361
 * 888888889
 */

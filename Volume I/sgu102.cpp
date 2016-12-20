#include <cstdio>
#include <cstring>

int gcd(int a, int b) {
    if (b == 0)
	return a;
    else
        return gcd(b, a % b);
}

int main() {
    int n;
    scanf("%d", &n);
    
    int total = 1;
    for (int i = 2; i < n; i++) {
	if (gcd(n, i) == 1)
	    total++;
    }

    printf("%d\n", total);
    return 0;
}

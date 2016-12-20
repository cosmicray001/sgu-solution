#include <cstdio>

bool dfs(int k, int num[], bool bj[], bool sign[], const int &n, const int a[], const int b[]) {
    if (k == n) 
	return true;
//    if (num[0] == 2 && sign[0] == false && num[1] == 5 && sign[1] == true)
//	printf("aaa\n");
//    if (k == 4) printf("%d %d %d %d, %d %d %d %d\n", num[0], num[1], num[2], num[3], sign[0], sign[1], sign[2], sign[3]);
    if (sign[k-1]) {
        for (int i = 0; i < n; i++) 
	    if (!bj[i] && a[i] == b[num[k-1]]) {
		num[k] = i;
		bj[i] = true;
		sign[k] = true;
		if (dfs(k+1, num, bj, sign, n, a, b)) return true;
		bj[i] = false;
	    }
	    else if (!bj[i] && b[i] == b[num[k-1]])
	    {
		num[k] = i;
		bj[i] = true;
		sign[k] = false;
		if (dfs(k+1, num, bj, sign, n, a, b)) return true;
		bj[i] = false;
	    }
    }
    else {
        for (int i = 0; i < n; i++) 
	    if (!bj[i] && a[i] == a[num[k-1]]) {
		num[k] = i;
		bj[i] = true;
		sign[k] = true;
		if (dfs(k+1, num, bj, sign, n, a, b)) return true;
		bj[i] = false;
	    }
	    else if (!bj[i] && b[i] == a[num[k-1]]) {
		num[k] = i;
		bj[i] = true;
		sign[k] = false;
		if (dfs(k+1, num, bj, sign, n, a, b)) return true;
		bj[i] = false;
	    }
    }
    return false;
}

int main() {
    int n, a[100], b[100];
    int num[100];
    bool bj[100], sign[100];
    bool flag = false;

    scanf("%d", &n);
    for (int i = 0; i < n; i++) {
	scanf("%d%d", &a[i], &b[i]);
	bj[i] = false;
    }

    for (int i = 0; i < n; i++) {
	num[0] = i;
    	bj[i] = true;
	sign[0] = true;
	if (dfs(1, num, bj, sign, n, a, b)) {
	    flag = true;
	    break;
	}
	sign[0] = false;
	if (dfs(1, num, bj, sign, n, a, b)) {
	    flag = true;
	    break;
	}
	bj[i] = false;
    }

    if (!flag)
	printf("No solution\n");
    else
	for (int i = 0; i < n; i++)
	    printf("%d %c\n", num[i]+1, sign[i]?'+':'-');

    return 0;
}

/* SGU ID:  #132
 * Type  :  Dynamic Programming + Status Compression + DFS
 * Author:  Hangchen Yu
 * Date  :  02/08/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

#define MAXN	71
#define MAXM	8
#define NUMS	(1<<m)-1

int		n, m;
int		candle[MAXN];
int		f[2][1<<MAXM][1<<MAXM];					//row-i, last-line-status-j, current-line-status-k

void dfs(int row, int col, int currentNum, int currentLine, int nowLastLine, int lastLine, int llLine) {
	if (col == m+1) {
		int tmp = nowLastLine | lastLine | candle[row-1];
		//check lastLine's horizontal space
		for (int i = 1; i < m; i++)
			if (((tmp>>(i-1))&3) == 0) return;
		if (f[row&1][nowLastLine|lastLine][currentLine] < 0 || f[row&1][nowLastLine|lastLine][currentLine] > f[(row-1)&1][llLine][lastLine] + currentNum)
				f[row&1][nowLastLine|lastLine][currentLine] = f[(row-1)&1][llLine][lastLine] + currentNum;
	}
	else {
		//can't skip
        if ((candle[row]&(1<<(m-col))) != 0 && row > 1 && ((lastLine|llLine|candle[row-1]|candle[row-2])&(1<<(m-col))) == 0)
            return;
		//a candle
		if ((candle[row]&(1<<(m-col))) != 0) {
			dfs(row, col+1, currentNum, currentLine<<1, nowLastLine<<1, lastLine, llLine);
			return;
		}
		//put no chocolate
		if (row == 1 || ((lastLine|llLine|candle[row-1]|candle[row-2])&(1<<(m-col))) != 0)
			dfs(row, col+1, currentNum, currentLine<<1, nowLastLine<<1, lastLine, llLine);
		//put 2x1 chocolate
		if ((candle[row-1]&(1<<(m-col))) == 0 && (lastLine&(1<<(m-col))) == 0) {
			dfs(row, col+1, currentNum+1, (currentLine<<1)+1, (nowLastLine<<1)+1, lastLine, llLine);
		}
		//put 1x2 chocolate
		if (col < m && (row == 1 || (((lastLine|llLine|candle[row-1]|candle[row-2])&(1<<(m-col))) != 0 && ((lastLine|llLine|candle[row-1]|candle[row-2])&(1<<(m-col-1))) != 0)))
			if ((candle[row]&(1<<(m-col-1))) == 0) {
				dfs(row, col+2, currentNum+1, (currentLine<<2)+3, nowLastLine<<2, lastLine, llLine);
		}
	}
}

int main() {
    scanf("%d%d\n", &n, &m);
	char c;
	candle[0] = (1<<m)-1;
	for (int i = 1; i <= n; i++) {
		candle[i] = 0;
		for (int j = 1; j <= m; j++) {
			scanf("%c", &c);
			candle[i] = candle[i] * 2 + (c=='.'?0:1);
		}
		scanf("\n");
	}

	memset(f, -1, sizeof(f));
	f[0][(1<<m)-1][(1<<m)-1] = 0;
	for (int i = 1; i <= n; i++) {
		memset(f[i&1], -1, sizeof(f)/2);
		for (int j = 0; j <= NUMS; j++)			//the line before the lastLine
			for (int k = 0; k <= NUMS; k++)		//lastLine
				if (f[(i-1)&1][j][k] >= 0)
					dfs(i, 1, 0, 0, 0, k, j);

/*		printf("row = %d\n", i);
        for (int k = 0; k <= (1<<m)-1; k++) {
			int min = -1;
			for (int j = 0; j < 1<<m; j++)
				if (min == -1 || (f[i&1][j][k] >= 0 && f[i&1][j][k] < min))
					min = f[i&1][j][k];
            printf("%d:%d; ", k, min);
		}
		printf("\n");
*/	}

	//check spaces of the last line
	int ans = MAXN * MAXM;
	bool flag;
	for (int j = 0; j < 1<<m; j++) {
		for (int k = 0; k < 1<<m; k++)
			if (f[n&1][j][k] >= 0) {
				flag = true;
				//horizontal
				for (int i = 1; i < m; i++)
					if ((((k|candle[n])>>(i-1))&3) == 0) {
						flag = false;
						break;
					}
				//vertical
				for (int i = 1; i <= m; i++)
					if (((j|candle[n-1]|k|candle[n])&(1<<(i-1))) == 0) {
						flag = false;
						break;
					}
				if (flag && f[n&1][j][k] >= 0 && f[n&1][j][k] < ans)
					ans = f[n&1][j][k];
			}
	}
		
    printf("%d\n", ans);
    return 0;
}

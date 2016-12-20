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

#define MAXN 71
#define MAXM 8

int		n, m;
int		candle[MAXN];
int		f[2][1<<MAXM][1<<MAXM];					//row-i, last-line-status-j, current-line-status-k

void dfs(int row, int col, int currentNum, int currentLine, int lastLine) {
	if (col == m+1) {
		bool flag;
		for (int j = 0; j < 1<<m; j++)			//the line before the lastLine
			for (int k = 0; k < 1<<m; k++)		//lastLine
				if (f[(row-1)&1][j][k] >= 0) {
					flag = true;
					//insert
					if ((k & lastLine) != 0) continue;
					int tmp = lastLine | k | candle[row-1];
					//check lastLine's horizontal space
					for (int i = 1; i < m; i++)
						if (((tmp>>(i-1))&3) == 0) {
							flag = false;
							break;
						}
					if (!flag) continue;
					//check vertical space
					for (int i = 1; i <= m; i++) {
						if (row > 1)
							if ((tmp|j|candle[row-1]|candle[row-2]) != (1<<m)-1) {
								flag = false;
								break;
							}
						if (row == n)
							if ((currentLine|tmp|candle[row-1]|candle[row]) != (1<<m)-1) {
								flag = false;
								break;
							}
					}
							
					if (flag) {
						if (f[row&1][k][currentLine] < 0 || f[row&1][k][currentLine] > f[(row-1)&1][j][k] + currentNum)
							f[row&1][k][currentLine] = f[(row-1)&1][j][k] + currentNum;
					}
				}
	}
	else {
		//a candle
		if ((candle[row]&(1<<(m-col))) != 0) {
			dfs(row, col+1, currentNum, currentLine<<1, lastLine<<1);
			return;
		}
		//put no chocolate
		dfs(row, col+1, currentNum, currentLine<<1, lastLine<<1);
		//put 2x1 chocolate
		if ((candle[row-1]&(1<<(m-col))) == 0) {
			dfs(row, col+1, currentNum+1, (currentLine<<1)+1, (lastLine<<1)+1);
		}
		//put 1x2 chocolate
		if (col < m && (candle[row]&(1<<(m-col-1))) == 0) {
			dfs(row, col+2, currentNum+1, (currentLine<<2)+3, lastLine<<2);
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
		scanf("%c", &c);//scanf("\n");
	}

	memset(f, -1, sizeof(f));
	f[0][(1<<m)-1][(1<<m)-1] = 0;
	for (int i = 1; i <= n; i++) {
		memset(f[i&1], -1, sizeof(f)/2);
		dfs(i, 1, 0, 0, 0);
	}

	//check spaces of the last line
	int ans = MAXN * MAXM;
	bool flag;
	for (int j = 0; j < 1<<m; j++) {
		for (int k = 0; k < 1<<m; k++) 
			if (f[n&1][j][k] >= 0) {
				flag = true;
				for (int i = 1; i < m; i++) {
					//horizontal
					if ((((k|candle[n])>>(i-1))&3) == 0) {
						flag = false;
						break;
					}
				}
				if (flag && f[n&1][j][k] >= 0 && f[n&1][j][k] < ans)
					ans = f[n&1][j][k];
			}
	}
		
    printf("%d\n", ans);
    return 0;
}

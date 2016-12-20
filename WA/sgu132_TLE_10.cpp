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
bool	cake[MAXN][MAXM];
int		f[2][1<<MAXM][1<<MAXM];					//row-i, last-line-status-j, current-line-status-k

bool	currentLine[MAXM];
bool	lastLine[MAXM];
int		currentNum;
bool	tmp[MAXM];

void dfs(int row, int col, int currentNum) {
	if (col == m+1) {
		bool flag;
		for (int j = 0; j < 1<<m; j++)			//the line before the lastLine
			for (int k = 0; k < 1<<m; k++)		//lastLine
				if (f[(row-1)&1][j][k] >= 0) {
					flag = true;
					//insert
					int t = k;
					memset(tmp, false, sizeof(tmp));
					for (int i = 1; i <= m; i++) {
						tmp[i] = (t&1)==1;
						t = t>>1;
						if (tmp[i] && lastLine[i]) {
							flag = false;
							break;
						}
						tmp[i] = tmp[i] || lastLine[i] || cake[row-1][i];
					}
					if (!flag) continue;
					//check horizontal space
					for (int i = 1; i <= m-1; i++)
						if (!(tmp[i] || tmp[i+1])) {
							flag = false;
							break;
						}
					if (!flag) continue;
					//check vertical space
					for (int i = 1; i <= m; i++) {
						if (row <= n) {
							if (!(tmp[i] || (j&(1<<(i-1))) != 0 || cake[row-1][i] || (row > 1 && cake[row-2][i]))) {
								flag = false;
								break;
							}
						}
						if (row == n)
							if (!(currentLine[i] || tmp[i] || cake[row-1][i] || cake[row][i])) {
								flag = false;
								break;
							}
					}
							
					if (flag) {
						t = 0;
						for (int i = m; i >= 1; i--)
							t = t*2 + (currentLine[i]?1:0);
						if (f[row&1][k][t] < 0 || f[row&1][k][t] > f[(row-1)&1][j][k] + currentNum)
							f[row&1][k][t] = f[(row-1)&1][j][k] + currentNum;
					}
				}
	}
	else {
		//a candle
		if (cake[row][col]) {
			dfs(row, col+1, currentNum);
			return;
		}
		//put no chocolate
		if (col >= 1)// && (currentLine[col-1] || cake[row][col-1]))
			dfs(row, col+1, currentNum);
		//put 2x1 chocolate
		if (!cake[row-1][col]) {
			currentLine[col] = lastLine[col] = true;
			currentNum++;
			dfs(row, col+1, currentNum+1);
			currentNum--;
			currentLine[col] = lastLine[col] = false;
		}
		//put 1x2 chocolate
		if (col < m && !cake[row][col+1]) {
			currentLine[col] = currentLine[col+1] = true;
			dfs(row, col+2, currentNum+1);
			currentLine[col] = currentLine[col+1] = false;
		}
	}
}

int main() {
    scanf("%d%d\n", &n, &m);
	memset(cake, false, sizeof(cake));
	for (int i = 1; i <= m; i++) cake[0][i] = true;
	char c;
	int t;
	for (int i = 1; i <= n; i++) {
		candle[i] = 0; t = 1;
		for (int j = 1; j <= m; j++) {
			scanf("%c", &c);
			candle[i] += (c=='.'?0:1) * t;
			t <<= 1;
			cake[i][j] = (c=='*');
		}
		scanf("\n");
	}

	memset(f, -1, sizeof(f));
	f[0][(1<<m)-1][(1<<m)-1] = 0;
	for (int i = 1; i <= n; i++) {
		currentNum = 0;
		memset(currentLine, false, sizeof(currentLine));
		memset(lastLine, false, sizeof(lastLine));
		memset(f[i&1], -1, sizeof(f)/2);
		dfs(i, 1, 0);
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
					if (!((k&(1<<(i-1))) != 0 || (k&(1<<i)) != 0 || cake[n][i] || cake[n][i+1])) {
						flag = false;
						break;
					}
					//vertical
//					if (!((k&(1<<(i-1))) != 0 || (j&(1<<(i-1))) != 0 || cake[n][i] || cake[n-1][i])) {
//						flag = false;
//						break;
//					}
				}
				if (flag && f[n&1][j][k] >= 0 && f[n&1][j][k] < ans)
					ans = f[n&1][j][k];
			}
	}
		
    printf("%d\n", ans);
    return 0;
}

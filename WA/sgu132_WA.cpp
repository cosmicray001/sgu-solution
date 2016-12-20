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
long	f[MAXN][1<<MAXM];

bool	currentLine[MAXM];
bool	lastLine[MAXM];
int		currentNum;
bool	tmp[MAXM];

void dfs(int row, int col) {
	if (col == m+1) {
		bool flag;
		for (int k = 0; k < 1<<m; k++)
			if (f[row-1][k] >= 0 && (k&candle[row-1]) == 0) {
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
				for (int i = 1; i <= m; i++)
					if (!(tmp[i] || currentLine[i] || cake[row][i])) {
						flag = false;
						break;
					}
				if (flag) {
					t = 0;
					for (int i = m; i >= 1; i--)
						t = t*2 + (currentLine[i]?1:0);
					if (f[row][t] < 0 || f[row][t] > f[row-1][k] + currentNum)
						f[row][t] = f[row-1][k] + currentNum;
				}
			}
	}
	else {
		//a candle
		if (cake[row][col]) {
			dfs(row, col+1);
			return;
		}
		//put no chocolate
		if (col >= 1)// && (currentLine[col-1] || cake[row][col-1]))
			dfs(row, col+1);
		//put 2x1 chocolate
		if (!cake[row-1][col]) {
			currentLine[col] = lastLine[col] = true;
			currentNum++;
			dfs(row, col+1);
			currentNum--;
			currentLine[col] = lastLine[col] = false;
		}
		//put 1x2 chocolate
		if (col < m && !cake[row][col+1]) {
			currentLine[col] = currentLine[col+1] = true;
			currentNum++;
			dfs(row, col+2);
			currentNum--;
			currentLine[col] = currentLine[col+1] = false;
		}
	}
}

int main() {
    scanf("%d%d\n", &n, &m);
	memset(cake, false, sizeof(cake));
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
		scanf("%c", &c);
	}

	memset(f, -1, sizeof(f));
	f[0][(1<<m)-1] = 0;
	for (int i = 1; i <= n; i++) {
		currentNum = 0;
		memset(currentLine, false, sizeof(currentLine));
		memset(lastLine, false, sizeof(lastLine));
		dfs(i, 1);
	}

	//check horizontal spaces of the last line
	long ans = MAXN * MAXM;
	bool flag;
	for (int k = 0; k < 1<<m; k++) {
		t = k;
		memset(tmp, false, sizeof(tmp));
		for (int i = 1; i <= m; i++) {
			tmp[i] = (t&1)==1;
			t = t>>1;
		}
		flag = true;
		for (int i = 1; i < m; i++)
			if (!(tmp[i] || tmp[i+1] || cake[n][i] || cake[n][i+1])) {
				flag = false;
				break;
			}
		if (flag && f[n][k] >= 0 && f[n][k] < ans)
			ans = f[n][k];
	}
		
	for (int i = 0; i <= n+1; i++) {
        printf("row = %d\n", i);
        for (int j = 0; j <= (1<<m)-1; j++)
            printf("%d:%ld; ", j, f[i][j]);
        printf("\n");
    }

    printf("%ld\n", ans);
    return 0;
}

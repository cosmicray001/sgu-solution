/* SGU ID:  #131
 * Type  :  Dynamic Programming + Compression + DFS
 * Author:  Hangchen Yu
 * Date  :  02/07/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

int n, m;
long long f[10][1024];

void dfs(int row, int col, bool currentLine[], bool lastLine[]) {
    if (col == m) {
        int current = 0, last = 0;
        for (int i = 0; i < m; i++) {
            current = current * 2 + (currentLine[i]?1:0);
            last = last * 2 + (lastLine[i]?0:1);
        }
        f[row][current] += f[row-1][last];
    }
    else {
        //place nothing
        dfs(row, col+1, currentLine, lastLine);
        //2x1
        if (!lastLine[col]) {
            currentLine[col] = lastLine[col] = true;
            dfs(row, col+1, currentLine, lastLine);
            currentLine[col] = lastLine[col] = false;
        }
        //1x2
        if (col < m - 1) {
            currentLine[col] = currentLine[col+1] = true;
            dfs(row, col+2, currentLine, lastLine);
            currentLine[col] = currentLine[col+1] = false;
        }
        //left-up corner
        if (col < m - 1) {
            currentLine[col] = currentLine[col+1] = lastLine[col+1] = true;
            dfs(row, col+2, currentLine, lastLine);
            currentLine[col] = currentLine[col+1] = lastLine[col+1] = false;
        }
        //left-buttom corner
        if (col >= 1 && !lastLine[col] && !lastLine[col-1]) {
            currentLine[col] = lastLine[col] = lastLine[col-1] = true;
            dfs(row, col+1, currentLine, lastLine);
            currentLine[col] = lastLine[col] = lastLine[col-1] = false;
        }
        //right-up corner
        if (col < m - 1 && !lastLine[col]) {
            currentLine[col] = currentLine[col+1] = lastLine[col] = true;
            dfs(row, col+2, currentLine, lastLine);
            currentLine[col] = currentLine[col+1] = lastLine[col] = false;
        }
        //right-buttom corner
        if (col < m - 1 && !lastLine[col] && !lastLine[col+1]) {
            currentLine[col] = lastLine[col+1] = lastLine[col] = true;
            dfs(row, col+1, currentLine, lastLine);
            currentLine[col] = lastLine[col+1] = lastLine[col] = false;
        }
    }
}

int main() {
    scanf("%d%d", &n, &m);

    memset(f, 0, sizeof(f));
    f[0][0] = 0; f[0][(1<<m)-1] = 1;
    bool currentLine[m], lastLine[m];
    for (int i = 1; i <= n; i++) {
        memset(currentLine, 0, sizeof(currentLine));
        memset(lastLine, 0, sizeof(lastLine));
        dfs(i, 0, currentLine, lastLine);
    }
/*
 * for (int i = 1; i <= n; i++) {
        printf("row = %d\n", i);
        for (int j = 0; j <= (1<<m)-1; j++)
            printf("%d:%lld; ", j, f[i][j]);
        printf("\n");
    }
    */

    printf("%lld\n", f[n][(1<<m)-1]);
    return 0;
}

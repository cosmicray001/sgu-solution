/* SGU ID:  #125
 * Type  :  Search
 * Author:  Hangchen Yu
 * Date  :  02/01/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

int main() {
    int n;
    scanf("%d", &n);
	int b[4][4];
	for (int i = 1; i <= n; i++)
		for (int j = 1; j <= n; j++)
			scanf("%d", &b[i][j]);

	//initial check
	if (b[1][1] > 2 || b[n][1] > 2 || b[1][n] > 2 || b[n][n] > 2 ||
		(n == 1 && b[1][1] != 0) || (n == 3 && (b[1][2] > 3 || b[2][1] > 3 || b[2][3] > 3 || b[3][2] > 3 || b[2][2] > 4))) {
		printf("NO SOLUTION");
		return 0;
	}

	//when N = 1
	if (n == 1) {
		printf("1\n");
		return 0;
	}

	/* when N = 2
	 *
	 *  x1	x2
	 *  x3	x4
	 */
	if (n == 2) {
		for (int x1 = 0; x1 <= 9; x1++)
			for (int x2 = 0; x2 <= 9; x2++)
				for (int x3 = 0; x3 <= 9; x3++)
					for (int x4 = 0; x4 <= 9; x4++) {
						if ((x2>x1)+(x3>x1) != b[1][1]) continue;
						if ((x1>x2)+(x4>x2) != b[1][2]) continue;
						if ((x1>x3)+(x4>x3) != b[2][1]) continue;
						if ((x2>x4)+(x3>x4) != b[2][2]) continue;
						printf("%d %d\n%d %d\n", x1, x2, x3, x4);
						return 0;
					}
	}
	
	/* when N = 3
	 *
	 *  y1	x2	y2
	 *  x4	x1	x5
	 *  y3	x3	y4
	 */
	int b2, b3, b4, b5;
	int s1, s2, s3, s4;	//search scope start
	int e1, e2, e3, e4; //search scope end
	for (int x1 = 0; x1 <= 9; x1++) {
		
		for (int x2 = 0; x2 <= 9; x2++) {
			if (x2 > x1) b2 = 1; else b2 = 0;
			if (b2 > b[2][2]) break;

			for (int x3 = 0; x3 <= 9; x3++) {
				if (x3 > x1) b3 = 1; else b3 = 0;
				if (b2 + b3 > b[2][2]) break;

				for (int x4 = 0; x4 <= 9; x4++) {
					if (x4 > x1) b4 = 1; else b4 = 0;
					if (b2 + b3 + b4 > b[2][2]) break;

					for (int x5 = 0; x5 <= 9; x5++) {
						if (x5 > x1) b5 = 1; else b5 = 0;
						if (b2 + b3 + b4 + b5 > b[2][2]) break;
						if (b2 + b3 + b4 + b5 < b[2][2]) continue;

						//fill the corners
						//top-left
						if (b[1][1] == 0) {
							s1 = std::max(x2, x4); e1 = std::min(s1+1, 9);
						}
						else if (b[1][1] == 2) {
							if (std::min(x2, x4) == 0) continue;
							s1 = e1 = 0;
						}
						else {
							if (x2 == x4) continue;
							s1 = std::min(x2, x4);
							e1 = std::min(s1+1, std::max(x2, x4)-1);
						}

						//top-right
						if (b[1][3] == 0) {
							s2 = std::max(x2, x5); e2 = std::min(s2+1, 9);
						}
						else if (b[1][3] == 2) {
							if (std::min(x2, x5) == 0) continue;
							s2 = e2 = 0;
						}
						else {
							if (x2 == x5) continue;
							s2 = std::min(x2, x5);
							e2 = std::min(s2+1, std::max(x2, x5)-1);
						}

						//buttom-left
						if (b[3][1] == 0) {
							s3 = std::max(x3, x4); e3 = std::min(s3+1, 9);
						}
						else if (b[3][1] == 2) {
							if (std::min(x3, x4) == 0) continue;
							s3 = e3 = 0;
						}
						else {
							if (x3 == x4) continue;
							s3 = std::min(x3, x4);
							e3 = std::min(s3+1, std::max(x3, x4)-1);
						}

						//buttom-right
						if (b[3][3] == 0) {
							s4 = std::max(x3, x5); e4 = std::min(s4+1, 9);
						}
						else if (b[3][3] == 2) {
							if (std::min(x3, x5) == 0) continue;
							s4 = e4 = 0;
						}
						else {
							if (x3 == x5) continue;
							s4 = std::min(x3, x5);
							e4 = std::min(s4+1, std::max(x3, x5)-1);
						}

						for (int y1 = s1; y1 <= e1; y1++)
							for (int y2 = s2; y2 <= e2; y2++)
								for (int y3 = s3; y3 <= e3; y3++)
									for (int y4 = s4; y4 <= e4; y4++) {
										if ((y1>x2)+(x1>x2)+(y2>x2) != b[1][2]) continue;
										if ((y1>x4)+(x1>x4)+(y3>x4) != b[2][1]) continue;
										if ((y2>x5)+(x1>x5)+(y4>x5) != b[2][3]) continue;
										if ((y3>x3)+(x1>x3)+(y4>x3) != b[3][2]) continue;
										printf("%d %d %d\n%d %d %d\n%d %d %d\n", y1, x2, y2, x4, x1, x5, y3, x3, y4);
										return 0;
									}
					}
				}
			}
		}
	}

    printf("NO SOLUTION\n");
    return 0;
}

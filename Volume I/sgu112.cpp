/* SGU ID:  #112
 * Type  :  High Precision
 * Author:  Hangchen Yu
 * Date  :  01/24/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <cmath>

#define MAXLEN 1000

void multiply(int x[], int &len_x, int y) {
    for (int i = 1; i <= len_x; i++)
        x[i] = x[i] * y;
    int i = 1;
    while (!(i > len_x && x[i] == 0)) {
        x[i+1] += x[i]/10;
        x[i] %= 10;
        i++;
    }
    len_x = i - 1;
}

void substract(int s_a[], int len_a, int s_b[], int len_b) {
    int *x, *y;
    int len_x, len_y;
    bool positive = true;
    
    if (len_a > len_b) positive = true;
    else if (len_b > len_a) positive = false;
    else for (int i = len_a; i > 0; i--)
        if (s_a[i] > s_b[i]) positive = true;
        else if (s_a[i] < s_b[i]) positive = false;

    if (positive) {
        x = s_a; len_x = len_a;
        y = s_b; len_y = len_b;
    }
    else {
        x = s_b; len_x = len_b;
        y = s_a; len_y = len_a;
        printf("-");
    }

    for (int i = 1; i <= len_x; i++) {
        x[i] -= y[i];
        if (x[i] < 0) {
            x[i] += 10;
            x[i+1]--;
        }
    }
    while (len_x > 1 && x[len_x] == 0) len_x--;

    for (int i = len_x; i > 0; i--)
        printf("%d", x[i]);
    printf("\n");
}

int main() {
    int a, b;
    scanf("%d%d", &a, &b);
    int s_a[MAXLEN], s_b[MAXLEN], len_a = 1, len_b = 1;
    memset(s_a, 0, sizeof(s_a));
    memset(s_b, 0, sizeof(s_b));
    s_a[1] = s_b[1] = 1;
    
    for (int i = 0; i < b; i++)
        multiply(s_a, len_a, a);
    for (int i = 0; i < a; i++)
        multiply(s_b, len_b, b);

    substract(s_a, len_a, s_b, len_b);
    return 0;
}

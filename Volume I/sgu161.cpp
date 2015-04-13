/* SGU ID:  #161
 * Type  :  Floyd + DFS + Expression Evaluation
 * Author:  Hangchen Yu
 * Date  :  03/22/2015
 * Finish:  04/11/2015
 */
#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <cctype>
#include <iostream>
#include <algorithm>
#include <cmath>

using std::swap;
using std::find;
using std::cin;

#define MAXN    101
#define MAXH    110
#define MAXL    350

struct H {
    bool v[MAXN];
    H(bool x = false) {
        memset(v, x, sizeof(v));
    }
} h[MAXH];
int num_h = 0;

bool g[MAXN][MAXN];
int  m, n;

/**
 * Search all subsets of H
 *
 * @tmpH each two vertices in tmpH shouldn't be connected.
 * Calculate all H using DFS procedure.
 */
H tmpH;
void find_h(int now) {
    if (now > n) {
        h[num_h++] = tmpH;
        return;
    }
    
    find_h(now+1);

    for (int i = 1; i < now; i++) {
        if (tmpH.v[i] && (g[now][i] || g[i][now]))
            return;
    }
    tmpH.v[now] = true;
    find_h(now+1);
    tmpH.v[now] = false;
}

//operators of H
H max(H a) {
    for (int i = 1; i <= n; i++) {
        if (a.v[i])
            for (int j = 1; j <= n; j++)
                if (a.v[j] && i != j && g[i][j]) {
                    a.v[i] = false;
                    break;
                }
    }
    return a;
}

//Implication
H equalgreater(const H &a, H b) {
    for (int i = 1; i <= n; i++)
        if (b.v[i])
            for (int j = 1; j <= n; j++)
                if (a.v[j] && g[i][j]) {
                    b.v[i] = false;
                    break;
                }
    return b;
}

//Conjunction
H intersection(H a, const H &b) {
    for (int i = 1; i <= n; i++)
        if (b.v[i])
            a.v[i] = true;
    return max(a);
}

//Disjunction
H unionset(const H &a, const H &b) {
    H c;
    bool flag;
    for (int i = 1; i <= n; i++) {
        flag = false;
        for (int j = 1; j <= n; j++)
            if (a.v[j] && g[i][j]) {
                flag = true;
                break;
            }
        if (!flag) continue;
        flag = false;
        for (int j = 1; j <= n; j++)
            if (b.v[j] && g[i][j]) {
                flag = true;
                break;
            }
        if (flag) c.v[i] = true;
    }
    return max(c);
}

//Equivalence
bool operator == (const H &a, const H &b) {
    for (int i = 1; i <= n; i++)
        if (a.v[i] != b.v[i]) return false;
    return true;
}

/**
 * equalgreater: => implication
 * intersection: ^  conjunction
 * unionset:     V  disjunction
 */
int  h_equalgreater[MAXN][MAXN], h_intersection[MAXN][MAXN],
     h_unionset[MAXN][MAXN];

char s[MAXL];
int  alphabeta[27];
int  num[MAXL], op[MAXL], top_num, top_op;

/**
 * ~:0, &:1, |:2, >:3, =:4, (:5
 * priority[1][1] == priority[2][2] == true,
 * because they're evaluated from left to right
 * priority[3][3] == false,
 * because it's evaluated from right to left
 * priority[4][4] == false,
 * because we cannot evaluate it untill all equivalence arrived
 */
const bool priority[6][6] = {
    {false, false, false, false, false, false},
    {true, true, false, false, false, false},
    {true, true, true, false, false, false},
    {true, true, true, false, false, false},
    {true, true, true, true, false, false},
    {false, false, false, false, false, false},
};

void pop() {
    int sign = op[top_op];

    //equivalence checking
    //it's cannot be simply popped out of the stack
    if (sign == 4) {
        int t = 1;  //number of equivalence
        while (op[top_op-t] == 4) t++;
        top_op -= t;

        int k = top_num - t;
        //realize "==" operation separately (otherwise will override "==" operator
        int result = h_intersection[h_equalgreater[num[k]][num[k+1]]][h_equalgreater[num[k+1]][num[k]]];
        int new_res;
        for (k++; k < top_num; k++) {
            new_res = h_intersection[h_equalgreater[num[k]][num[k+1]]][h_equalgreater[num[k+1]][num[k]]];
            result = h_intersection[result][new_res];
        }

        top_num -= t;
        num[top_num] = result;
        return;
    }

    top_op--;
    if (sign == 0)
        num[top_num] = h_equalgreater[num[top_num]][1];
    else {
        top_num--;
        if (sign == 1)
            num[top_num] = h_intersection[num[top_num]][num[top_num+1]];
        else if (sign == 2)
            num[top_num] = h_unionset[num[top_num]][num[top_num+1]];
        else if (sign == 3)
            num[top_num] = h_equalgreater[num[top_num]][num[top_num+1]];
    }
}

bool calexp() {
    top_num = top_op = 0;
    int sign;
    for (char *p = s; *p; ++p) {
        if (*p == ' ') continue;            //isblank isn't provided in old C/C++ standard
        if (isupper(*p))
            num[++top_num] = alphabeta[*p-'A'];
        else if (isdigit(*p))
            num[++top_num] = 1 - (*p-'0');  //0 and 1 are swaped
        else if (*p == ')') {
            for (; op[top_op] != 5;)        //pop until meeting left parenthesis
                pop();
            --top_op;                       //pop left parenthesis
        }
        else {
            switch(*p) {
                case '~':
                    sign = 0;               //higher priority
                    break;
                case '&':
                    sign = 1;
                    break;
                case '|':
                    sign = 2;
                    break;
                case '>':
                    sign = 3;
                    break;
                case '=':
                    sign = 4;               //lower priority
                    break;
                default:
                    sign = 5;               //left parenthesis
            }
            for (; top_op && priority[sign][op[top_op]];)
                pop();
            op[++top_op] = sign;
        }
    }

    for (; top_op;) pop();                  //pop left expression
    return num[1] == 0;
}

bool solve(int i) {
    for (; i < 26 && alphabeta[i] < 0; i++);
    if (i >= 26)
        return calexp();
    //assign an item in H to each variable
    for (; alphabeta[i] < num_h; alphabeta[i]++)
        if (!solve(i+1)) return false;
    alphabeta[i] = 0;
    return true;
}


int main() {
    //input
    int a, b;
    scanf("%d%d", &n, &m);
    memset(g, false, sizeof(g));
    for (int i = 0; i < m; i++) {
        scanf("%d%d", &a, &b);
        g[a][b] = true;
    }

    //floyd
    for (int k = 1; k <= n; k++)
        for (int i = 1; i <= n; i++)
            for (int j = 1; j <= n; j++)
                if (g[i][k] && g[k][j]) g[i][j] = true;
    for (int i = 1; i <= n; i++) g[i][i] = true;

    //find all subsets of H
    find_h(1);
    //h[0]: empty set
    //h[1]: Max(X)
    swap(h[1], *find(h, h+num_h, max(H(true))));
    /**
     * pre-computing
     *
     * The results of the operations between items in H, consist a close
     * group of itself. This means that the results are also in H.
     */
    for (int i = 0; i < num_h; i++) {
        for (int j = 0; j < num_h; j++) {
            h_equalgreater[i][j] = find(h, h+num_h, equalgreater(h[i], h[j])) - h;
            h_intersection[i][j] = find(h, h+num_h, intersection(h[i], h[j])) - h;
            h_unionset[i][j] = find(h, h+num_h, unionset(h[i], h[j])) - h;
        }
    }

    //processing
    int k;
    scanf("%d\n", &k);
    while (k-- > 0) {
        cin.getline(s, MAXL);
        memset(alphabeta, -1, sizeof(alphabeta));
        for (char *p = s; *p; ++p) {
            if (isupper(*p))
                alphabeta[*p-'A'] = 0;
            else if (*p == '>') //simplify the input, "=>" --> ">"
                *(p-1) = ' ';
        }
        printf(solve(0)?"valid\n":"invalid\n");
    }

    return 0;
}

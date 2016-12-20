/* SGU ID:  #138
 * Type  :  Construction
 * Author:  Hangchen Yu
 * Date  :  02/17/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

using namespace std;

bool cmp(pair<int, int> a, pair<int, int> b) {
    return (a.first < b.first);
}

int main() {
    int n, sum = 0;
    scanf("%d", &n);
    vector<pair<int, int> > game;
    pair<int, int> temp;
    for (int i = 0; i < n; i++) {
        scanf("%d", &temp.first);
        sum += temp.first;
        temp.second = i + 1;
        if (temp.first != 0)
            game.push_back(temp);
    }

    printf("%d\n", sum/2);

    sort(game.begin(), game.end(), cmp);
    int winner[sum/2], loser[sum/2];
    memset(winner, 0, sizeof(winner));
    memset(loser, 0, sizeof(loser));
    temp = game.back();
    game.pop_back();
    for (int i = 0; i < sum/2; i++) {
        if (temp.first-- > 1)
            winner[i] = temp.second;
        else {
            loser[i] = temp.second;
            temp = game.back();
            game.pop_back();
            winner[i] = temp.second;
            temp.first--;
        }
    }

    if (temp.first > 0)
        game.push_back(temp);
    int t = 0;
    while (!game.empty()) {
        temp = game.back();
        game.pop_back();
        while (temp.first > 0) {
            if (loser[t] == 0) {
                loser[t] = temp.second;
                temp.first--;
            }
            t++;
        }
    }

    for (int i = 0; i < sum/2; i++)
        printf("%d %d\n", winner[i], loser[i]);

    return 0;
}

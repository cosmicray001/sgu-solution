/* SGU ID:  #138
 * Type  :  
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

    pair<int, int> winner, loser;
    while (!game.empty()) {
        sort(game.begin(), game.end(), cmp);
        winner = game.back();
        game.pop_back();
        loser = game.back();
        game.pop_back();
        for (int i = 0; i < winner.first - 1; i++) {
            //winner always wins
            printf("%d %d\n", winner.second, loser.second);
            if (--loser.first == 0 && !game.empty()) {
                loser = game.back();
                game.pop_back();
            }
        }
        //winner finally loses
        game.push_back(loser);
        sort(game.begin(), game.end(), cmp);
        loser = game.back();
        game.pop_back();
        printf("%d %d\n", loser.second, winner.second);
        if (--loser.first == 0 && !game.empty()) {
                loser = game.back();
                game.pop_back();
            }

        if (loser.first > 0)
            game.push_back(loser);
    }

    return 0;
}

/* SGU ID:  #114
 * Type  :  Mathematics
 * Author:  Hangchen Yu
 * Date  :  01/24/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

using namespace std;

int main() {
    int n;
    scanf("%d", &n);
    pair<double, double> city;
    vector<pair<double, double> > cities;

    long sum = 0;
    for (int i = 0; i < n; i++) {
        scanf("%lf%lf", &city.first, &city.second);
        cities.push_back(city);
        sum += city.second;
    }

    //sort the coordinates
    sort(cities.begin(), cities.end());

    //initial
    double now = 0;
    for (int i = 0; i < n; i++)
        now += (cities[i].first - cities[0].first) * cities[i].second;
    double best = now, best_x = cities[0].first;
    double previous = 0;    //sum of previous cities

    for (int i = 1; i < n; i++) {
        previous += cities[i-1].second;
        now = now + (cities[i].first-cities[i-1].first) * (previous-(sum-previous));
        if (now < best) {
            best = now;
            best_x = cities[i].first;
        }
    }

    printf("%.5lf\n", best_x);

    return 0;
}

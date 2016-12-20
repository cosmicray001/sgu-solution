/* SGU ID:  #119
 * Type  :  Mathematics 
 * Author:  Hangchen Yu
 * Date  :  01/26/2015
 */
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <vector>
#include <utility>
#include <cmath>

using namespace std;

bool cmp(pair<long, long> x, pair<long, long> y) {
    if (x.first < y.first || x. first == y.first && x.second < y.second)
	return true;
    return false;
}

int main() {
    long n, a, b;
    scanf("%ld%ld%ld", &n, &a, &b);

    vector<pair<long, long> > list;
    pair<long, long> p;
    for (int i = 0; i < n; i++) {
	p.first = (a*i)%n;
	p.second = (b*i)%n;
	list.push_back(p);
    }

    sort(list.begin(), list.end(), cmp);

    vector<pair<long, long> >::iterator iter;
    for (iter = list.begin(); (iter+1) != list.end();)
	if (iter->first == (iter+1)->first && iter->second == (iter+1)->second) {
	    iter = list.erase(iter);
//	    printf("%d %ld %ld\n", list.size(), list.end(), iter);
	}
	else
	    iter++;

    printf("%d\n", list.size());
    for (int i = 0; i < list.size(); i++)
	printf("%ld %ld\n", list[i].first, list[i].second);

    return 0;
}

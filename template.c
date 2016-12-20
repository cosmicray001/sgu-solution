// sgu156
const int Debug = 1;
/*
 * SOUR:
 * ALGO:
 * DATE:2011 6月06 13时20分47秒
 * COMM:
 * */
#include<iostream>
#include<cstdio>
#include<cstdlib>
#include<cstring>
#include<algorithm>
#include<cassert>
#include<list>
#include<cmath>
#include<queue>
#include<vector>
#include<map>
#include<stack>
#include<set>
using namespace std;
#define pb(x) push_back(x)
#define fi first
#define se second
#define rab(i,a,b) for(int i(a), _n(b); i <= (_n); i++)
#define rep(i,n) rab(i,0,(n)-1)

typedef std::vector < int >vi;
typedef std::pair < int, int > pii;
typedef unsigned int uint;
typedef long long LL;

template <class T> void ckmin(T &a,T b) { if (a > b) { a = b; } }
template <class T> void ckmax(T &a,T b) { if (a < b) { a = b; } }
template <class T> void pr(T &a) { cout << a << ' '; }
template <class T> void print(T &a) { a.__str__(); }
template <class T> int size(const vector<T> &v) { return (int)v.size(); }
#define fpr(...) \
    fprintf(stderr, "%s(%d)-%s: ",__FILE__,__LINE__,__FUNCTION__); \
    fprintf(stderr, __VA_ARGS__);fprintf(stderr, "\n");
int countbit(int n) { return n == 0 ? 0 : 1 + countbit(n & (n - 1)); } 
const int maxint = 0x7fffffff;
const long long max64 = 0x7fffffffffffffffll;
/*Every problem has a simple, fast and wrong solution.*/
/*std::ios::sync_with_stdio(false);*/

    return 0;
}

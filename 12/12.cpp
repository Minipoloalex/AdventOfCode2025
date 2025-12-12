#include <bits/stdc++.h>
using namespace std;

const int N = 6;

void solve() {
    vector<vector<string>> shapes(N, vector<string>(3));
    array<int,N> total{};
    for (int i = 0; i < N; i++) {
        string trash; cin >> trash;
        for (int j = 0; j < 3; j++) {
            string line;
            cin >> line;
            shapes[i][j] = line;
            total[i] += int(count(shapes[i][j].begin(), shapes[i][j].end(), '#'));
        }
    }
    cin.ignore();
    int ans = 0;
    string line;
    while (getline(cin, line)) {
        if (line == "") continue;
        istringstream iss(line);
        int w, h;
        char c;
        array<int,N> cnt;
        iss >> w >> c >> h >> c;
        int mn = 0, mx = 0;
        for (int i = 0; i < N; i++) {
            iss >> cnt[i];
            mx += cnt[i] * 9;
            mn += cnt[i] * total[i];
        }
        int sz = w * h;
        if (sz >= mx) {
            ans++;  // fits
        }
        else if (sz < mn) {
            // no fits
        }
        else {
            // unknown
            cout << w << " " << h << endl;
            for (int i = 0; i < N; i++) cout << cnt[i] << " \n"[i == N-1];
        }
    }
    cout << ans << '\n';
}

int main() {
    cin.tie(0)->ios::sync_with_stdio(0);
    int t = 1;
    // cin >> t;
    while (t--) {
        solve();
    }
    return 0;
}

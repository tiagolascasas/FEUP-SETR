#include <chrono>
#include <thread>
#include <iostream>

using namespace std;

static void test()
{
    cout << "TEST" << endl;
}

static float timer_monotonic()
{
    typedef chrono::duration<float> fsec;
    float now = chrono::duration_cast<fsec>(chrono::steady_clock::now().time_since_epoch()).count();
    return now;
}

int main()
{
    float t1 = timer_monotonic();
    chrono::milliseconds timespan(12); // or whatever
    this_thread::sleep_for(timespan);
    float t2 = timer_monotonic();
    cout << t1 << " - > " << t2 << endl;
    cout << t2 - t1 << endl;
    return 0;
}
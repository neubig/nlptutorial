#include <iostream>
using namespace std;

int add_and_abs(int x, int y) {
    int z = x + y;
    if(z >= 0)
        return z;
    else
        return z * -1;
}

int main(int argc, char** argv) {
    cout << add_and_abs(-4, 1) << endl;
}

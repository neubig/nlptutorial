#include <iostream>
#include <vector>
#include <boost/foreach.hpp>
using namespace std;

int main(int argc, char** argv) {
    vector<int> my_list(5);
    my_list[0] = 1;
    my_list[1] = 2;
    my_list[2] = 4;
    my_list[3] = 8;
    my_list[4] = 16;

    my_list.push_back(32);

    cout << my_list.size() << endl;

    cout << my_list[3] << endl << endl;

    BOOST_FOREACH(int value, my_list) {
        cout << value << endl;
    }

}

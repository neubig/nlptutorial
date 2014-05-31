#include <iostream>
#include <string>
using namespace std;

int main(int argc, char** argv) {
    int my_variable = 5;

    if(my_variable == 4) {
        cout << "my_variable is 4" << endl;
    } else {
        cout << "my_variable is not 4" << endl;
    }

    for(int i = 1; i < 5; i++) {
        cout << "i == " << i << endl;
    }

}

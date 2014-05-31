#include <iostream>
#include <fstream>
using namespace std;

int main(int argc, char** argv) {
    ifstream my_file(argv[1]);
    string line;
    while(getline(my_file, line)) {
        if(line.length() != 0) {
            cout << line << endl;
        }
    }
}

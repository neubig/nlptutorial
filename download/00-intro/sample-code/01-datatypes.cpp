#include <iostream>
#include <string>
using namespace std;

int main(int argc, char** argv) {
    int my_int = 4;
    double my_float = 2.5;
    string my_string = "hello";
    
    cout << "string: " << my_string    // Print the string
         << "\tfloat: " << my_float    // Print the float
         << "\tint: " << my_int        // Print the int
         << endl;                      // Print the end of the line
}

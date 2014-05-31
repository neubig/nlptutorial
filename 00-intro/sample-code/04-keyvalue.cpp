#include <iostream>
#include <string>
#include <boost/tr1/unordered_map.hpp>
#include <boost/foreach.hpp>
using namespace std;
using namespace std::tr1;

int main(int argc, char** argv) {
    unordered_map<string,int> my_dict;
    my_dict["alan"] = 22;
    my_dict["bill"] = 45;
    my_dict["chris"] = 17;
    my_dict["dan"] = 27;

    my_dict["eric"] = 33;

    cout << my_dict.size() << endl;

    cout << my_dict["chris"] << endl << endl;

    // Boost foreach can not use pairs directly, so we must define a type
    // StringIntPair
    typedef pair<string,int> StringIntPair;

    BOOST_FOREACH(StringIntPair key_value, my_dict) {
        cout << key_value.first << " --> " << key_value.second << endl;
    }

}

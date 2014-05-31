#include <iostream>
#include <string>
#include <vector>
#include <boost/algorithm/string.hpp>
#include <boost/foreach.hpp>
using namespace std;
using namespace boost;

int main(int argc, char** argv) {

    string sentence = "this is a pen";
    vector<string> words;
    split(words, sentence, is_any_of(" "));

    BOOST_FOREACH(string word, words) {
        cout << word << endl;
    }

    cout << boost::algorithm::join(words, " ||| ") << endl;

}

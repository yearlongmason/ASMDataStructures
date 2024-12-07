// main.cpp
// Mason Lee

#include <iostream>
#include <cstdlib> // Included for malloc
#include <fstream>
#include <string>
using namespace std;

extern "C" void _partOne();
extern "C" void _partTwo();
extern "C" void _addNode(long long int, long long int);

extern "C" double _getDouble() {
    double d;
    cin >> d;
    return d;
}

extern "C" void _printString(char* s) {
    cout << s;
    return;
}

extern "C" void _printInt(int i) {
    cout << i << " ";
}

extern "C" void _printLongLong(long long int i) {
    cout << i << " ";
}

extern "C" void _printNewLine() {
    cout << std::endl;
}

extern "C" long long int _getFish(long long int headNode) {
    
    // Open Advent of Code input file
    ifstream fin;
    fin.open("lanternfish.txt");

    long long int currentData;
    long long int length = 0;
    char junk;

    // If unable to open, alert the user and return
    if (fin.fail())
    {
        cout << "Unable to open file!" << endl;
        return 0;
    }

    // Loop through the file until we reach the end
    while (!fin.eof()) {
        fin >> currentData;
        // Because each number is separated by a comma we have to get rid of it with a junk variable
        fin >> junk; 

        // Add node to linked list for every value
        _addNode(headNode, currentData);
        length++;
    }

    return length;
}

// main stub driver
int main() {
    _partOne();
    _partTwo();
    return 0;
}
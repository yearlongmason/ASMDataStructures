// main.cpp
// Mason Lee

#include <iostream>
#include <cstdlib> // Included for malloc
#include <fstream>
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

extern "C" void _printNewLine() {
    cout << std::endl;
}

extern "C" long long int _getData(long long int headNode) {
    
    // Open Advent of Code input file
    ifstream fin;
    fin.open("SonarSweepDepths.txt");

    long long int currentData;
    long long int length = 0;

    // If unable to open, alert the user and return
    if (fin.fail())
    {
        cout << "Unable to open file!" << endl;
        return 0;
    }

    // Get all data in the file
    while (fin >> currentData) {
        // Add new data as a node to the depths linked list
        _addNode(headNode, currentData);
        length++;
    }

    fin.close();

    return length;
}

// main stub driver
int main() {
    _partOne();
    _partTwo();
    return 0;
}
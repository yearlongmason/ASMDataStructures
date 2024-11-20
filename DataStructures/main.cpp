// main.cpp
// Mason Lee

#include <iostream>
#include <cstdlib> // Included for malloc

extern "C" void _asmMain();

extern "C" double _getDouble() {
    double d;
    std::cin >> d;
    return d;
}

extern "C" void _printString(char* s) {
    std::cout << s;
    return;
}

extern "C" void _printInt(int i) {
    std::cout << i << " ";
}

extern "C" void _printNewLine() {
    std::cout << std::endl;
}

// main stub driver
int main() {
    _asmMain();
    return 0;
}
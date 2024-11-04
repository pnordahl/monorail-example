#include "hello.h"
#include <cassert>
#include <sstream>
#include <iostream>

void testSayHello() {
    // Redirect output to a string stream to test it
    std::ostringstream buffer;
    std::streambuf* oldCoutBuffer = std::cout.rdbuf(buffer.rdbuf());

    sayHello();

    std::cout.rdbuf(oldCoutBuffer); // Restore original cout buffer

    // Check if the output is as expected
    assert(buffer.str() == "Hello, World!\n");
    std::cout << "Test passed!" << std::endl;
}

int main() {
    testSayHello();
    return 0;
}
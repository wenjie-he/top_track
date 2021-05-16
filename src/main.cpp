#include <iostream>

#include "src/top.h"
#include "interface.h"

int main() {
    TopTrack::Top top;
    invention::Interface interface;

    std::cout << "a : " << top.get_top() << std::endl;
}

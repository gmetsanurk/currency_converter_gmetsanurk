//
//  SomeCppClass.cpp
//  CurexConverter-ObjC
//
//  Created by roman podymov on 09.03.2025.
//

#include "SomeCppClass.hpp"

#include <string>

const void* fff(void) {
    std::string s = "Hello";
    std::string s2 = "World";
    return (s + s2).c_str();
}

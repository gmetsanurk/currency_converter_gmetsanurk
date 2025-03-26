//
//  SomeCppClass.cpp
//  CurexConverter-ObjC
//
//  Created by roman podymov on 09.03.2025.
//

#include "SomeCppClass.hpp"

#include <fstream>
#include <string>
#include <iostream>

class Translator {
public:
    void open(const char* filename) {
        // TODO
    }
    const void* translate(TranslationKey key) {
        // TODO
        return nullptr;
    }
    
private:
    std::fstream file;
};

Translator translator;

const void* translate(TranslationKey key, const char* filename) {
    return translator.translate(key);
}

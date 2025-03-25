//
//  SomeCppClass.hpp
//  CurexConverter-ObjC
//
//  Created by roman podymov on 09.03.2025.
//

#ifndef SomeCppClass_hpp
#define SomeCppClass_hpp

#include <CoreFoundation/CFBase.h>

CF_EXTERN_C_BEGIN

union Some {
    char a;
    char b[10];
};

typedef enum {
    TranslationKeySome
} TranslationKey;

const void* translate(TranslationKey key);

CF_EXTERN_C_END

#endif /* SomeCppClass_hpp */

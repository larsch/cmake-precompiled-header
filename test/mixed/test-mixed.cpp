#include "test-pch.h"
#ifndef PCH
#error Missing precompiled header
#endif
extern "C" int c_main(void);
int main() { return !(PCH == 1) + c_main(); }

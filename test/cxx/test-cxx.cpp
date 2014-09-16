#include "test-pch.h"
#ifndef PCH
#error Missing precompiled header
#endif
int main() { return !(PCH == 1); }

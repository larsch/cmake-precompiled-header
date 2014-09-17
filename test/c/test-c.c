#include "test-pch.h"
#ifndef PCH
#error Missing precompiled header
#endif
int main() { return !(PCH == atoi(getenv("EXPECTED_PCH"))); }

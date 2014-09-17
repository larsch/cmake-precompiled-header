#include "test-pch.h"
#ifndef PCH
#error Missing precompiled header
#endif
int c_main(void) { return !(PCH == atoi(getenv("EXPECTED_PCH"))); }

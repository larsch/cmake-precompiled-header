#ifndef PCH
#error Missing precompiled header
#endif
extern "C" int c_main(void);
int main() { return !(PCH == atoi(getenv("EXPECTED_PCH"))) + c_main(); }

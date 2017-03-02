# cmake-precompiled-header

Precompiled header setup for CMake. Supported CMake generators:

  * Visual Studio
  * NMake Makefiles
  * Unix Makefiles (GCC)
  * MinGW Makefiles
  * MSYS Makefiles
  * Ninja

# Usage

Create a `pchheader.{c,cpp}` and `pchheader.h` and add then to the CMake target:

```cmake
add_library(target ... pchheader.cpp pchheeader.h)
```

`pchheader.h` can include all the huge header files that are used everywhere in your project:

```c
#include <string>
#include <iostream>
#include <list>
#include <map>
```

`pchheader.{c,cpp}` should just include the header file:

```c
#include "pchheader.h"
```

In your main `CMakeLists.txt`, include the macro file:

```cmake
include(PrecompiledHeader.cmake)
```

Then add this line, to set up precompiled headers:

```cmake
add_precompiled_header(target pchheader.h FORCEINCLUDE)
```

Additional documentation is in [PrecompiledHeader.cmake](PrecompiledHeader.cmake).

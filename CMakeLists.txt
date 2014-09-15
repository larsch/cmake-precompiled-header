cmake_minimum_required(VERSION 2.8)
project(PrecompiledHeader)
include(PrecompiledHeader.cmake)

add_library(test1 test1.cpp testpch.cpp)
add_precompiled_header(test1 testpch.h FORCEINCLUDE)

add_library(test2 test2.cpp testpch.cpp)
add_precompiled_header(test2 testpch.h)

@echo off
setlocal enableextensions enabledelayedexpansion
set PATH=%SystemRoot%\System32;c:\appl\MinGW\bin;C:\Program Files (x86)\CMake 2.8\bin

set buildroot=%~dp0build
pushd test
for /d %%i in (*) do (
  call :runtest %%i
  if errorlevel 1 goto :eof
)
goto :eof

:runtest
call :runtest2 %1 "Visual Studio 10"
if errorlevel 1 exit /b 1
call :runtest2 %1 "MinGW Makefiles"
if errorlevel 1 exit /b 1
goto :eof

:runtest2
set test=%~1
set testdir=%~dp0test\%test%
set generator=%~2
set source=%buildroot%\%test%-%generator%-src
set build=%buildroot%\%test%-%generator%-build
if exist "%build%" rmdir /q/s "%build%"
if exist "%source%" rmdir /q/s "%source%"
mkdir "%source%"
xcopy /Q/S "%testdir%" "%source%"
mkdir "%build%"
pushd "%build%"
cmake -G "%generator%" "%source%"
if errorlevel 1 goto :eof

:: Save a copy of the PCH for later (with old timestamp)
copy "%source%\test-pch.h" "%source%\test-pch-old.h"

:: Build and test (checking that basics work).
cmake --build .
if errorlevel 1 goto :eof
set EXPECTED_PCH=1
ctest
if errorlevel 1 goto :eof

:: Update PCH, build and test (checking that dependencies work).
timeout /T 2 /NOBREAK
echo #undef PCH >> "%source%\test-pch.h"
echo #define PCH 2 >> "%source%\test-pch.h"
cmake --build .
if errorlevel 1 goto :eof
set EXPECTED_PCH=2
ctest
if errorlevel 1 goto :eof

:: Replace PCH with old version (with old timestamp), make sure that
:: we recompile, then build and test (checking that we are using
:: actually precompiled header, not the original header).
copy "%source%\test-pch-old.h" "%source%\test-pch.h"
echo.>> "%source%\%test.c"
echo.>> "%source%\%test.cpp"
cmake --build .
if errorlevel 1 goto :eof
set EXPECTED_PCH=2
ctest
if errorlevel 1 goto :eof

popd

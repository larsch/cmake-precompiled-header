@echo off
setlocal enableextensions enabledelayedexpansion
set PATH=%SystemRoot%\System32;c:\appl\MinGW\bin;C:\Program Files\CMake\bin;c:\appl\tools\bin
set buildroot=%~dp0build

call :runtest %1 "Visual Studio 14 2015"
if errorlevel 1 exit /b 1

call :runtest %1 "MinGW Makefiles"
if errorlevel 1 exit /b 1

call :runtest %1 "Ninja"
if errorlevel 1 exit /b 1

setlocal
call "%VS140COMNTOOLS%\vsvars32.bat"
call :runtest %1 "NMake Makefiles"
if errorlevel 1 exit /b 1
endlocal

goto :eof

:runtest
echo ******************************************************************************
echo RUNTEST %1 %2
echo ******************************************************************************
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
if errorlevel 1 exit /b 1

:: Save a copy of the PCH for later (with old timestamp)
copy "%source%\test-pch.h" "%source%\test-pch-old.h"

:: Build and test (checking that basics work).
cmake --build .
if errorlevel 1 exit /b 1
set EXPECTED_PCH=1
ctest
if errorlevel 1 exit /b 1

:: Update PCH, build and test (checking that dependencies work).
timeout /T 2 /NOBREAK
echo #undef PCH >> "%source%\test-pch.h"
echo #define PCH 2 >> "%source%\test-pch.h"
cmake --build .
if errorlevel 1 goto :eof
set EXPECTED_PCH=2
ctest
if errorlevel 1 exit /b 1

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
if errorlevel 1 exit /b 1

echo DONE TESTING

popd

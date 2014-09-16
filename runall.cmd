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
xcopy /S "%testdir%" "%source%"
mkdir "%build%"
pushd "%build%"
cmake -G "%generator%" "%source%"
if errorlevel 1 goto :eof
cmake --build .
if errorlevel 1 goto :eof
ctest
if errorlevel 1 goto :eof
popd
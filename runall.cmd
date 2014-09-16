@echo off
setlocal enableextensions enabledelayedexpansion
set PATH=c:\appl\MinGW\bin;C:\Program Files (x86)\CMake 2.8\bin
call "%VS100COMNTOOLS%\vsvars32.bat"

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
set testdir=%~dp0test/%test%
set generator=%~2
set build=%buildroot%\%test%\%generator%
echo "%build%"
if exist "%build%" rmdir /q/s "%build%"
mkdir "%build%"
pushd "%build%"
cmake -G "%generator%" "%testdir%"
if errorlevel 1 goto :eof
cmake --build .
if errorlevel 1 goto :eof
popd
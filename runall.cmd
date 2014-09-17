@echo off
setlocal enableextensions enabledelayedexpansion

pushd test
for /d %%i in (*) do (
  call runtest %%i
  if errorlevel 1 goto :eof
)
goto :eof

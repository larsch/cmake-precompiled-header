@echo off
setlocal enableextensions enabledelayedexpansion
set runtest=%cd%\runtest.cmd

pushd test
for /d %%i in (*) do (
  call "%runtest%" %%i
  if errorlevel 1 goto :eof
)
goto :eof

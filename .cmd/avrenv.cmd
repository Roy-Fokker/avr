@echo off

echo Look for avr-g++
where /q avr-g++
if errorlevel 1 (
    goto setpath
) else (
    goto quit
)

:setpath
echo Set path to AVR toolchain
set PATH=%PATH%;E:\Programming\Tools\avr-gcc-8.1.0-x64-mingw\bin

:quit
exit /b
@echo off

call %~dp0%\avrenv.cmd

:checkBuildDir
if not exist build\ (
    echo Make build directory
    mkdir build
) else (
    echo Clean build directory
    del build\*.* /Q/F
)

:makeBuild
for %%* in (.) do set CurrDirName=%%~nx*
echo Do the build for %CurrDirName%

avr-g++ -std=c++17 -mmcu=atmega328p -Wall -Os -fno-exceptions -fno-asynchronous-unwind-tables -fno-rtti -o build/%CurrDirName%.elf %*
avr-objcopy -j .text -j .data -O ihex build/%CurrDirName%.elf build/%CurrDirName%.hex
avr-size build/%CurrDirName%.elf build/%CurrDirName%.hex

:quit
exit /b


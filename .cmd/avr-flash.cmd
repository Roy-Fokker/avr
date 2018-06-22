@echo off

echo Look for avrdude
where /q avrdude
if errorlevel 1 (
    goto setpath
) else (
    goto checkBuildDir
)

:setpath
echo Set path to AVR toolchain
set PATH=%PATH%;E:\Programming\Tools\avr-gcc-8.1.0-x64-mingw\bin

for %%* in (.) do set CurrDirName=%%~nx*

:checkBuildDir
echo Look for .hex file
if not exist build\%CurrDirName%.hex (
    echo %CurrDirName%.hex not found
    goto quit
) 

:doFlash
echo Flash .hex file
avrdude -c arduino -p atmega328p -P COM4 -b 115200 -U flash:w:"build\%CurrDirName%.hex":a -v

:quit
exit /b


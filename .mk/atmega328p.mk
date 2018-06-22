# Define AVR Board properties
MCU ?= atmega328p
# used by gcc in flag -DF_CPU
CLOCK ?= 16000000UL
# used by avrdude
COM_PORT ?= COM4
# used by avrdude
BAUD_RATE ?= 115200
# used by avrdude
PROGRAMMER ?= arduino

# Define AVR Board fuses and lock bits
# https://www.engbedded.com/fusecalc/
LFUSE ?= 0x00
HFUSE ?= 0x00
EFUSE ?= 0x00
LOCKBIT ?= 0x00
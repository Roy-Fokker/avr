# Define project properties
TARGET = example

LANG = c
SRC_DIR = ./
BIN_DIR = build
OBJ_DIR = obj

include ..\.mk\atmega328p.mk
include ..\.mk\avr-toolchain.mk


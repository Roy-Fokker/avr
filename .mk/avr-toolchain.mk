# Define toolchain
	# Toolchain Name and Version
TC_NAME = 'AVR-GCC 8.1.0'
	# Toolchain Root Directory
TC_DIR = e:/Programming/Tools/avr-gcc-8.1.0-x64-mingw

	# Toolchain binaries directory
TC_BIN_DIR = $(TC_DIR)/bin
	# Toolchain library directory
TC_LIB_DIR = $(TC_DIR)/avr/lib
	# Toolchain includes directory
TC_INC_DIR = $(TC_DIR)/avr/include

	# C++ compiler
CXX = $(TC_BIN_DIR)/avr-g++
	# C compiler
CC = $(TC_BIN_DIR)/avr-gcc
OBJCOPY = $(TC_BIN_DIR)/avr-objcopy 
OBJDUMP = $(TC_BIN_DIR)/avr-objdump
SIZE = $(TC_BIN_DIR)/avr-size
NM = $(TC_BIN_DIR)/avr-nm
	# AVR Dude to copy to board
AVRDUDE = $(TC_BIN_DIR)/avrdude

# Define Compiler Flags
DEFINES = -DF_CPU=$(CLOCK)
WARNINGS = -Wall

CFLAGS = -c -std=c11 -mmcu=$(MCU) -Os $(DEFINES) $(WARNINGS)
CXXFLAGS = -c -std=c++17 -mmcu=$(MCU) -Os $(DEFINES) $(WARNINGS)

# Define Linker Flags
LDFLAGS = -mmcu=$(MCU) -Os $(DEFINES) $(WARNINGS) -Wl,-Map,$(BIN_DIR)/$(TARGET).map 

# Define ELF -> HEX FLAGS
OCFLAGS = -j .text -j .data -O ihex 

# Define NM Flags
NMFLAGS = --print-size --size-sort --reverse-sort --radix=d --format=s

# Define AVRDUDE flags
AVRFLAGS = -c $(PROGRAMMER) -p $(MCU) -P $(COM_PORT) -b $(BAUD_RATE) -v

# Define common SHELL/Filesystem tools
SHELL = cmd				# Windows Shell
#REMOVE = del /Q/F		# Delete file, quiet, forced
ESC = 					# Escape char

# Define messages
MSG_TC_VERSION:
	@echo $(ESC)[1;33m$(TC_NAME)$(ESC)[0m 
	@if exist $(TC_NAME) then 

MSG_COMPILE:
	@echo $(ESC)[1;33mCompiling [$(SRC_FILES)] in $(SRC_DIR)$(ESC)[0m \

MSG_OBJ_ELF:
	@echo $(ESC)[1;33mLinking [$(OBJ_FILES)] files into $(TARGET).ELF $(ESC)[0m \

MSG_ELF_HEX:
	@echo $(ESC)[1;33mCopying $(TARGET).ELF to HEX$(ESC)[0m \

MSG_ELF_LSS:
	@echo $(ESC)[1;33mCopying $(TARGET).ELF to LSS$(ESC)[0m \

MSG_ELF_SIZE:
	@echo $(ESC)[1;33mPrint $(TARGET).ELF size$(ESC)[0m \

MSG_FLASH_HEX:
	@echo $(ESC)[1;33mFlashing HEX to $(MCU)$(ESC)[0m \

MSG_FLASH_FUSE:
	@echo $(ESC)[1;33mFlashing Fuses on $(MCU)$(ESC)[0m \

MSG_CLEAN:
	@echo $(ESC)[1;33mClean project$(ESC)[0m \

# Make commands 
SRC_FILES ?= $(wildcard $(SRC_DIR)/*.$(LANG))
OBJ_FILES := $(patsubst $(SRC_DIR)/%.$(LANG),$(OBJ_DIR)/%.o,$(SRC_FILES))

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -o $@ $^

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -o $@ $^

$(OBJ_DIR): 
	@if not exist  $(OBJ_DIR) mkdir $(OBJ_DIR)

$(BIN_DIR): 
	@if not exist  $(BIN_DIR) mkdir $(BIN_DIR)

$(TARGET).elf: $(OBJ_FILES)
	$(CC) $(LDFLAGS) -o $(BIN_DIR)/$@ $^

$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) $(OCFLAGS) $(BIN_DIR)/$< $(BIN_DIR)/$@

# Build the project 
all: MSG_TC_VERSION compile link convert size

compile: MSG_COMPILE $(OBJ_DIR) $(OBJ_FILES)

link: MSG_OBJ_ELF $(BIN_DIR) $(TARGET).elf
	
convert: MSG_ELF_HEX $(BIN_DIR) $(TARGET).hex 
	
size: MSG_ELF_SIZE 
	$(SIZE) $(BIN_DIR)/$(TARGET).elf $(BIN_DIR)/$(TARGET).hex 
	$(NM) $(BIN_DIR)/$(TARGET).elf $(NMFLAGS)

# Clean all generated files
clean: MSG_CLEAN
	@if exist $(BIN_DIR) rmdir /q/s $(BIN_DIR)
	@if exist $(OBJ_DIR) rmdir /q/s $(OBJ_DIR)

# Flash to Board
install: MSG_FLASH_HEX
	$(AVRDUDE) $(AVRFLAGS) -U flash:w:"$(BIN_DIR)/$(TARGET).hex":a

# Flash fuses
flash_fuse:
	$(MSG_FLASH_FUSE)

.PHONY: all, size, clean, install, flash_fuse

# Compiler
CC = sdcc
# Compiler flags
CFLAGS = -mmcs51 --model-small

# Directories
SRCDIR = src
BINDIR = bin

# Files
SRC = $(wildcard $(SRCDIR)/*.c)
OBJ = $(patsubst $(SRCDIR)/%.c,$(BINDIR)/%.rel,$(SRC))

# Target executable
TARGET = $(BINDIR)/main.ihx

# Conditional Variables
ifeq ($(OS),Windows_NT)
    RM = del /f /q
    MKDIR = mkdir
    FLASH_TOOL = stcgal.exe
    PORT = COM14
else
    RM = rm -f
    MKDIR = mkdir -p
    FLASH_TOOL = stcgal
    PORT = /dev/ttyUSB0
endif

# Build rule
$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o $@

# Object files rule
$(BINDIR)/%.rel: $(SRCDIR)/%.c
	$(MKDIR) $(BINDIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Flash rule
flash: $(TARGET)
	$(FLASH_TOOL) -p $(PORT) -b 115200 -t 5000 $(TARGET)

# Clean rule for Windows
clean:
	$(RM) $(BINDIR)\*
	-rmdir /s /q $(BINDIR)

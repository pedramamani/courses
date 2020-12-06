DEV	= msp430g2553  # Board model for choosing include file
DIR	= $(HOME)/ti/msp430_gcc  # Board libraries directory

GCC_DIR = $(DIR)/bin
INC_DIR = $(DIR)/include

GCC     = $(GCC_DIR)/msp430-elf-gcc  # Using gcc compiler
FLAGS	= -Wall -I $(INC_DIR) -mmcu=$(DEV) -O3 -L $(INC_DIR) -T $(DEV).ld  # Options, -Wall to show warnings

# Compile all .c files in current directory to an elf file
elf: $(wildcard *.c)
	$(GCC) $(FLAGS) -o $@ $^

clean:  # Clean directory by removing elf file
	rm -f elf

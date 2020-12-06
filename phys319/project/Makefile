DEV	= msp430g2553
DIR	= C:\SysGCC\msp430

GCC_DIR = $(DIR)\bin
INC_DIR = $(DIR)\include

GCC = $(GCC_DIR)\msp430-elf-gcc
FLAGS = -Wall -I $(INC_DIR) -mmcu=$(DEV) -O3 -L $(INC_DIR) -T $(DEV).ld

elf: $(wildcard *.c)
	$(GCC) $(FLAGS) -o $@ $^
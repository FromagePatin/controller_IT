CC=/opt/microchip/xc16/v2.00/bin/xc16-gcc


all: it_exemple

GCC_FLAGS= -S -Wall -O1

it_exemple: IT_exemple.c IT_controller.h Makefile
	$(CC) $(GCC_FLAGS) IT_exemple.c -o it_exemple.s
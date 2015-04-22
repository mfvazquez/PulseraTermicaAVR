EXE = ej1
MICRO = atmega8

all: elf hex

clean:
	rm $(EXE).hex $(EXE).o $(EXE).elf

elf:
	avr-gcc -Wall -g -mmcu=$(MICRO) $(EXE).S -o $(EXE).elf -Os

send:	hex
	sudo avrdude -c usbtiny -p m8 -U flash:w:$(EXE).hex:i

hex: $(EXE).o
	avr-objcopy -O ihex $(EXE).o $(EXE).hex

$(EXE).o: $(EXE).S
	avr-gcc -Wall -g -mmcu=$(MICRO) $(EXE).S -o $(EXE).o -Os

run: elf
	simulavr -d atmega8 -g $(EXE).elf

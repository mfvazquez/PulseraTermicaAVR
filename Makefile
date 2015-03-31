EXE = led

all: $(EXE)

$(EXE): $(EXE).S
	sudo avrdude -c usbtiny -p m8 -U lfuse:r:-:i -U hfuse:r:-:i
	avr-gcc -g -mmcu=atmega8 $(EXE).S -o $(EXE).o -Os
	avr-objcopy -O ihex $(EXE).o $(EXE).hex
	sudo avrdude -c usbtiny -p m8 -U flash:w:$(EXE).hex:i

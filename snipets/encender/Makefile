EXE = encender

all: $(EXE)

clean:
	rm $(EXE).hex $(EXE).o

$(EXE): $(EXE).S clean
	avr-gcc -g -mmcu=atmega8 $(EXE).S -o $(EXE).o -Os
	avr-objcopy -O ihex $(EXE).o $(EXE).hex
	sudo avrdude -c usbtiny -p m8 -U flash:w:$(EXE).hex:i

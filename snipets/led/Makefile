EXE = led

all: $(EXE)

clean:
	rm led.hex led.o

$(EXE): $(EXE).S clean
	avr-gcc -g -mmcu=atmega32 $(EXE).S -o $(EXE).o -Os
	avr-objcopy -O ihex $(EXE).o $(EXE).hex
	sudo avrdude -c usbtiny -p m32 -U flash:w:$(EXE).hex:i

EXE = pulsera
MICRO = atmega8

all: $(EXE).hex $(EXE).eep

clean:
	rm -f *.hex *.o *.elf *.eep

$(EXE).elf: $(EXE).S
	avr-gcc -Wall -g2 -gstabs -O0 -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -mmcu=$(MICRO) -MMD -MP -c -o $(EXE).elf $(EXE).S  -Wa,-as=$(EXE).syb

send:	hex
	sudo avrdude -c usbtiny -p m8 -U flash:w:$(EXE).hex:i

$(EXE).hex: $(EXE).elf
	avr-objcopy -R .eeprom -O ihex $(EXE).elf $(EXE).hex

$(EXE).eep: $(EXE).elf
	avr-objcopy -j .eeprom --no-change-warnings --change-section-lma .eeprom=0 -O ihex $(EXE).elf $(EXE).eep
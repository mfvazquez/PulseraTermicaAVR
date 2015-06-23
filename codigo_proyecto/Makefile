EXE = pulsera
MICRO = atmega8

MSG_EEPROM = Creating load file for EEPROM:
FORMAT = ihex


all: $(EXE).hex $(EXE).eep

clean:
	rm -f *.hex *.o *.elf *.eep *.d *.syb

$(EXE).elf: $(EXE).S
	#avr-gcc -Wall -g -g2 -gstabs -O0 -fpack-struct -fshort-enums -funsigned-char -funsigned-bitfields -mmcu=$(MICRO) -MMD -MP -c -o $(EXE).elf $(EXE).S  -Wa,-as=$(EXE).syb
	avr-gcc -Wall -Wextra -pedantic -g -mmcu=$(MICRO) $(EXE).S -o $(EXE).elf  -Wa,-as=$(EXE).syb #-O3

send:	$(EXE).hex $(EXE).eep
	sudo avrdude -c usbtiny -p m8 -U flash:w:$(EXE).hex:i

send_table:	$(EXE).hex $(EXE).eep
	sudo avrdude -c usbtiny -p m8 -U flash:w:$(EXE).hex:i -U eeprom:w:$(EXE).eep:i
	
$(EXE).hex: $(EXE).elf
	avr-objcopy -O ihex $(EXE).elf $(EXE).hex

#$(EXE).eep: $(EXE).elf
#	avr-objcopy -j .eeprom --no-change-warnings --change-section-lma .eeprom=0 -O ihex $(EXE).elf $(EXE).eep

show_size: $(EXE).elf
	avr-size --format=avr --mcu=atmega8 $(EXE).elf 


$(EXE).eep: $(EXE).elf
	@echo
	@echo $(MSG_EEPROM) $@
	-avr-objcopy -j .eeprom --set-section-flags=.eeprom="alloc,load" \
	--change-section-lma .eeprom=0 -O $(FORMAT) $< $@

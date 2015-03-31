#include <avr/io.h>

.global main

main:
	sbi		_SFR_IO_ADDR(DDRB),3
	cbi		_SFR_IO_ADDR(PORTB),3
	;sbi		_SFR_IO_ADDR(PORTB),3

end:
	rjmp	end

.end

#include <avr/io.h>

.global main

main:
	sbi		_SFR_IO_ADDR(DDRA),0
	cbi		_SFR_IO_ADDR(PORTA),0
	;sbi		_SFR_IO_ADDR(PORTB),3

end:
	rjmp	end

.end

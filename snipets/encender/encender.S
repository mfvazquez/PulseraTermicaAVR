#include <avr/io.h>

.global main

main:
	sbi		_SFR_IO_ADDR(DDRB),0
	sbi		_SFR_IO_ADDR(PORTB),0
dem: 
	clr r20

	
	
end:
	rjmp end
.end

#include <avr/io.h>

.section .text
.global main

main:

	rcall	USART_Init

	clr		r16

TRANSMIT_LOOP:
	rcall	USART_Transmit
	inc 	r16
	rjmp	TRANSMIT_LOOP

USART_Init:

	out 	_SFR_IO_ADDR(UBRRH), 	r17
	out 	_SFR_IO_ADDR(UBRRL), 	r16

	ldi 	r16, 	(1<<RXEN)|(1<<TXEN)
	out 	_SFR_IO_ADDR(UCSRB),	r16

	ldi 	r16, 	(1<<URSEL)|(1<<USBS)|(3<<UCSZ0)
	out 	_SFR_IO_ADDR(UCSRC),	r16
	
	ret

USART_Transmit:
	sbis 	_SFR_IO_ADDR(UCSRA),	UDRE
	rjmp 	USART_Transmit
	
	out 	UDR,	r16
	ret


.end
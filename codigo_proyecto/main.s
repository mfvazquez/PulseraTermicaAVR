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

	out 	UBRRH, 	r17
	out 	UBRRL, 	r16

	ldi 	r16, 	(1<<RXEN)|(1<<TXEN)
	out 	UCSRB,	r16

	ldi 	r16, 	(1<<URSEL)|(1<<USBS)|(3<<UCSZ0)
	out 	UCSRC,	r16
	
	ret

USART_Transmit:
	sbis 	UCSRA,	UDRE
	rjmp 	USART_Transmit
	
	out 	UDR,	r16
	ret


.end
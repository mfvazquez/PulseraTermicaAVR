#include <avr/io.h>

.section .text
.global main


main:

	rcall	USART_Init
	clr		r16


PWM:
	sbi  	_SFR_IO_ADDR(DDRD),		7	;Pin B1 (OC1A)	
	ldi		r16,	100					;Cambia cada 100 cuentas
	out		_SFR_IO_ADDR(OCR1A),	r16	;Seteo el valor
	ldi		r16,	0x19				;0x19 	(00011001)
	out 	_SFR_IO_ADDR(TCCR1A),	r16	;Seteo el modo en toggle, ctc, no prescalar
SEND_LOOP:
	rjmp	SEND_LOOP




TRANSMIT_LOOP:
	rcall	USART_Transmit
	inc 	r16
	rjmp	TRANSMIT_LOOP

USART_Init:

	clr		r17
	ldi		r16,	250

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
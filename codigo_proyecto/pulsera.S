#include <avr/io.h>

.section .text
.global main

main:

	rcall	USART_Init

	clr		r16

	sbi		_SFR_IO_ADDR(DDRB),0
	sbi		_SFR_IO_ADDR(PORTB),0 ;Prendo el led solo para verificar que este vivo

	rjmp TRANSMIT_LOOP

PWM:

	SBI _SFR_IO_ADDR(DDRB),3
	sbi _SFR_IO_ADDR(DDRD),6
	sbi _SFR_IO_ADDR(PORTD),6
	;rjmp H

	ldi r16 , 180
	out _SFR_IO_ADDR(OCR2),r16
	;ldi r16,0x76
	;out _SFR_IO_ADDR(TCNT2) ,r16
	ldi r16,0x76
	out _SFR_IO_ADDR(TCCR2) ,r16

H:
	rjmp H

TRANSMIT_LOOP:
	cbi		_SFR_IO_ADDR(PORTB),0
	rcall	USART_Transmit
	inc 	r16
	rjmp	TRANSMIT_LOOP

USART_Init:

	ldi 	r16, 	(1<<TXEN) ;enable
	out 	_SFR_IO_ADDR(UCSRB),	r16

	ldi 	r16, 	(1<<UCSZ1)|(1<<UCSZ0)|(3<<URSEL)
	out 	_SFR_IO_ADDR(UCSRC),	r16

	ldi	r16,	0x33 ;Baud 9600
	out 	_SFR_IO_ADDR(UBRRL),	r16

	ret

USART_Transmit:
	sbis 	_SFR_IO_ADDR(UCSRA),	UDRE
	rjmp 	USART_Transmit
	out 	_SFR_IO_ADDR(UDR),	r16
	ret
.end

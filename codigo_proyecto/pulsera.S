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


PWM_2:
	sbi  	_SFR_IO_ADDR(DDRD),		7	;Pin B1 (OC1A)	
	ldi		r16,	100					;Cambia cada 100 cuentas
	out		_SFR_IO_ADDR(OCR1A),	r16	;Seteo el valor
	ldi		r16,	0x19				;0x19 	(00011001)
	out 	_SFR_IO_ADDR(TCCR1A),	r16	;Seteo el modo en toggle, ctc, no prescalar
SEND_LOOP:
	rjmp	SEND_LOOP


TRANSMIT_LOOP:
	cbi		_SFR_IO_ADDR(PORTB),0
	rcall	USART_Transmit
	inc 	r16
	rjmp	TRANSMIT_LOOP

USART_Init:

	ldi		r17,	0x25
	ldi		r16,	0x80

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
	sbi		_SFR_IO_ADDR(PORTB),0
	out 	UDR,	r16
	ret
.end
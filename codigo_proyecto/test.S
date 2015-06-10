#include <avr/io.h>

.section .text
.global main

main:

	rcall	USART_Init
	clr		r16
	sbi _SFR_IO_ADDR(DDRB),3 ;(OC2) para salida
	clr		r16
	
	sbi		_SFR_IO_ADDR(DDRB),0
	sbi		_SFR_IO_ADDR(PORTB),0
	clr 	r20
	ldi		r21,	0xFF
	
	
	rjmp PWM

;------------------------------------------------------------------------------------

PWM:
	ldi r16 , 0xFF ;(10=180 cuentas)
	out _SFR_IO_ADDR(OCR2),r16
	;ldi r16,0x7
	;out _SFR_IO_ADDR(TCNT2) ,r16
	ldi r16,0x71 ;(01110001) Phase correct, no pre escalar, clear on match
	out _SFR_IO_ADDR(TCCR2) ,r16
	ldi r16 , 0xFF
	ldi		r17, 20
	ldi		r25, 	5

DEMORA:
	ldi r22, 0xFF
L1: 
	ldi r23, 0xFF
L2:
	ldi r24, 3
L3:
	nop
	nop
	dec 	r24
	brne 	L3
	dec 	R23
	brne 	L2
	dec		R22
	brne	L1

	eor		r20,	r21
	cpi		r20,	0
	breq	PRENDE	
	
APAGA:
	cbi		_SFR_IO_ADDR(PORTB),0
	rjmp		CAMBIO

PRENDE:
	sbi		_SFR_IO_ADDR(PORTB),0
	rjmp		CAMBIO

CAMBIO:
	sub r16, r17
	dec r25
	cpi r25, 0
	breq PWM
	out _SFR_IO_ADDR(OCR2),r16
	rcall USART_Transmit
	
	rjmp DEMORA


;------------------------------------------------------------------------------------

TRANSMIT_LOOP:
	rcall	USART_Transmit
	;ldi 	r16,0x55	
	inc 	r16
	rjmp	TRANSMIT_LOOP

;------------------------------------------------------------------------------------

USART_Init:
	ldi 	r16, 	(1<<TXEN) ;enable
	out 	_SFR_IO_ADDR(UCSRB),	r16

	ldi 	r16, 	(1<<URSEL)|(3<<UCSZ0)
	out 	_SFR_IO_ADDR(UCSRC),	r16

	ldi	r16,	0xC ;Baud 4800
	out 	_SFR_IO_ADDR(UBRRL),	r16

	ret

USART_Transmit:
	sbis 	_SFR_IO_ADDR(UCSRA), UDRE
	rjmp 	USART_Transmit

	out 	_SFR_IO_ADDR(UDR),	r16
	ret

;-----------------------------------------------------------------------------------

READ_ADC:
	ldi r16, 0b11000000  ; write zero
	out _SFR_IO_ADDR(ADMUX), r16  ; to ADMUX (select channel 0)
	ldi r16, 0b11101101  ; from left to right: ADC Enable, Start Conversion, Free-Running Mode, write
	out _SFR_IO_ADDR(ADCSR), r16  ; zero to ADC Int flag, enable int, prescaler: 101 for XTAL/32
 
	in r16, _SFR_IO_ADDR(ADCL)  ; get the last ADC result, low byte first,
	in r17, _SFR_IO_ADDR(ADCH)  ; then high byte
	lsr r17
	ror r16
	lsr r17
	ror r16
	

	rcall USART_Transmit
	rjmp READ_ADC

.end

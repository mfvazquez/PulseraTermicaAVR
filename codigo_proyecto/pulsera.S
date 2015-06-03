#include <avr/io.h>

.section .text
.global main

main:

	rcall	USART_Init

	clr		r16

	sbi _SFR_IO_ADDR(DDRB),3 ;(OC2) para salida


	clr		r16
	rjmp TRANSMIT_LOOP

;------------------------------------------------------------------------------------

PWM:
	ldi r16 , 180 ;(180 cuentas)
	out _SFR_IO_ADDR(OCR2),r16
	;ldi r16,0x7
	;out _SFR_IO_ADDR(TCNT2) ,r16
	ldi r16,0x71 ;(01110001) Phase correct, no pre escalar, clear on match
	out _SFR_IO_ADDR(TCCR2) ,r16

H:
	rjmp H

;------------------------------------------------------------------------------------

TRANSMIT_LOOP:
	rcall	USART_Transmit
	ldi 	r16,'C'	
	rjmp	TRANSMIT_LOOP

;------------------------------------------------------------------------------------

USART_Init:
	ldi 	r16, 	(1<<TXEN) ;enable
	out 	_SFR_IO_ADDR(UCSRB),	r16

	ldi 	r16, 	(1<<URSEL)|(1<<USBS)|(3<<UCSZ0)
	out 	_SFR_IO_ADDR(UCSRC),	r16

	ldi	r16,	0x33 ;Baud 9600
	out 	_SFR_IO_ADDR(UBRRL),	r16

	ret

USART_Transmit:
	sbis _SFR_IO_ADDR(UCSRA),UDRE
	rjmp USART_Transmit
	; Put data (r16) into buffer, sends the data
	out UDR,r16
	ret	

;-----------------------------------------------------------------------------------

READ_ADC:
	ldi r16, 0  ; write zero
	out _SFR_IO_ADDR(ADMUX), r16  ; to ADMUX (select channel 0)
	ldi r16, 0b11101101  ; from left to right: ADC Enable, Start Conversion, Free-Running Mode, write
	out _SFR_IO_ADDR(ADCSR), r16  ; zero to ADC Int flag, enable int, prescaler: 101 for XTAL/32
 
	in r16, _SFR_IO_ADDR(ADCL)  ; get the last ADC result, low byte first,
	in r17, _SFR_IO_ADDR(ADCH)  ; then high byte
	lsr r17
	ror r16
	lsr r17
	ror r16

	com r16 ; now invert result
	rcall USART_Transmit
	rjmp READ_ADC

.end

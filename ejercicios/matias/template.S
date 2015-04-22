#include <avr/io.h>

.section .text
.global main

;_SFR_IO_ADDR(DDRB)
;_SFR_IO_ADDR(PORTB)


main:
	clr 	r20
	ldi		r21,	0xFF

LOOP:
	eor		r20,	r21
	cpi		r20,	0
	breq	PRENDE

APAGA:
	cbi		_SFR_IO_ADDR(PORTB),0
	rjmp		DEMORA

PRENDE:
	sbi		_SFR_IO_ADDR(PORTB),0
	rjmp		DEMORA

DEMORA:
	ldi r22, 200
L1: 
	ldi r23, 0xFF
L2: 
	nop
	nop
	dec 	r23
	brne 	L2
	dec 	R22
	BRNE 	L1
	rjmp 	LOOP
	
.end



#include <avr/io.h>

.section .text
.global main

main:
	sbi		_SFR_IO_ADDR(DDRA),0
	sbi		_SFR_IO_ADDR(PORTA),0
	clr 	r20
	ldi		r21,	1

LOOP:	
	cpi		r20,	0
	breq	PRENDE

APAGA:
	sbi		_SFR_IO_ADDR(PORTA),0
	jmp		DEMORA

PRENDE:
	cbi		_SFR_IO_ADDR(PORTA),0
	jmp		DEMORA

DEMORA:
	ldi 	r22,	20	
	nop
LOOP_DEMORA:	
	dec		r22
	cpi		r22,	0
	brne	LOOP_DEMORA
	eor		r20,	r21
	jmp		LOOP
	

.end

#include <avr/io.h>

.global main

main:
	sbi		_SFR_IO_ADDR(DDRA),0
	sbi		_SFR_IO_ADDR(PORTA),0
	clr 	r20
	ldi		r21,	1
	rjmp	dem
loop:	
	cpi		r20,	0
	breq	prende
apaga:
	sbi		_SFR_IO_ADDR(PORTA),0
	rjmp	dem
prende:
	cbi		_SFR_IO_ADDR(PORTA),0
	rjmp	dem

dem:
	ldi 	r22,	200
dem_loop:
	
	dec		r22
	cpi		r22,	0
	brne	dem_loop
	eor		r20,	r21
	rjmp	loop
	

.end

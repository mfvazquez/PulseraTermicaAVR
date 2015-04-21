#include <avr/io.h>

#include "ej2.S"

.section .data

ENTRADA: .byte 1
SALIDA: .byte 1


.section .text

.global main

main:
	ldi	r16, high(RAMEND)	;inicializa el stack pointer
	out	sph, r16		
	ldi	r16, low(RAMEND)
	out	spl, r16
loop:	
	ldi	r16, 0xFF
	out	_SFR_IO_ADDR(DDRB), r16 ;fija el puerto B como entrada
	in 	r17, _SFR_IO_ADDR(PINB) ;lee puerto B y guarda en ENTRADA
	out 	ENTRADA, r17
	ldi	r16, 0			;inicializa salida con 0
	out	SALIDA, r16
	
	rcall 	FILTRO
	
	in	r17, SALIDA		;guarda salida y lo envia al puerto c
	out	_SFR_IO_ADDR(DDRC), r16
	out	_SFR_IO_ADDR(PORTC), r17
	rjmp	loop
.end

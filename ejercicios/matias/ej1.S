#include <avr/io.h>
#include <avr/sfr_defs.h>

#define low(x)   ((x) & 0xFF)
#define high(x)   (((x)>>8) & 0xFF)


.global main
.section .data

ENTRADA:	.byte	1
SALIDA:		.byte	1

.section .text

main:
	ldi	r16, high(RAMEND)	;inicializa el stack pointer
	out	_SFR_IO_ADDR(SPH), r16		
	ldi	r16, low(RAMEND)
	out	_SFR_IO_ADDR(SPL), r16
loop:	
	ldi	r16, 0xFF
	out	_SFR_IO_ADDR(DDRB), r16 ;fija el puerto B como entrada
	sts ENTRADA, _SFR_IO_ADDR(PINB) ;lee puerto B y guarda en ENTRADA
	ldi	r16, 0			;inicializa salida con 0
	sts	SALIDA, r16
	
	rcall 	FILTRO
	
	ldi	r16, 0			;inicializa salida con 0
	out	_SFR_IO_ADDR(DDRC), r16
	lds	_SFR_IO_ADDR(PORTC), SALIDA		;guarda salida y lo envia al puerto c
	rjmp	loop
FILTRO:
	lds	r17, ENTRADA
	inc	r17
	sts	SALIDA, r17
	ret
.end

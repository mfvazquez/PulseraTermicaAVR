#include <avr/io.h>
#include <avr/sfr_defs.h>

#define low(x)   ((x) & 0xFF)
#define high(x)   (((x)>>8) & 0xFF)


.global main
.section .data

.comm	ENTRADA, 1	
.comm	SALIDA, 1

.comm	TABLA_RAM, 500

.ORG	500
.size	TABLA_ROM, 500	

.section .text

.ORG	0x0

main:
	rcall	NUMEROS	

	ldi	r16, high(RAMEND)	;inicializa el stack pointer
	out	_SFR_IO_ADDR(SPH), r16		
	ldi	r16, low(RAMEND)
	out	_SFR_IO_ADDR(SPL), r16
	ldi	r16, 0			;inicializa salida con 0
	sts	SALIDA, r16
	
loop:	
	ldi	r16, 0xFF
	out	_SFR_IO_ADDR(DDRB), r16 ;fija el puerto B como entrada
	sts	ENTRADA, _SFR_IO_ADDR(PINB) ;lee puerto B y guarda en ENTRADA

	rcall 	FILTRO
	
	ldi	r16, 0			;inicializa salida con 0
	out	_SFR_IO_ADDR(DDRC), r16
	lds	_SFR_IO_ADDR(PORTC), SALIDA		;guarda salida y lo envia al puerto c
	rjmp	loop

FILTRO:
	lds	r17, SALIDA ; (3/4) * SALIDA
	lsr 	r17
	lsr	r17
	ldi	r18, 3
	mul	r17, r18
	mov	r17, r0 ; r17

	lds	r18, ENTRADA ; (1/4) * ENTRADA
	lsr	r18
	lsr	r18

	add	r17, r18 ; (1/4) * ENTRADA + (3/4) * SALIDA
	
	sts	SALIDA, r17
	ret

NUMEROS:

	
	ret

.end

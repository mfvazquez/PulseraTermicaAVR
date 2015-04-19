;Programar en Assembly un bucle infinito que lee los 8 bits de los terminales del puerto
;B y se lo pasa a un rutina FILTRO a través de una variable ENTRADA en RAM. Luego
;recibe en la variable SALIDA el resultado y lo saca por el puerto C. Definir las variables
;en memoria RAM, inicializar SALIDA en 0 y la pila antes de invocar a FILTRO por
;primera vez.

;Programar en Assembly una rutina (FILTRO) que calcula la respuesta del siguiente filtro
;de 1er orden:
;S(k+1) = (1/4)*E(k) + (3/4)*S(k),
;donde E(k), S(k) y S(k+1) son variables de 8 bits alojadas en RAM.
;Sugerencia: Se supone que la rutina lee los valores E y S (en el tiempo k) calcula la
;nueva salida S(k+1) y pisa el viejo valor en RAM de S(k).

#define low(x)   ((x) & 0xFF)
#define high(x)   (((x)>>8) & 0xFF)

#include <avr/io.h>


.global main
.section .data
;_SFR_IO_ADDR(DDRB)
;_SFR_IO_ADDR(PORTB)

ENTRADA:	.byte	1
SALIDA:		.byte	1

.section .text
main:
	;Stack init
	ldi		r16,	low(RAMEND)
	out		_SFR_IO_ADDR(SPL),		r16
	ldi		r16,	high(RAMEND)
	out		_SFR_IO_ADDR(SPH),		r16

	sbi		_SFR_IO_ADDR(DDRB),	0x0	;set port as input
	sbi		_SFR_IO_ADDR(DDRC),	0x7 ;set port as output

	ldi		r16,	0x0
	sts		SALIDA,	r16

loop:
	sts		ENTRADA,	_SFR_IO_ADDR(PORTB)

	rcall 	FILTRO

	lds		_SFR_IO_ADDR(PORTC),	SALIDA

	rjmp	loop


FILTRO:
	ret 
	;(1/4)*E(k)
	;ld
	;(3/4)*S(k)

.end
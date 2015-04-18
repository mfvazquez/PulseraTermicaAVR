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


#include <avr/io.h>

.section .text
.global main

;_SFR_IO_ADDR(DDRB)
;_SFR_IO_ADDR(PORTB)

.dseg
ENTRADA:	.byte	1
SALIDA:		.byte	1

.cseg

.def 		TEMP = r16


main:
	;Stack init	
	ldi		TEMP,	low(RAMEND)
	out		spl,	TEMP
	ldi		TEMP,	high(RAMEND)
	out		sph,	TEMP

	rjmp	main


FILTRO:
	;(1/4)*E(k)
	;ld
	;(3/4)*S(k)

.end
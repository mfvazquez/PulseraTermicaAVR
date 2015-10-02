#include <avr/io.h>

.section .data
.org 0x000

Modo_Operacion: .byte 0

Modo_Standby: 	.byte 0

PWM: 			.byte 0

.section .text
.org 0x0
.global main
rjmp	main

#define low(x)   lo8(x)
#define high(x)  hi8(x)

;Regs:
;r16: Temporal, pasaje de parametro y de retorno
#define Reg_Temporal r16

;r20: Contador
#define Contador r20

#define	PWM_inicial 			5


;Saltea el vector de interrupcion   
.org 0x0020
main:

STACK_Init:
	ldi 	Reg_Temporal, 		low(RAMEND)
	out 	_SFR_IO_ADDR(SPL), 	Reg_Temporal
	ldi		Reg_Temporal, 		high(RAMEND)
	out		_SFR_IO_ADDR(SPH), 	Reg_Temporal

	rcall	PWM_Init
	rcall 	PUENTE_H_Init

LOOP:
	clr 	Contador		 					

	rcall	GET_MODE							;obtengo el modo de operacion
	ldi 	r29,				PWM_inicial		;PWM
	sts		PWM,				r29
	rcall   SET_PWM

	mov		Reg_Temporal,		Contador
	ldi 	r27, 				20
	rcall 	ESPERA								; Espera de 1 seg, mientras espera regula el PWM	
	
	cbi 	_SFR_IO_ADDR(DDRB),	3 				;(OC2) para salida
	sbi 	_SFR_IO_ADDR(DDRB),	3 				;(OC2) para salida
	cbi 	_SFR_IO_ADDR(PORTB),3

	;rcall STANDBY
	rjmp LOOP

;-------------------------------------Funciones---------------------------------------

;-------------------------------------------------------------------------------------
; espera r27 * 100mseg. Cada 100 mseg hace un muestre de datos y regula
; el PWM
ESPERA:
	rcall 	DEMORA

	dec 	r27
	clr 	Reg_Temporal
	cpse	r27, 				Reg_Temporal
	rjmp 	ESPERA
	ret

;-------------------------------------------------------------------------------------
; Inicializa el puente H seteando los pines 1 y 2 del puerto B como salida.
PUENTE_H_Init:
	sbi 	_SFR_IO_ADDR(DDRB),	2 
	sbi 	_SFR_IO_ADDR(DDRB),	1
	ret

MODO_FRIO:
	sbi 	_SFR_IO_ADDR(PORTB),1 			
	cbi 	_SFR_IO_ADDR(PORTB),2 			
	ret
	
MODO_CALOR:
	cbi 	_SFR_IO_ADDR(PORTB),1 			
	sbi 	_SFR_IO_ADDR(PORTB),2 			
	ret
;-------------------------------------------------------------------------------------
;Set PWM
;Setea el pwm del pin OC2 con el tiempo en bajo pasado como parametro
;Reg_Temporal: tiempo en bajo a asignar

SET_PWM:
	lds		r30, PWM
	out 	_SFR_IO_ADDR(OCR2),	r30
	ret
;-------------------------------------------------------------------------------------
;Espera durante 100mseg
DEMORA:
	ldi 	Reg_Temporal,		0xCF			; Valores de los que empieza a contar					
	out 	_SFR_IO_ADDR(TCNT1H),Reg_Temporal
	ldi 	Reg_Temporal, 		0x2B
	out 	_SFR_IO_ADDR(TCNT1L),Reg_Temporal
	ldi		Reg_Temporal, 		4				; 0000 0100 habilita poner en 1 
	out 	_SFR_IO_ADDR(TIFR), Reg_Temporal	; Reinicia el overflow flag
	out 	_SFR_IO_ADDR(TIMSK),Reg_Temporal	; bit 2 en 1 habilita la interrupcion por overflow
	ldi 	Reg_Temporal, 		0b00000011		; velocidad: clk/64
	out		_SFR_IO_ADDR(TCCR1B),Reg_Temporal

DEMORA_LOOP:
	in 		Reg_Temporal, 		_SFR_IO_ADDR(TIFR)
	sbrs	Reg_Temporal, 		2
	rjmp 	DEMORA_LOOP
	
	ldi 	Reg_Temporal, 		1
	out 	_SFR_IO_ADDR(TIFR), Reg_Temporal	; Se limpia TIRF
	clr 	Reg_Temporal						; finalizo contador
	out 	_SFR_IO_ADDR(TIFR), Reg_Temporal
	out		_SFR_IO_ADDR(TCCR1B),Reg_Temporal
		
	ret
	

;-------------------------------------------------------------------------------------
;Standby
;Espera durante 10 segundos, setea el PWM en 255 para no generar corriente.
STANDBY:
	ldi		Reg_Temporal, 		1
	sts		Modo_Standby, 		Reg_Temporal
	ldi 	r29, 				255				;PWM
	sts		PWM, 				r29
	rcall 	SET_PWM
	ldi 	r27, 				100
	rcall	ESPERA
	clr		Reg_Temporal
	sts		Modo_Standby, 		Reg_Temporal
	ret

;-------------------------------------------------------------------------------------
;PWM init 
;Inicializa los puertos de salida del pwm
PWM_Init:
	sbi 	_SFR_IO_ADDR(DDRB),	3 				;(OC2) para salida
	ldi 	Reg_Temporal,		0x71			;(01110001) Phase correct,
	out 	_SFR_IO_ADDR(TCCR2),Reg_Temporal	; no pre escalar, clear on match
	ret
;-------------------------------------------------------------------------------------
;Get mode
;Devuelve el valor del modo en el cual se ejecuta para la temperatura Reg_Temporal
;Reg_Temporal: temperatura leida
;Reg_Temporal: valor leido devuelto
GET_MODE:
	sbic	_SFR_IO_ADDR(PINB), 0
	rjmp	SET_COLD
SET_HOT:	
	cbi _SFR_IO_ADDR(PORTB),	1 			
	sbi _SFR_IO_ADDR(PORTB),	2 			

	ldi 	Reg_Temporal,		1 				;1 es modo calor
	sts  	Modo_Operacion,		Reg_Temporal	;Modo_Operacion modo de operacion inicial 

	ret
	
SET_COLD:
	sbi _SFR_IO_ADDR(PORTB),	1 			
	cbi _SFR_IO_ADDR(PORTB),	2 
	
	ldi 	Reg_Temporal,		0 				;0 es el modo frio
	sts  	Modo_Operacion,		Reg_Temporal	;Modo_Operacion modo de operacion inicial 

	ret

.end

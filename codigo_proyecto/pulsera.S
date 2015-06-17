#include <avr/io.h>

.section .text
.global main

;Regs:
;r16: Temporal, pasaje de parametro y de retorno
;r17: Temperatura ambiente
;r18: Temperatura peltier
;r20: Contador
;r22: Modo de operacion


main:

	sbi _SFR_IO_ADDR(DDRB),		3 			;(OC2) para salida
	ldi r16,0x71 ;(01110001) Phase correct, no pre escalar, clear on match
	out _SFR_IO_ADDR(TCCR2) ,r16
	

	rcall 	PUENTE_H_Init
	rcall	USART_Init
	;rcall 	READ_ADC 						;leer temperatura ambiente
	rcall	TRANSLATE_TEMP					;obtengo la temperatura
	rcall	GET_MODE						;obtengo el modo de operacion

	mov 	r22,		r16					;r22 modo de operacion inicial 

LOOP:
	clr 	r20		 						;Iteraciones, se usa para saber la diferencia que se debe obtener
	ldi 	r29 , 150						; PWM
	rcall	SET_PWM

REDUCIR_LOOP:

	;rcall 	READ_ADC 						;leer temperatura ambiente
	rcall	TRANSLATE_TEMP					;obtengo la temperatura
	mov		r17,		r16

	;rcall 	READ_ADC 						;leer temperatura peltier
	rcall	TRANSLATE_TEMP					;obtengo la temperatura
	mov		r18,		r16

	mov		r16,		r20

	;calcular duty, devuelve el valor en r16, recibe vuelta en r16, ambiente en r17 y peltier en r18

	rcall	SET_PWM

	rcall  	DEMORA
	rcall 	DEMORA
	rcall 	DEMORA
		
	rcall	TRANSMITIR_DATOS

	rcall 	DEMORA							; demora de medio seg
	rcall 	DEMORA
	rcall 	DEMORA

	inc 	r20		 						;Cumpli una vuelta
	ldi 	r16,		6
	cpse 	r20,		r16					;No saltar si ya ejecuto 5 vueltas

	rjmp	REDUCIR_LOOP					

	ldi 	r29, 		150					; PWM
	rcall 	SET_PWM
	cbi _SFR_IO_ADDR(DDRB),		3 			;(OC2) para salida
	sbi _SFR_IO_ADDR(DDRB),		3 			;(OC2) para salida
	cbi _SFR_IO_ADDR(PORTB), 3

	;rcall	STANDBY
	rjmp LOOP
	
;SEND SNIPPET
;ldi r16,'A' ;tipo de dato a mandar
;rcall USART_Transmit
;mov r16,r22 ;No se, imprimo el modo
;rcall USART_Transmit

;-------------------------------------Funciones---------------------------------------

;-------------------------------------------------------------------------------------
PUENTE_H_Init:
	sbi _SFR_IO_ADDR(DDRB),		2 
	sbi _SFR_IO_ADDR(DDRB),		1 			
	sbi _SFR_IO_ADDR(PORTB),	1 			
	cbi _SFR_IO_ADDR(PORTB),	2 			
	ret

;-------------------------------------------------------------------------------------

TRANSMITIR_DATOS:
	ldi 	r16,		'I'					;Envio la iteracion
	rcall 	USART_Transmit
	mov 	r16,		r20 
	rcall 	USART_Transmit
	
	ldi 	r16,		0b11000000			; canal 1 temperatura ambiente
	rcall 	READ_ADC 						; leer tension del peltier
	mov		r17,		r16					; guardo la tension
	ldi 	r16,		'A' 				; tipo de dato a mandar
	rcall 	USART_Transmit
	mov 	r16,		r17
	rcall 	USART_Transmit

	ldi 	r16,		0b11000001			; canal 1 tension peltier
	rcall 	READ_ADC 						; leer tension del peltier
	mov		r17,		r16					; guardo la tension
	ldi 	r16,		'P' 				; tipo de dato a mandar
	rcall 	USART_Transmit
	mov 	r16,		r17
	rcall 	USART_Transmit

	ldi 	r16,		0b11000010			; canal 2 temperatura peltier
	rcall 	READ_ADC 						; leer tension del termistor
	mov		r17,		r16					; guardo la tension
	ldi 	r16,		'T' 				; tipo de dato a mandar
	rcall 	USART_Transmit
	mov 	r16,		r17
	rcall 	USART_Transmit
	ret


;-------------------------------------------------------------------------------------
;Set PWM
;Setea el pwm del pin OC2 con el tiempo en bajo pasado como parametro
;r16: tiempo en bajo a asignar

SET_PWM:
	;out _SFR_IO_ADDR(OCR2),		r16
	;ldi r16,					0x71 		;(01110001) Phase correct, no pre escalar, clear on match
	;out _SFR_IO_ADDR(TCCR2),	r16
	;ret

	out _SFR_IO_ADDR(OCR2),r29
	ldi			r26, 	25
	sub		r29,	r26
	ret


;-------------------------------------------------------------------------------------
;Standby
;Espera durante 1 segundo
DEMORA:
	clr 	r16							; valor desde el que empieza a contar
	out 	_SFR_IO_ADDR(TCNT0), r16
	ldi 	r16, 1
	out 	_SFR_IO_ADDR(TIFR), r16
	out 	_SFR_IO_ADDR(TIMSK), r16
	ldi 	r16, 0b00000101				; clk/1024
	out		_SFR_IO_ADDR(TCCR0), r16
DEMORA_LOOP:
		
	in 		r16, _SFR_IO_ADDR(TIFR)
	sbrs	r16, 0	
	rjmp 	DEMORA_LOOP
	
	clr 	r16							; finalizo contador
	out 	_SFR_IO_ADDR(TIFR), r16
	out		_SFR_IO_ADDR(TCCR0), r16
		
	ret
	

;-------------------------------------------------------------------------------------
;Standby
;Espera durante 10 segundos
STANDBY:
	clr 	r20
STANDBY_LOOP:
	rcall DEMORA
	inc 	r20
	ldi 	r16, 11
	cpse	r20, r16
	rjmp 	STANDBY_LOOP	
	rjmp 	LOOP

;-------------------------------------------------------------------------------------
;Change Mode
;Invierte el bit 0 en el registro r22 que es el modo de funcionamiento
CHANGE_MODE:								;Atiende la interrupcion de cambio de modo
	inc 	r22								;Invierte el ultimo bit
	rjmp	LOOP

;-------------------------------------------------------------------------------------
;Transmit
;Transmite por el puerto paralelo el dato pasado como parametro
;r16: valor a transmitir

USART_Transmit:
	sbis 	_SFR_IO_ADDR(UCSRA), UDRE 		;Espero a que se libere el UDRE
	rjmp 	USART_Transmit

	out 	_SFR_IO_ADDR(UDR),	r16
	ret

;-------------------------------------------------------------------------------------
;Usart init 
;Inicializa el USART para poder enviar datos

USART_Init:
	ldi 	r16, 				(1<<TXEN) 	;enable
	out 	_SFR_IO_ADDR(UCSRB),	r16

	ldi 	r16, 	(1<<URSEL)|(3<<UCSZ0)	;8bits, 1bit de stop, sin bit de paridad
	out 	_SFR_IO_ADDR(UCSRC),	r16

	ldi		r16,				0xC			;Baud 4800
	out 	_SFR_IO_ADDR(UBRRL),	r16

	ret

;-------------------------------------------------------------------------------------
;Read adc 
;Lee un dato del conversor adc y lo devuelve
;r16: canal del cual leer
;r16: valor leido devuelto

READ_ADC:
	;ldi 	r16,				0b11000001  ; Base
	out _SFR_IO_ADDR(ADMUX), 	r16 		; to ADMUX (select channel 0)
	ldi 	r16,				0b11101101	; from left to right: ADC Enable, Start Conversion, Free-Running Mode, write
	out _SFR_IO_ADDR(ADCSR), 	r16 		; zero to ADC Int flag, enable int, prescaler: 101 for XTAL/32
 
	in 		r16, 		_SFR_IO_ADDR(ADCL) 	; get the last ADC result, low byte first,
	in 		r17, 		_SFR_IO_ADDR(ADCH) 	; then high byte
	lsr 	r17
	ror 	r16
	lsr 	r17
	ror 	r16

	ret

;-------------------------------------------------------------------------------------
;Translate temp
;Convierte el valor recibido por parametro en su temperatura equivalente
;entrada: r16: valor leido por el ADC
;salida : r16: temperatura traducida

TRANSLATE_TEMP:
	;ldi 	r16,				35
	ret

;-------------------------------------------------------------------------------------
;Get mode
;Devuelve el valor del modo en el cual se ejecuta para la temperatura r16
;r16: temperatura leida
;r16: valor leido devuelto
GET_MODE:
	cpi 	r16,				24			;temperatura arbitraria para el modo calor
	brsh	COLD_MODE
HOT_MODE:
	ldi 	r16,				1 			;1 es modo calor
	ret
COLD_MODE:
	ldi 	r16,				0 			;0 es el modo frio
	ret

.end

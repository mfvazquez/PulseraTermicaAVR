#include <avr/io.h>

.section .data
.org 0x000

Temp_Ambiente: 	.byte 0
Temp_Disipador: .byte 0
Temp_Peltier: 	.byte 0
Tension_Salida: .byte 0

Modo_Operacion: .byte 0

Modo_Standby: 	.byte 0

PWM: 			.byte 0
Tension_min:	.byte 0
Tension_max:	.byte 0
Iterador:		.byte 0

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

;Constantes:
;Tipos de dato para mandar por serial

#define Dato_Tempe_Ambiente 	'A'
#define Dato_Tempe_Disipador  	'T'
#define Dato_Num_Iteracion  	'I'
#define Dato_Tension_Salida 	'P'
#define Dato_Tempe_Peltier  	'X'
#define Dato_PWM  				'W'
#define Dato_max				'M'
#define Dato_min				'N'

#define Incremento_Pulso_Calor	 3
#define Incremento_Pulso_Frio	10
#define Incremento_Regulacion 	 1
#define	PWM_inicial 			95


#define Eeprom_Inicio_Calor  	0x64
#define Eeprom_Inicio_Frio  	0x94


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
	rcall	USART_Init

LOOP:
	clr 	Contador		 					

	rcall	GET_MODE							;obtengo el modo de operacion

	ldi 	r29,				PWM_inicial		;PWM
	sts		PWM,				r29
	rcall	RESET_PWM							; Inicializa el PWM con el valor inicial en base al modo de operación

REDUCIR_LOOP:

	mov		Reg_Temporal,		Contador

	ldi 	r27, 				10
	rcall 	ESPERA								; Espera de 1 seg, mientras espera regula el PWM
	rcall	AUMENTAR_PULSO						; Modifica el PWM para el siguiente segundo
	
	
	inc 	Contador		 					;Cumpli una vuelta
	ldi 	Reg_Temporal,		6
	cpse 	Contador,			Reg_Temporal	;No saltar si ya ejecuto 5 vueltas

	rjmp	REDUCIR_LOOP					

	cbi 	_SFR_IO_ADDR(DDRB),	3 				;(OC2) para salida
	sbi 	_SFR_IO_ADDR(DDRB),	3 				;(OC2) para salida
	cbi 	_SFR_IO_ADDR(PORTB),3

	rcall STANDBY
	rjmp LOOP

;-------------------------------------Funciones---------------------------------------
; Reinicia el PWM al valor inicial de cada ciclo y carga las tablas a ser
; recorridas dependiendo del modo de operacion
RESET_PWM:
	clr		r17									;8 bits mas significativos de la direccion de la eeprom a leer	
	lds		r31, 				Modo_Operacion
	cpi		r31, 				0
	breq	TABLA_FRIO
TABLA_CALOR:
	ldi		Reg_Temporal, 		Eeprom_Inicio_Calor
	rjmp	CARGAR_TABLA
TABLA_FRIO:	
	ldi		Reg_Temporal, 		Eeprom_Inicio_Frio
CARGAR_TABLA:
	inc		Reg_Temporal
	inc		Reg_Temporal
	sts		Iterador, 			Reg_Temporal
	rcall	LEER_EEPROM
	sts		Tension_min, 		r25

	inc		Reg_Temporal
	inc		Reg_Temporal
	rcall	LEER_EEPROM
	sts		Tension_max, 		r25
	
	lds		r29, 				PWM
	out 	_SFR_IO_ADDR(OCR2),	r29
	
	ret
;-------------------------------------------------------------------------------------
; espera r27 * 100mseg. Cada 100 mseg hace un muestre de datos y regula
; el PWM
ESPERA:
	rcall	SET_PWM
	rcall	TRANSMITIR_DATOS
	rcall 	DEMORA

	dec 	r27
	clr 	Reg_Temporal
	cpse	r27, 				Reg_Temporal
	rjmp 	ESPERA
	ret

;-------------------------------------------------------------------------------------
; Lee de eeprom en la direccion indicada en los registros r17 para los 8 bits
; mas significativos y r16 para los 8 bits menos significativos. Guarda el contenido
; en el registro r25
LEER_EEPROM:
	;Espera hasta que la ultima escritura este terminada
	sbic	_SFR_IO_ADDR(EECR),	EEWE
	rjmp 	LEER_EEPROM

	;r17 elige la tabla	
	out		_SFR_IO_ADDR(EEARH),r17	
	;r16 el campo
	out		_SFR_IO_ADDR(EEARL),r16	
	
	;habilita el modo lectura
	sbi		_SFR_IO_ADDR(EECR), EERE	
	;guarda el contenido de la dirección antes cargada en r25
	in		r25, 				_SFR_IO_ADDR(EEDR)		
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

TRANSMITIR_DATOS:
	rcall 	LEER_AMBIENTE
	rcall 	LEER_DISIPADOR
	rcall	LEER_PELTIER
	
	;Envio la iteracion
	ldi 	Reg_Temporal,		Dato_Num_Iteracion		; tipo de dato a mandar
	rcall 	USART_Transmit
	mov 	Reg_Temporal,		Contador 
	rcall 	USART_Transmit
		
	ldi 	Reg_Temporal,		Dato_Tempe_Ambiente 	; tipo de dato a mandar			
	rcall 	USART_Transmit
	lds 	Reg_Temporal,		Temp_Ambiente
	rcall 	USART_Transmit

	ldi 	Reg_Temporal,		Dato_Tension_Salida 	; tipo de dato a mandar			
	rcall 	USART_Transmit
	lds 	Reg_Temporal,		Tension_Salida
	rcall 	USART_Transmit
	
	ldi 	Reg_Temporal,		Dato_Tempe_Disipador	; tipo de dato a mandar			
	rcall 	USART_Transmit
	lds 	Reg_Temporal,		Temp_Disipador
	rcall 	USART_Transmit
	
	ldi 	Reg_Temporal,		Dato_Tempe_Peltier		; tipo de dato a mandar		
	rcall 	USART_Transmit
	lds 	Reg_Temporal,		Temp_Peltier
	rcall 	USART_Transmit
	
	ldi 	Reg_Temporal,		Dato_PWM				; tipo de dato a mandar
	rcall 	USART_Transmit
	lds 	Reg_Temporal,		PWM
	rcall 	USART_Transmit
		
	ldi 	Reg_Temporal,		Dato_min				; tipo de dato a mandar
	rcall 	USART_Transmit
	lds 	Reg_Temporal,		Tension_min
	rcall 	USART_Transmit

	ldi 	Reg_Temporal,		Dato_max				; tipo de dato a mandar
	rcall 	USART_Transmit
	lds 	Reg_Temporal,		Tension_max
	rcall 	USART_Transmit
	
	ret

;-------------------------------------------------------------------------------------
LEER_AMBIENTE:
	ldi 	Reg_Temporal,		0b11000000			; canal 0 temperatura ambiente
	rcall 	READ_ADC 								; leer tension del peltier
	rcall	TRADUCIR_TERMISTOR
	sts 	Temp_Ambiente,  	Reg_Temporal
	ret

LEER_DISIPADOR:
	ldi 	Reg_Temporal,		0b11000010			; canal 2 temperatura disipador
	rcall 	READ_ADC 								; leer tension del termistor
	rcall	TRADUCIR_TERMISTOR
	sts 	Temp_Disipador, 	Reg_Temporal
	ret

LEER_PELTIER:
	ldi 	Reg_Temporal,		0b11000001			; canal 1 tension peltier
	rcall 	READ_ADC 								; leer tension del peltier
	sts		Tension_Salida, 	Reg_Temporal
	rcall 	TRADUCIR_PELTIER
	ret

;-------------------------------------------------------------------------------------
;Set PWM
;Setea el pwm del pin OC2 con el tiempo en bajo pasado como parametro
;Reg_Temporal: tiempo en bajo a asignar

SET_PWM:
	lds		r30, PWM
	lds		Reg_Temporal, 		Modo_Standby
	cpi		Reg_Temporal, 		1
	;Si esta en modo standby no realiza cambios
	breq	APLICAR_CAMBIO							
	
	lds		r29, 				Tension_Salida	
	lds		r17, 				Tension_min
	lds		r18, 				Tension_max
	ldi		r26, 				Incremento_Regulacion ;valor a ser restado o sumado
	
	cp		r29, 				r17
	brlo	AUMENTAR
	
	cp		r29, 				r18
	brlo	APLICAR_CAMBIO	

DISMINUIR:	
	cpi		r30, 				100
	breq 	APLICAR_CAMBIO
	add		r30,				r26
	rjmp	APLICAR_CAMBIO
AUMENTAR:
	cpi		r30, 				0
	breq 	APLICAR_CAMBIO
	sub		r30,				r26
APLICAR_CAMBIO:
	sts		PWM, 				r30
	out 	_SFR_IO_ADDR(OCR2),	r30
	ret
;-------------------------------------------------------------------------------------
; Aumenta el pulso de calor/frio del segundo que recien empieza,
; Carga la tension minima y maxima leidas de eeprom de la iteracion
; correspondiente.
AUMENTAR_PULSO:
	clr		r17								
	
	lds		Reg_Temporal,		Iterador
	inc		Reg_Temporal
	inc		Reg_Temporal
	sts		Iterador, 			Reg_Temporal
	
	rcall	LEER_EEPROM
	sts		Tension_min, 		r25
	inc		Reg_Temporal
	inc		Reg_Temporal
	rcall	LEER_EEPROM
	sts		Tension_max, 		r25
	
	lds		r31, 				Modo_Operacion
	cpi		r31, 				0
	breq	AUMENTO_FRIO
AUMENTO_CALOR:
	ldi		r26, 				Incremento_Pulso_Calor
	rcall AUMENTAR
	ret
AUMENTO_FRIO:
	ldi		r26, 				Incremento_Pulso_Frio
	rcall	AUMENTAR
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
;Transmit
;Transmite por el puerto paralelo el dato pasado como parametro
;Reg_Temporal: valor a transmitir

USART_Transmit:
	sbis 	_SFR_IO_ADDR(UCSRA),UDRE 					;Espero a que se libere el UDRE
	rjmp 	USART_Transmit

	out 	_SFR_IO_ADDR(UDR),	Reg_Temporal
	ret

;-------------------------------------------------------------------------------------
;Usart init 
;Inicializa el USART para poder enviar datos

USART_Init:
	ldi 	Reg_Temporal, 		(1<<TXEN) 				;enable
	out 	_SFR_IO_ADDR(UCSRB),Reg_Temporal

	ldi 	Reg_Temporal, 		(1<<URSEL)|(3<<UCSZ0)	;8bits, 1bit de stop, sin bit de paridad
	out 	_SFR_IO_ADDR(UCSRC),Reg_Temporal

	ldi		Reg_Temporal,		0xC						;Baud 38400 (Clock de 8Mhz)
	out 	_SFR_IO_ADDR(UBRRL),Reg_Temporal

	ret

;-------------------------------------------------------------------------------------
;Read adc 
;Lee un dato del conversor adc y lo devuelve
;Reg_Temporal: canal del cual leer
;Reg_Temporal: valor leido devuelto

READ_ADC:

	out 	_SFR_IO_ADDR(ADMUX),Reg_Temporal	;	Canal a ser leido, 7 y 6 en 1 para utilizar la tensión interna de referencia 2.56V 
	ldi 	Reg_Temporal,		0b11001111		; habilita ADC,  inicia la conversion, desabilita free runing, desabilita interrupcion, 
	out 	_SFR_IO_ADDR(ADCSRA),Reg_Temporal 	; buts 2:0 Factor de division 128

WAIT_ADC:  
	;Espera a que finalice la lectura
	in    	Reg_Temporal,		_SFR_IO_ADDR(ADCSRA)	
	sbrs	Reg_Temporal,		4
	rjmp	WAIT_ADC

	sbi		_SFR_IO_ADDR(ADCSRA),4				; Reinicia el interrupt flag

	in 		Reg_Temporal, 		_SFR_IO_ADDR(ADCL) 	
	in 		r17, 				_SFR_IO_ADDR(ADCH) 	
	lsr 	r17
	ror 	Reg_Temporal
	lsr 	r17
	ror 	Reg_Temporal

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
;Traducir termistor
;Convierte el valor recibido por parametro en su temperatura equivalente
;entrada: Reg_Temporal: valor leido por el ADC

TRADUCIR_TERMISTOR:
	mov		r18,				Reg_Temporal
	ldi 	r17,				0				;tabla termistor
	ldi 	Reg_Temporal,		0				;indice
LOOP_BUSQUEDA_TERM:
	rcall	LEER_EEPROM
	cpi		r25, 				0
	breq	FIN_TABLA
	cp 		r18,				r25				;leido vs valor tabla
	brsh	END_TERMISTOR
	inc 	Reg_Temporal
	inc 	Reg_Temporal
	rjmp	LOOP_BUSQUEDA_TERM

END_TERMISTOR:
	inc 	Reg_Temporal
	rcall	LEER_EEPROM
	mov 	Reg_Temporal,  		r25
	ret

FIN_TABLA:
	dec		Reg_Temporal
	dec		Reg_Temporal
	rjmp	END_TERMISTOR

;-------------------------------------------------------------------------------------
;Traducir peltier
;Convierte el valor recibido por parametro en su temperatura equivalente
;entrada: Temp_Disipador, Tension_Salida, Modo_Operacion
;salida: Temp_Peltier

TRADUCIR_PELTIER:
	lds		r18, 				Tension_Salida
	ldi 	r17, 				0 				;tabla termistor	
	lds		r31, 				Modo_Operacion
	cpi		r31, 				0
	breq	TABLA_FRIO_PELTIER
TABLA_CALOR_PELTIER:
	ldi		Reg_Temporal, 		Eeprom_Inicio_Calor
	rjmp	LOOP_BUSQUEDA_TERM_PELTIER
TABLA_FRIO_PELTIER:	
	ldi		Reg_Temporal, 		Eeprom_Inicio_Frio
	rjmp	LOOP_BUSQUEDA_TERM_PELTIER

LOOP_BUSQUEDA_TERM_PELTIER:
	rcall	LEER_EEPROM
	cpi		r25, 				0xFF
	breq	FIN_TABLA_PELTIER
	cp 		r25,				r18				; valor tabla vs leido
	brsh	END_PELTIER
	inc 	Reg_Temporal
	inc 	Reg_Temporal
	rjmp	LOOP_BUSQUEDA_TERM_PELTIER
END_PELTIER:	
	inc		Reg_Temporal
	rcall 	LEER_EEPROM
	lds		r17, 				Temp_Disipador
	lds		r18, 				Modo_Operacion

	mov		Reg_Temporal, 		r25	

	sbrc	r18,				0
	rjmp 	CALCULO_CALOR
	rjmp	CALCULO_FRIO
	
CALCULO_CALOR:
	add  	Reg_Temporal, 		r17
	sts 	Temp_Peltier, 		Reg_Temporal
	ret

CALCULO_FRIO:
	sub  	r17, 				Reg_Temporal
	mov		Reg_Temporal, 		r17
	sts 	Temp_Peltier, 		Reg_Temporal
	ret
	
FIN_TABLA_PELTIER:
	dec		Reg_Temporal
	dec 	Reg_Temporal
	rjmp	END_PELTIER

;-------------------------------------------------------------------------------------
;Get mode
;Devuelve el valor del modo en el cual se ejecuta para la temperatura Reg_Temporal
;Reg_Temporal: temperatura leida
;Reg_Temporal: valor leido devuelto
GET_MODE:
	ldi 	Reg_Temporal,		0b11000000		; canal 0 temperatura ambiente
	rcall 	READ_ADC 	
	rcall	TRADUCIR_TERMISTOR					;obtengo la temperatura
	cpi 	Reg_Temporal,		50				;temperatura*2 arbitraria para el modo calor
	brsh	COLD_MODE
	
HOT_MODE:
	sbic	_SFR_IO_ADDR(PINB), 0				; Si el pin esta en 1 cambia de modo
	rjmp	SET_COLD

SET_HOT:	
	cbi _SFR_IO_ADDR(PORTB),	1 			
	sbi _SFR_IO_ADDR(PORTB),	2 			

	ldi 	Reg_Temporal,		1 				;1 es modo calor
	sts  	Modo_Operacion,		Reg_Temporal	;Modo_Operacion modo de operacion inicial 

	ret

COLD_MODE:
	sbic	_SFR_IO_ADDR(PINB), 0				; Si el pin esta en 1 cambia de modo
	rjmp	SET_HOT
	
SET_COLD:
	sbi _SFR_IO_ADDR(PORTB),	1 			
	cbi _SFR_IO_ADDR(PORTB),	2 
	
	ldi 	Reg_Temporal,		0 				;0 es el modo frio
	sts  	Modo_Operacion,		Reg_Temporal	;Modo_Operacion modo de operacion inicial 

	ret

.section .eeprom
.org  0x0000

;Tablas de conversion 
;Formato: [(Tension medida, Temperatura*2),...]
.byte	204	,	30
.byte	204	,	31
.byte	204	,	32
.byte	204	,	33
.byte	204	,	34
.byte	204	,	35
.byte	204	,	36
.byte	204	,	37
.byte	204	,	38
.byte	201	,	39
.byte	199	,	40
.byte	197	,	41
.byte	195	,	42
.byte	194	,	43
.byte	193	,	44
.byte	192	,	45
.byte	190	,	46
.byte	188	,	47
.byte	186	,	48
.byte	184	,	49
.byte	182	,	50
.byte	181	,	51
.byte	172	,	52
.byte	169	,	53
.byte	166	,	54
.byte	163	,	55
.byte	160	,	56
.byte	159	,	57
.byte	158	,	58
.byte	157	,	59
.byte	156	,	60
.byte	155	,	62
.byte	154	,	64
.byte	153	,	66
.byte	152	,	68
.byte	151	,	70
.byte	147	,	72
.byte	145	,	74
.byte	143	,	76
.byte	141	,	78
.byte	140	,	80
.byte	0, 0 ;FIN DE TABLA

; TABLA PARA MODO CALOR
;Formato: [Tension minima, Dif_Temperatura*2]
.org	0x0064
.byte	0	,	0
.byte	1	,	0
.byte	20	,	10
.byte	25	,	15
.byte	30	,	17
.byte	35	,	21
.byte	40	,	23
.byte	50  ,	24
.byte	55	,	18
.byte	58	,	20
.byte	60	,	24
.byte	62	,	28
.byte	70	,	7
.byte	0xFF, 0xFF ;FIN DE TABLA

; TABLA PARA MODO FRIO
;Formato: [Tension minima, Dif_Temperatura*2]

.org	0x0094
.byte	0	,	0
.byte	1	,	0
.byte	30  ,	14
.byte	35	,	16
.byte	40	,	18
.byte	45	,	20
.byte	50	,	22
.byte	60  ,	30
.byte	100 ,	36
.byte	110	,	40
.byte	115	,	42
.byte	0xFF, 0xFF ;FIN DE TABLA

.end

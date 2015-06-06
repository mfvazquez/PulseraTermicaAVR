#include <avr/io.h>

.section .text
.global main

main:

	rcall	USART_Init
	rjmp READ_ADC



;-------------------------------------Funciones---------------------------------------
;-------------------------------------------------------------------------------------
;Set PWM
;Setea el pwm del pin OC2 con el tiempo en bajo pasado como parametro
;r16: tiempo en bajo a asignar

SET_PWM:
	sbi _SFR_IO_ADDR(DDRB),3 ;(OC2) para salida
	out _SFR_IO_ADDR(OCR2),r16
	ldi r16,0x71 							;(01110001) Phase correct, no pre escalar, clear on match
	out _SFR_IO_ADDR(TCCR2) ,r16
	ret

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
	ldi 	r16, 	(1<<TXEN) ;enable
	out 	_SFR_IO_ADDR(UCSRB),	r16

	ldi 	r16, 	(1<<URSEL)|(3<<UCSZ0)	;8bits, 1bit de stop, sin bit de paridad
	out 	_SFR_IO_ADDR(UCSRC),	r16

	ldi	r16,	0xC 						;Baud 4800
	out 	_SFR_IO_ADDR(UBRRL),	r16

	ret

;-------------------------------------------------------------------------------------
;Read adc 
;Lee un dato del conversor adc y lo devuelve
;r16: valor leido devuelto

READ_ADC:
	ldi r16, 0  							; write zero
	out _SFR_IO_ADDR(ADMUX), r16  			; to ADMUX (select channel 0)
	ldi r16, 0b11101101  					; from left to right: ADC Enable, Start Conversion, Free-Running Mode, write
	out _SFR_IO_ADDR(ADCSR), r16  			; zero to ADC Int flag, enable int, prescaler: 101 for XTAL/32
 
	in r16, _SFR_IO_ADDR(ADCL)  			; get the last ADC result, low byte first,
	in r17, _SFR_IO_ADDR(ADCH)  			; then high byte
	lsr r17
	ror r16
	lsr r17
	ror r16
	com r16

	ret

.end

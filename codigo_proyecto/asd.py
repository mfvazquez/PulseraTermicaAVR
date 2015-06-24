#! /usr/bin/python
import serial
from time import time

TAMANIO_TEMPERATURA = 1

VOLT = 2.56 / 255

def traducir_voltaje(leido):
	return ord(leido)

def traducir_temperatura(leido):
	return ord(leido)/2.0
	

DATA_TYPE = {"A":("Temperatura Ambiente",TAMANIO_TEMPERATURA,traducir_temperatura),
		"P":("Tension Peltier",TAMANIO_TEMPERATURA,traducir_voltaje),
		"I":("\nNumero Ciclo",1,ord), 
		"T":("Temperatura Disipador",TAMANIO_TEMPERATURA,traducir_temperatura),
		"X":("Temperatura Peltier",TAMANIO_TEMPERATURA,traducir_temperatura),
		"W":("PWM",TAMANIO_TEMPERATURA,traducir_voltaje),
		"M":("Tension Maxima",TAMANIO_TEMPERATURA,traducir_voltaje),
		"N":("Tension Minima",TAMANIO_TEMPERATURA,traducir_voltaje),}

def main():
	serial_port = serial.Serial("/dev/ttyUSB0",38400)
	while (True): #Leo el tipo de dato a leer
		read_byte = serial_port.read(1)	
		if not DATA_TYPE.has_key(read_byte):
			print "Leido: ",ord(read_byte), "no reconocido."
			continue

		data_type,data_len,f = DATA_TYPE[read_byte]
		read_data = serial_port.read(data_len)
		if not read_data:
			print "Fallo lectura"
			break

		print data_type, " : " , f(read_data)
		
main()

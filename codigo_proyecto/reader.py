#! /usr/bin/python
import serial

TAMANIO_TEMPERATURA = 1

DATA_TYPE = {"A":("Temperatura Ambiente",TAMANIO_TEMPERATURA),"P":("Temperatura Peltier",TAMANIO_TEMPERATURA),
		"I":("Numero Ciclo",1)}

def main():
	serial_port = serial.Serial("/dev/ttyUSB0",4800)
	read_byte = serial_port.read(1)	
	while (read_byte): #Leo el tipo de dato a leer
		try:
			data_type,data_len = DATA_TYPE[read_byte]
		except:
			continue		
		print "Leyendo: ",data_type
		read_data = serial_port.read(data_len)
		if not read_data:
			print "Fallo lectura"
			break
		print data_type, " : " , read_data

main()

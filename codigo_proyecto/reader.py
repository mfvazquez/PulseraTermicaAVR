#! /usr/bin/python
import serial

TAMANIO_TEMPERATURA = 1

VOLT = 2.56 / 255

def traducir_voltaje(leido):
	return ord(leido) * VOLT

DATA_TYPE = {"A":("Temperatura Ambiente",TAMANIO_TEMPERATURA,traducir_voltaje),"P":("Temperatura Peltier",TAMANIO_TEMPERATURA,traducir_voltaje),
		"I":("Numero Ciclo",1,ord)}

def main():
	serial_port = serial.Serial("/dev/ttyUSB0",4800)
	while (True): #Leo el tipo de dato a leer
		read_byte = serial_port.read(1)	
		if not DATA_TYPE.has_key(read_byte):
			print "Leido: ",ord(read_byte)
			continue

		data_type,data_len,f = DATA_TYPE[read_byte]
		read_data = serial_port.read(data_len)
		if not read_data:
			print "Fallo lectura"
			break

		print data_type, " : " , f(read_data)
		
main()

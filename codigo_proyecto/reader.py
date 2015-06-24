#! /usr/bin/python
# coding=utf-8
import serial
import sys
import random
import time

import matplotlib.pyplot as plt

TAMANIO_TEMPERATURA = 1


def traducir_voltaje(leido):
    return ord(leido)


def traducir_temperatura(leido):
    return ord(leido)/2


def devolver_tiempo(leido):
    print time.time()
    return ord(leido)


DATA_TYPE = {"A":("Temperatura Ambiente",TAMANIO_TEMPERATURA,traducir_temperatura),
		"P":("Tension Peltier",TAMANIO_TEMPERATURA,traducir_voltaje),
		"I":("\nNumero Ciclo",1,ord), 
		"T":("Temperatura Disipador",TAMANIO_TEMPERATURA,traducir_temperatura),
		"X":("Temperatura Peltier",TAMANIO_TEMPERATURA,traducir_temperatura),
		"W":("PWM",TAMANIO_TEMPERATURA,traducir_voltaje),
		"M":("Tension Maxima",TAMANIO_TEMPERATURA,traducir_voltaje),
		"N":("Tension Minima",TAMANIO_TEMPERATURA,traducir_voltaje),}


def main():
    i = -1
    plt.ion()
    fig = plt.figure()
    start_time = time.time()
    initial_time = time.time()

    serial_port = serial.Serial("/dev/ttyUSB0", 38400)

    temperaturas_peltier = [0, 0]
    tiempo_temperatura_peltier = [0, 0]

    temperaturas_peltier_iteracion = [0]
    iteracion_temperatura_peltier = [0]

    temperaturas_ambiente = [0, 0]
    tiempo_temperatura_ambiente = [0, 0]

    temperaturas_ambiente_iteracion = [0]
    iteracion_temperatura_ambiente = [0]

    iteraciones = [0]

    while (True):  # Leo el tipo de dato a leer
        i += 1
        read_byte = serial_port.read(1)
        if not DATA_TYPE.has_key(read_byte):
            print "Leido: ", ord(read_byte), "no reconocido."
            continue

        data_type, data_len, f = DATA_TYPE[read_byte]
        read_data = serial_port.read(data_len)

        if not read_data:
            print "Fallo lectura"
            break

        tiempo = time.time() - start_time

        if data_type == DATA_TYPE["I"][0]:
            old = i
            i = f(read_data)
            if old > i:
                temperaturas_peltier_iteracion = [temperaturas_peltier_iteracion[-1]]
                iteracion_temperatura_peltier = [-1]
                temperaturas_ambiente_iteracion = [temperaturas_ambiente_iteracion[-1]]
                iteracion_temperatura_ambiente = [-1]

                continue

        print data_type, " : ", f(read_data)
        if data_type == DATA_TYPE["X"][0]:
            temperaturas_peltier.append(f(read_data))
            tiempo_temperatura_peltier.append(tiempo)

            temperaturas_peltier_iteracion.append(f(read_data))
            iteracion_temperatura_peltier.append((i / 2) % 5)

        if tiempo_temperatura_peltier[-1] - tiempo_temperatura_peltier[1] > 5.8:
            pass
            # temperaturas_peltier = temperaturas_peltier[1:]
            # tiempo_temperatura_peltier = tiempo_temperatura_peltier[1:]

        if data_type == DATA_TYPE["A"][0]:
            temperaturas_ambiente.append(f(read_data))
            tiempo_temperatura_ambiente.append(tiempo)

            temperaturas_ambiente_iteracion.append(f(read_data))
            iteracion_temperatura_ambiente.append((i / 2) % 5)

        if tiempo_temperatura_ambiente[-1] - tiempo_temperatura_ambiente[1] > 5.8:
            # temperaturas_ambiente = temperaturas_ambiente[1:]
            # tiempo_temperatura_ambiente = tiempo_temperatura_ambiente[1:]
            pass

    	if (time.time() - initial_time) < 0.25:
    		continue

        plt.clf()

        # Temperatura Peltier
        #print tiempo_temperatura_peltier, temperaturas_peltier
        plt.subplot(221)
        plt.plot(tiempo_temperatura_peltier, temperaturas_peltier, linestyle='-', color='b',
                 label='Temperatura',
                 marker="o")
        plt.axis([tiempo_temperatura_peltier[-1] - 5.6, tiempo_temperatura_peltier[-1] + 0.1, 0, 40])
        plt.xlabel('Tiempo [s]')
        plt.ylabel('Temperatura [C]')
        plt.title('Temperatura Peltier [{0:03f}]'.format(temperaturas_peltier[-1]))
        plt.grid(True, which="both", linestyle="dotted")

        #print tiempo_temperatura_ambiente, temperaturas_ambiente
        plt.subplot(222)
        plt.plot(tiempo_temperatura_ambiente, temperaturas_ambiente, linestyle='-', color='r',
                 label='Temperatura',
                 marker="o")
        plt.axis([tiempo_temperatura_ambiente[-1] - 5.6, tiempo_temperatura_ambiente[-1] + 0.1, 0, 40])
        plt.xlabel('Tiempo [s]')
        plt.ylabel('Temperatura [C]')
        plt.title('Temperatura Ambiente [{0:03f}]'.format(temperaturas_ambiente[-1]))
        plt.grid(True, which="both", linestyle="dotted")

        plt.subplot(223)
        plt.plot(tiempo_temperatura_ambiente, temperaturas_ambiente, linestyle='-', color='r',
                 label='Temperatura',
                 marker="2")
        plt.plot(tiempo_temperatura_peltier, temperaturas_peltier, linestyle='-', color='b',
                 label='Temperatura',
                 marker="1")
        plt.axis([tiempo_temperatura_peltier[-1] - 5.6, tiempo_temperatura_peltier[-1] + 0.1, 0, 40])
        plt.xlabel('Tiempo [s]')
        plt.ylabel('Temperatura [C]')
        plt.title('Comparacion Temperaturas')
        plt.grid(True, which="both", linestyle="dotted")

        #print iteracion_temperatura_ambiente, temperaturas_ambiente_iteracion

        plt.subplot(224)
        plt.plot(iteracion_temperatura_ambiente, temperaturas_ambiente_iteracion, linestyle='-', color='r',
                 label='Temperatura',
                 marker="2")
        plt.plot(iteracion_temperatura_peltier, temperaturas_peltier_iteracion, linestyle='-', color='b',
                 label='Temperatura',
                 marker="1")
        plt.axis([0, 6, 0, 40])
        plt.xlabel('Iteracion')
        plt.ylabel('Temperatura [C]')
        plt.title('Temperaturas durante iteracion')
        plt.grid(True, which="both", linestyle="dotted")

        fig.canvas.draw()
        plt.pause(0.001)

       	initial_time = time.time()


main()

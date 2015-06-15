#! /usr/bin/python
# coding=utf-8
import serial
import sys
import random
import time

import numpy as np
import matplotlib.pyplot as plt

TAMANIO_TEMPERATURA = 1

VOLT = 2.56 / 255


def traducir_voltaje(leido):
    return ord(leido) * VOLT


DATA_TYPE = {"A": ("Temperatura Ambiente", TAMANIO_TEMPERATURA, traducir_voltaje),
             "P": ("Tension Peltier", TAMANIO_TEMPERATURA, traducir_voltaje),
             "I": ("Numero Ciclo", 1, ord)}


def main():
    i = -1
    t = 25
    plt.ion()
    fig = plt.figure()
    start_time = time.time()
    serial_port = sys.stdin  # serial.Serial("/dev/ttyUSB0", 4800)

    temperaturas_peltier = [0,0]
    tiempo_temperatura_peltier = [0,0]

    temperaturas_peltier_iteracion = [0]
    iteracion_temperatura_peltier = [0]

    temperaturas_ambiente = [0,0]
    tiempo_temperatura_ambiente = [0,0]

    temperaturas_ambiente_iteracion = [0]
    iteracion_temperatura_ambiente = [0]

    iteraciones = [0]

    while (True):  # Leo el tipo de dato a leer
        i += 1
        plt.clf()
        read_byte = random.choice(["P","A"][i%2])  # serial_port.read(1)
        if not DATA_TYPE.has_key(read_byte):
            print "Leido: ", ord(read_byte), "no reconocido."
            continue

        data_type, data_len, f = DATA_TYPE[read_byte]
        read_data = (t + random.choice(range(-10, 10))) % 256  # serial_port.read(data_len)
        if read_data == 0:
            read_data = 1
        if not read_data:
            print "Fallo lectura"
            break

        tiempo = time.time() - start_time

        if i % 10 == 0:
            temperaturas_peltier_iteracion = [temperaturas_peltier_iteracion[-1]]
            iteracion_temperatura_peltier = [-1]
            temperaturas_ambiente_iteracion = [temperaturas_ambiente_iteracion[-1]]
            iteracion_temperatura_ambiente = [-1]

        # print data_type, " : ", #f(read_data)
        if data_type == DATA_TYPE["P"][0]:
            temperaturas_peltier.append(read_data)  #f(read_data))
            tiempo_temperatura_peltier.append(tiempo)

            temperaturas_peltier_iteracion.append(read_data)
            iteracion_temperatura_peltier.append((i/2)%5)


            if tiempo_temperatura_peltier[-1] - tiempo_temperatura_peltier[1] > 5.8:
                temperaturas_peltier = temperaturas_peltier[1:]
                tiempo_temperatura_peltier = tiempo_temperatura_peltier[1:]

        if data_type == DATA_TYPE["A"][0]:
            temperaturas_ambiente.append(read_data)  #f(read_data))
            tiempo_temperatura_ambiente.append(tiempo)

            temperaturas_ambiente_iteracion.append(read_data)
            iteracion_temperatura_ambiente.append((i/2)%5)

            if tiempo_temperatura_ambiente[-1] - tiempo_temperatura_ambiente[1] > 5.8:
                temperaturas_ambiente = temperaturas_ambiente[1:]
                tiempo_temperatura_ambiente = tiempo_temperatura_ambiente[1:]


        #Temperatura Peltier
        plt.subplot(221)
        plt.plot(tiempo_temperatura_peltier, temperaturas_peltier, linestyle='-', color='b', label='Temperatura',
                 marker="o")
        plt.axis([tiempo_temperatura_peltier[-1] - 5.6, tiempo_temperatura_peltier[-1] + 0.1, -20, 100])
        plt.xlabel('Tiempo [s]')
        plt.ylabel('Temperatura [C]')
        plt.title('Temperatura Peltier [{0:03d}]'.format(temperaturas_peltier[-1]))
        plt.grid(True, which="both", linestyle="dotted")


        plt.subplot(222)
        plt.plot(tiempo_temperatura_ambiente, temperaturas_ambiente, linestyle='-', color='r', label='Temperatura',
                 marker="o")
        plt.axis([tiempo_temperatura_ambiente[-1] - 5.6, tiempo_temperatura_ambiente[-1] + 0.1, -20, 100])
        plt.xlabel('Tiempo [s]')
        plt.ylabel('Temperatura [C]')
        plt.title('Temperatura Ambiente [{0:03d}]'.format(temperaturas_ambiente[-1]))
        plt.grid(True, which="both", linestyle="dotted")


        plt.subplot(223)
        plt.plot(tiempo_temperatura_ambiente, temperaturas_ambiente, linestyle='-', color='r', label='Temperatura',
                 marker="2")
        plt.plot(tiempo_temperatura_peltier, temperaturas_peltier, linestyle='-', color='b', label='Temperatura',
                 marker="1")
        plt.axis([tiempo_temperatura_peltier[-1] - 5.6, tiempo_temperatura_peltier[-1] + 0.1, -20, 100])
        plt.xlabel('Tiempo [s]')
        plt.ylabel('Temperatura [C]')
        plt.title('Comparacion Temperaturas')
        plt.grid(True, which="both", linestyle="dotted")

        plt.subplot(224)
        plt.plot(iteracion_temperatura_ambiente, temperaturas_ambiente_iteracion, linestyle='-', color='r', label='Temperatura',
                 marker="2")
        plt.plot(iteracion_temperatura_peltier, temperaturas_peltier_iteracion, linestyle='-', color='b', label='Temperatura',
                 marker="1")
        plt.axis([0,6,-20, 100])
        plt.xlabel('Iteracion')
        plt.ylabel('Temperatura [C]')
        plt.title('Temperaturas durante iteracion')
        plt.grid(True, which="both", linestyle="dotted")

        fig.canvas.draw()
        plt.pause(0.001)

main()

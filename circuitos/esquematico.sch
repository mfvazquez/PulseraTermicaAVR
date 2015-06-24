EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:special
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:esquematico-cache
EELAYER 27 0
EELAYER END
$Descr User 10630 6693
encoding utf-8
Sheet 1 1
Title ""
Date "24 jun 2015"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L LM358 U?
U 1 1 5588AD34
P 8150 5050
F 0 "U?" H 8100 5250 60  0001 L CNN
F 1 "LM358" H 8100 4800 60  0000 L CNN
F 2 "" H 8150 5050 60  0000 C CNN
F 3 "" H 8150 5050 60  0000 C CNN
	1    8150 5050
	1    0    0    -1  
$EndComp
$Comp
L AT90S4433-P IC?
U 1 1 5588ADF0
P 3200 3050
F 0 "IC?" H 2400 4350 40  0001 L BNN
F 1 "AT90S4433-P" H 3600 1800 40  0001 L BNN
F 2 "ATMEGA8/L" H 3200 3050 30  0000 C CIN
F 3 "" H 3200 3050 60  0000 C CNN
	1    3200 3050
	1    0    0    -1  
$EndComp
$Comp
L NPN Q?
U 1 1 5588B00D
P 6900 2350
F 0 "Q?" H 6900 2200 50  0001 R CNN
F 1 "TIP31C" H 6900 2500 50  0000 R CNN
F 2 "~" H 6900 2350 60  0000 C CNN
F 3 "~" H 6900 2350 60  0000 C CNN
	1    6900 2350
	1    0    0    -1  
$EndComp
$Comp
L LM358 U?
U 1 1 5588B0EE
P 6200 2350
F 0 "U?" H 6150 2550 60  0001 L CNN
F 1 "LM358" H 6150 2100 60  0000 L CNN
F 2 "" H 6200 2350 60  0000 C CNN
F 3 "" H 6200 2350 60  0000 C CNN
	1    6200 2350
	1    0    0    -1  
$EndComp
$Comp
L LM7805 U?
U 1 1 5588B130
P 900 1000
F 0 "U?" H 1050 804 60  0001 C CNN
F 1 "LM7805" H 900 1200 60  0000 C CNN
F 2 "" H 900 1000 60  0000 C CNN
F 3 "" H 900 1000 60  0000 C CNN
	1    900  1000
	1    0    0    -1  
$EndComp
$Comp
L JUMPER JP1
U 1 1 5588B179
P 1950 1950
F 0 "JP1" H 1950 2100 60  0000 C CNN
F 1 "JUMPER" H 1950 1870 40  0000 C CNN
F 2 "~" H 1950 1950 60  0000 C CNN
F 3 "~" H 1950 1950 60  0000 C CNN
	1    1950 1950
	1    0    0    -1  
$EndComp
$Comp
L FUSE Constantan
U 1 1 5588B18A
P 6700 5200
F 0 "Constantan" H 6800 5250 40  0000 L BNN
F 1 "FUSE" H 6600 5150 40  0001 C CNN
F 2 "~" H 6700 5200 60  0000 C CNN
F 3 "~" H 6700 5200 60  0000 C CNN
	1    6700 5200
	0    1    1    0   
$EndComp
$Comp
L DUAL_SWITCH_INV SW?
U 1 1 5588B199
P 5000 1300
F 0 "SW?" H 4800 1450 50  0001 C CNN
F 1 "INVERTIR" H 4850 1150 50  0000 C CNN
F 2 "~" H 5000 1300 60  0000 C CNN
F 3 "~" H 5000 1300 60  0000 C CNN
	1    5000 1300
	1    0    0    -1  
$EndComp
$Comp
L +12V #PWR?
U 1 1 5588B1F3
P 500 950
F 0 "#PWR?" H 500 900 20  0001 C CNN
F 1 "+12V" H 500 1050 30  0000 C CNN
F 2 "" H 500 950 60  0000 C CNN
F 3 "" H 500 950 60  0000 C CNN
	1    500  950 
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 5588B202
P 900 1250
F 0 "#PWR?" H 900 1250 30  0001 C CNN
F 1 "GND" H 900 1180 30  0001 C CNN
F 2 "" H 900 1250 60  0000 C CNN
F 3 "" H 900 1250 60  0000 C CNN
	1    900  1250
	1    0    0    -1  
$EndComp
Wire Wire Line
	1650 1950 1650 950 
Wire Wire Line
	1300 950  7250 950 
Wire Wire Line
	3200 950  3200 1650
Connection ~ 1650 950 
$Comp
L GND #PWR?
U 1 1 5588B247
P 5050 1250
F 0 "#PWR?" H 5050 1250 30  0001 C CNN
F 1 "GND" H 5050 1180 30  0001 C CNN
F 2 "" H 5050 1250 60  0000 C CNN
F 3 "" H 5050 1250 60  0000 C CNN
	1    5050 1250
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 5588B256
P 3200 4350
F 0 "#PWR?" H 3200 4350 30  0001 C CNN
F 1 "GND" H 3200 4280 30  0001 C CNN
F 2 "" H 3200 4350 60  0000 C CNN
F 3 "" H 3200 4350 60  0000 C CNN
	1    3200 4350
	1    0    0    -1  
$EndComp
$Comp
L CONN_3 K?
U 1 1 5588B2EC
P 5350 3450
F 0 "K?" V 5300 3450 50  0001 C CNN
F 1 "SERIE" V 5400 3450 40  0000 C CNN
F 2 "" H 5350 3450 60  0000 C CNN
F 3 "" H 5350 3450 60  0000 C CNN
	1    5350 3450
	1    0    0    -1  
$EndComp
$Comp
L CONN_2 P?
U 1 1 5588B342
P 10050 3600
F 0 "P?" V 10000 3600 40  0001 C CNN
F 1 "PELTIER" V 10100 3600 40  0000 C CNN
F 2 "" H 10050 3600 60  0000 C CNN
F 3 "" H 10050 3600 60  0000 C CNN
	1    10050 3600
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 5588B3D8
P 5500 1500
F 0 "#PWR?" H 5500 1500 30  0001 C CNN
F 1 "GND" H 5500 1430 30  0001 C CNN
F 2 "" H 5500 1500 60  0000 C CNN
F 3 "" H 5500 1500 60  0000 C CNN
	1    5500 1500
	1    0    0    -1  
$EndComp
Wire Wire Line
	5500 950  5500 1200
Connection ~ 3200 950 
Wire Wire Line
	5500 1400 5500 1500
Wire Wire Line
	4500 1300 4150 1300
Wire Wire Line
	4150 1300 4150 1950
Wire Wire Line
	4150 3350 5000 3350
Wire Wire Line
	4150 3450 5000 3450
Wire Wire Line
	5000 3550 5000 3650
$Comp
L GND #PWR?
U 1 1 5588B43C
P 5000 2650
F 0 "#PWR?" H 5000 2650 30  0001 C CNN
F 1 "GND" H 5000 2580 30  0001 C CNN
F 2 "" H 5000 2650 60  0000 C CNN
F 3 "" H 5000 2650 60  0000 C CNN
	1    5000 2650
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 5588B44B
P 5000 3650
F 0 "#PWR?" H 5000 3650 30  0001 C CNN
F 1 "GND" H 5000 3580 30  0001 C CNN
F 2 "" H 5000 3650 60  0000 C CNN
F 3 "" H 5000 3650 60  0000 C CNN
	1    5000 3650
	1    0    0    -1  
$EndComp
$Comp
L THERMISTOR TH1
U 1 1 5588B45A
P 4900 5450
F 0 "TH1" V 5000 5500 50  0000 C CNN
F 1 "THERMISTOR 10k" V 4800 5450 50  0000 C CNN
F 2 "~" H 4900 5450 60  0000 C CNN
F 3 "~" H 4900 5450 60  0000 C CNN
	1    4900 5450
	1    0    0    -1  
$EndComp
$Comp
L THERMISTOR TH2
U 1 1 5588B467
P 5800 5450
F 0 "TH2" V 5900 5500 50  0000 C CNN
F 1 "THERMISTOR 10k" V 5700 5450 50  0000 C CNN
F 2 "~" H 5800 5450 60  0000 C CNN
F 3 "~" H 5800 5450 60  0000 C CNN
	1    5800 5450
	1    0    0    -1  
$EndComp
$Comp
L R R4
U 1 1 5588B46F
P 4900 4550
F 0 "R4" V 4980 4550 40  0000 C CNN
F 1 "22k" V 4907 4551 40  0000 C CNN
F 2 "~" V 4830 4550 30  0000 C CNN
F 3 "~" H 4900 4550 30  0000 C CNN
	1    4900 4550
	1    0    0    -1  
$EndComp
$Comp
L R R5
U 1 1 5588B47E
P 5800 4550
F 0 "R5" V 5880 4550 40  0000 C CNN
F 1 "22k" V 5807 4551 40  0000 C CNN
F 2 "~" V 5730 4550 30  0000 C CNN
F 3 "~" H 5800 4550 30  0000 C CNN
	1    5800 4550
	1    0    0    -1  
$EndComp
$Comp
L R R1
U 1 1 5588B48D
P 4750 2250
F 0 "R1" V 4830 2250 40  0000 C CNN
F 1 "4.7k" V 4757 2251 40  0000 C CNN
F 2 "~" V 4680 2250 30  0000 C CNN
F 3 "~" H 4750 2250 30  0000 C CNN
	1    4750 2250
	0    -1   -1   0   
$EndComp
$Comp
L C C1
U 1 1 5588B49C
P 5000 2450
F 0 "C1" H 5000 2550 40  0000 L CNN
F 1 "10u" H 5006 2365 40  0000 L CNN
F 2 "~" H 5038 2300 30  0000 C CNN
F 3 "~" H 5000 2450 60  0000 C CNN
	1    5000 2450
	1    0    0    -1  
$EndComp
Wire Wire Line
	5000 2250 5700 2250
$Comp
L +12V #PWR?
U 1 1 5588B537
P 6100 1950
F 0 "#PWR?" H 6100 1900 20  0001 C CNN
F 1 "+12V" H 6100 2050 30  0000 C CNN
F 2 "" H 6100 1950 60  0000 C CNN
F 3 "" H 6100 1950 60  0000 C CNN
	1    6100 1950
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 5588B546
P 6100 2750
F 0 "#PWR?" H 6100 2750 30  0001 C CNN
F 1 "GND" H 6100 2680 30  0001 C CNN
F 2 "" H 6100 2750 60  0000 C CNN
F 3 "" H 6100 2750 60  0000 C CNN
	1    6100 2750
	1    0    0    -1  
$EndComp
$Comp
L +12V #PWR?
U 1 1 5588B555
P 7000 1950
F 0 "#PWR?" H 7000 1900 20  0001 C CNN
F 1 "+12V" H 7000 2050 30  0000 C CNN
F 2 "" H 7000 1950 60  0000 C CNN
F 3 "" H 7000 1950 60  0000 C CNN
	1    7000 1950
	1    0    0    -1  
$EndComp
Wire Wire Line
	7000 1950 7000 2150
Wire Wire Line
	4150 2250 4500 2250
$Comp
L GND #PWR?
U 1 1 5588B61A
P 8200 4350
F 0 "#PWR?" H 8200 4350 30  0001 C CNN
F 1 "GND" H 8200 4280 30  0001 C CNN
F 2 "" H 8200 4350 60  0000 C CNN
F 3 "" H 8200 4350 60  0000 C CNN
	1    8200 4350
	1    0    0    -1  
$EndComp
Wire Wire Line
	6400 4000 7350 4000
Wire Wire Line
	7350 3500 6900 3500
Wire Wire Line
	6900 3050 6900 3900
Wire Wire Line
	6900 3900 7350 3900
Wire Wire Line
	6800 3800 7350 3800
Wire Wire Line
	9050 3300 9400 3300
Wire Wire Line
	9400 3300 9400 3900
Wire Wire Line
	9400 3900 9050 3900
Wire Wire Line
	9050 3800 9050 3400
Wire Wire Line
	9700 3500 9050 3500
Connection ~ 9050 3500
Wire Wire Line
	9700 3700 9400 3700
Connection ~ 9400 3700
Connection ~ 5500 950 
Wire Wire Line
	7000 2550 7000 3300
Wire Wire Line
	7000 3300 7350 3300
Wire Wire Line
	4150 2050 5350 2050
Wire Wire Line
	5350 2050 5350 3050
Wire Wire Line
	5350 3050 6900 3050
Connection ~ 6900 3500
Wire Wire Line
	5300 2100 5300 3100
Wire Wire Line
	4150 2150 4300 2150
Wire Wire Line
	4300 2150 4300 2100
Wire Wire Line
	4300 2100 5300 2100
Wire Wire Line
	6800 3600 7350 3600
Wire Wire Line
	6400 3400 7350 3400
Wire Wire Line
	6400 2800 7250 2800
Wire Wire Line
	7250 2800 7250 950 
Wire Wire Line
	7350 3200 6700 3200
Wire Wire Line
	6700 3200 6700 4950
$Comp
L GND #PWR?
U 1 1 5588BBA5
P 6700 5650
F 0 "#PWR?" H 6700 5650 30  0001 C CNN
F 1 "GND" H 6700 5580 30  0001 C CNN
F 2 "" H 6700 5650 60  0000 C CNN
F 3 "" H 6700 5650 60  0000 C CNN
	1    6700 5650
	1    0    0    -1  
$EndComp
Wire Wire Line
	6700 5450 6700 5650
$Comp
L +12V #PWR?
U 1 1 5588BC97
P 8050 4650
F 0 "#PWR?" H 8050 4600 20  0001 C CNN
F 1 "+12V" H 8050 4750 30  0000 C CNN
F 2 "" H 8050 4650 60  0000 C CNN
F 3 "" H 8050 4650 60  0000 C CNN
	1    8050 4650
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 5588BCA6
P 8050 5450
F 0 "#PWR?" H 8050 5450 30  0001 C CNN
F 1 "GND" H 8050 5380 30  0001 C CNN
F 2 "" H 8050 5450 60  0000 C CNN
F 3 "" H 8050 5450 60  0000 C CNN
	1    8050 5450
	1    0    0    -1  
$EndComp
Wire Wire Line
	6700 4950 7650 4950
$Comp
L R R2
U 1 1 5588BD43
P 8650 5300
F 0 "R2" V 8730 5300 40  0000 C CNN
F 1 "4.7k" V 8657 5301 40  0000 C CNN
F 2 "~" V 8580 5300 30  0000 C CNN
F 3 "~" H 8650 5300 30  0000 C CNN
	1    8650 5300
	1    0    0    -1  
$EndComp
Wire Wire Line
	8650 5550 7650 5550
Wire Wire Line
	7650 5550 7650 5150
$Comp
L R R3
U 1 1 5588BD8D
P 8650 5800
F 0 "R3" V 8730 5800 40  0000 C CNN
F 1 "1k" V 8657 5801 40  0000 C CNN
F 2 "~" V 8580 5800 30  0000 C CNN
F 3 "~" H 8650 5800 30  0000 C CNN
	1    8650 5800
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 5588BD9C
P 8650 6050
F 0 "#PWR?" H 8650 6050 30  0001 C CNN
F 1 "GND" H 8650 5980 30  0001 C CNN
F 2 "" H 8650 6050 60  0000 C CNN
F 3 "" H 8650 6050 60  0000 C CNN
	1    8650 6050
	1    0    0    -1  
$EndComp
Wire Wire Line
	4900 4300 5800 4300
Wire Wire Line
	5800 4300 5800 3700
Wire Wire Line
	4900 5200 4900 4800
Wire Wire Line
	5800 4800 5800 5200
$Comp
L GND #PWR?
U 1 1 5588BEE2
P 5800 5700
F 0 "#PWR?" H 5800 5700 30  0001 C CNN
F 1 "GND" H 5800 5630 30  0001 C CNN
F 2 "" H 5800 5700 60  0000 C CNN
F 3 "" H 5800 5700 60  0000 C CNN
	1    5800 5700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 5588BEF1
P 4900 5700
F 0 "#PWR?" H 4900 5700 30  0001 C CNN
F 1 "GND" H 4900 5630 30  0001 C CNN
F 2 "" H 4900 5700 60  0000 C CNN
F 3 "" H 4900 5700 60  0000 C CNN
	1    4900 5700
	1    0    0    -1  
$EndComp
Wire Wire Line
	5600 5000 5800 5000
Connection ~ 5800 5000
Wire Wire Line
	4700 5000 4900 5000
Wire Wire Line
	4700 2850 4700 5000
Wire Wire Line
	4700 2850 4150 2850
Connection ~ 4900 5000
Wire Wire Line
	5900 4450 8650 4450
Wire Wire Line
	8650 4450 8650 5050
$Comp
L C C2
U 1 1 5588C0B0
P 7750 2050
F 0 "C2" H 7750 2150 40  0000 L CNN
F 1 "0.1u" H 7756 1965 40  0000 L CNN
F 2 "~" H 7788 1900 30  0000 C CNN
F 3 "~" H 7750 2050 60  0000 C CNN
	1    7750 2050
	0    1    1    0   
$EndComp
$Comp
L C C3
U 1 1 5588C0C4
P 7750 2650
F 0 "C3" H 7750 2750 40  0000 L CNN
F 1 "0.1u" H 7756 2565 40  0000 L CNN
F 2 "~" H 7788 2500 30  0000 C CNN
F 3 "~" H 7750 2650 60  0000 C CNN
	1    7750 2650
	0    1    1    0   
$EndComp
Wire Wire Line
	7550 2050 7250 2050
Connection ~ 7250 2050
Wire Wire Line
	7000 2650 7550 2650
Connection ~ 7000 2650
$Comp
L GND #PWR?
U 1 1 5588C172
P 7950 2800
F 0 "#PWR?" H 7950 2800 30  0001 C CNN
F 1 "GND" H 7950 2730 30  0001 C CNN
F 2 "" H 7950 2800 60  0000 C CNN
F 3 "" H 7950 2800 60  0000 C CNN
	1    7950 2800
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 5588C181
P 7950 2200
F 0 "#PWR?" H 7950 2200 30  0001 C CNN
F 1 "GND" H 7950 2130 30  0001 C CNN
F 2 "" H 7950 2200 60  0000 C CNN
F 3 "" H 7950 2200 60  0000 C CNN
	1    7950 2200
	1    0    0    -1  
$EndComp
Wire Wire Line
	7950 2650 7950 2800
Wire Wire Line
	7950 2050 7950 2200
Wire Wire Line
	5700 2450 5700 2900
Wire Wire Line
	5700 2900 7000 2900
Connection ~ 7000 2900
Wire Wire Line
	4900 3200 5900 3200
Wire Wire Line
	5900 3200 5900 4450
Wire Wire Line
	4150 2650 4800 2650
Wire Wire Line
	4800 2650 4800 4150
Wire Wire Line
	4800 4150 5600 4150
Wire Wire Line
	5600 4150 5600 5000
Wire Wire Line
	4900 2750 4900 3200
Wire Wire Line
	4900 2750 4150 2750
Wire Wire Line
	5800 3700 7350 3700
Wire Wire Line
	6400 4000 6400 2800
Connection ~ 6400 3700
Connection ~ 6400 3400
Wire Wire Line
	6800 3800 6800 3100
Connection ~ 6800 3600
Wire Wire Line
	6800 3100 5300 3100
$Comp
L L298D U?
U 1 1 5588AF85
P 8200 3600
F 0 "U?" H 8200 3600 60  0001 C CNN
F 1 "L298D" H 8200 3700 60  0000 C CNN
F 2 "Multiwatt15-V" H 8400 4200 60  0001 C CNN
F 3 "" H 8200 3600 60  0000 C CNN
	1    8200 3600
	1    0    0    -1  
$EndComp
Wire Wire Line
	7350 3100 7250 3100
Wire Wire Line
	7250 3100 7250 3200
Connection ~ 7250 3200
$EndSCHEMATC

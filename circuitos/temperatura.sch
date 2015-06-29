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
LIBS:temperatura-cache
EELAYER 27 0
EELAYER END
$Descr User 4000 4000
encoding utf-8
Sheet 1 1
Title ""
Date "29 jun 2015"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L LM7805 U?
U 1 1 5588B130
P 1800 1200
F 0 "U?" H 1950 1004 60  0001 C CNN
F 1 "LM7805" H 1800 1400 60  0000 C CNN
F 2 "" H 1800 1200 60  0000 C CNN
F 3 "" H 1800 1200 60  0000 C CNN
	1    1800 1200
	1    0    0    -1  
$EndComp
$Comp
L +12V #PWR?
U 1 1 5588B1F3
P 1400 1150
F 0 "#PWR?" H 1400 1100 20  0001 C CNN
F 1 "+12V" H 1400 1250 30  0000 C CNN
F 2 "" H 1400 1150 60  0000 C CNN
F 3 "" H 1400 1150 60  0000 C CNN
	1    1400 1150
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 5588B202
P 1800 1450
F 0 "#PWR?" H 1800 1450 30  0001 C CNN
F 1 "GND" H 1800 1380 30  0001 C CNN
F 2 "" H 1800 1450 60  0000 C CNN
F 3 "" H 1800 1450 60  0000 C CNN
	1    1800 1450
	1    0    0    -1  
$EndComp
$Comp
L THERMISTOR TH2
U 1 1 5588B467
P 2200 2550
F 0 "TH2" V 2300 2600 50  0000 C CNN
F 1 "THERMISTOR 10k" V 2100 2550 50  0000 C CNN
F 2 "~" H 2200 2550 60  0000 C CNN
F 3 "~" H 2200 2550 60  0000 C CNN
	1    2200 2550
	1    0    0    -1  
$EndComp
$Comp
L R R5
U 1 1 5588B47E
P 2200 1650
F 0 "R5" V 2280 1650 40  0000 C CNN
F 1 "22k" V 2207 1651 40  0000 C CNN
F 2 "~" V 2130 1650 30  0000 C CNN
F 3 "~" H 2200 1650 30  0000 C CNN
	1    2200 1650
	1    0    0    -1  
$EndComp
Wire Wire Line
	2200 1900 2200 2300
$Comp
L GND #PWR?
U 1 1 5588BEE2
P 2200 2800
F 0 "#PWR?" H 2200 2800 30  0001 C CNN
F 1 "GND" H 2200 2730 30  0001 C CNN
F 2 "" H 2200 2800 60  0000 C CNN
F 3 "" H 2200 2800 60  0000 C CNN
	1    2200 2800
	1    0    0    -1  
$EndComp
Text GLabel 1850 2100 0    60   Input ~ 0
ADC
Wire Wire Line
	1850 2100 2200 2100
Connection ~ 2200 2100
Wire Wire Line
	2200 1400 2200 1150
$EndSCHEMATC

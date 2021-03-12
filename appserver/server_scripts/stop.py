#!/usr/bin/python3

import serial
import io


ser = serial.serial_for_url('/dev/ttyUSB0', 256000, timeout=2)
sio = io.TextIOWrapper(io.BufferedRWPair(ser, ser))

sio.write("S0,0,0\n")
sio.flush()
print(sio.read())



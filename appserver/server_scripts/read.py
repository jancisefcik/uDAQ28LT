#!/usr/bin/python3

import serial
import io


ser = serial.serial_for_url('/dev/ttyUSB0', 256000, timeout=1)
sio = io.TextIOWrapper(io.BufferedRWPair(ser, ser))

sio.flush()
print(sio.read())
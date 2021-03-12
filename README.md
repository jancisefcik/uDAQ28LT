# uDAQ28LT
Scripts, code and MATLAB libraries and models for the uDAQ28/LT Thermal plant
To test start.py, execute following command:
``./start.py -p /dev/ttyUSB0 -o output.txt -i in_bulb:100,in_fan:100,in_led:100,t_sim:20,reg_target:230,reg_type:none,reg_device:fan,P:1,I:1,D:0,s_rate:20``

## Contents:

### `old/`

This directory contains old MATLAB scripts to test and run uDAQ28/LT device in MATLAB workspace.

Files: 

- `thermo_optic.m`
- `udaq_functions.m`

---

### `baudrate/` 

This directory contains tool for setting custom, unusual baud rate value for serial port in Linux. 

Files:

- `Makefile`
- `set_baudrate.c`
- `set_baudrate`

---

### `uDAQ28LT_fun.m`

This is a Level-2 MATLAB S-Function for the uDAQ28/LT thermal plant device. Used in uDAQ28/LT Simulink library. This file depends on `recalculate.m` script, which helps to recalculate input values to the Thermal plant.

---

### `uDAQ28LT_lib.slx`

This is a Simulink(R) Library for uDAQ28/LT Thermal plant. Can be used to create new Simulink models and systems and in simulations.

---

### `uDAQ28LT_system.slx`

This is Simulink(R) basic simulation model, which can be run after proper workspace variables are set in MATLAB.

List of parameters for workspace with example values:

- `in_bulb = 100  %0-100`
- `in_fan = 100  %0-100`
- `in_led = 100  %0-100`
- `com = '/dev/ttyUSB0,output.txt'`
- `baud = 256000`
- `t_sim = 20`
- `P = 1`
- `I = 1`
- `D = 0`
- `Ts = 0.02`
- `duration = 0`
- `o_temp = 0`
- `o_ftemp = 0`
- `o_intens = 0`
- `o_fintens = 0`
- `o_fanamp = 0`
- `o_fanrpm = 0`
- `reg_target = 2300`
- `reg_type  = 0  %0-none,1-PID`
- `reg_device  = 1  % 1-bulb,2-fan,3-led`

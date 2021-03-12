# uDAQ28/LT Example functions

In this folder you can find basic functionality for the uDAQ28/LT Thermal Plant for MATLAB.

The USB Thermal plant communicates according to following rules:
- the baud rate to transfer data to/from device must be set to 256 kbit/s, i.e. 256000 bit/s,
- device accepts messages formatted as: `'S%d,%d,%d\n'`, where after the 'S' comes 3 comma separated numbers for light bulb, fan and LED accordingly.
- device can output 6 values, which are formatted as: `'%d %d %d %d %d %d\n'`, which are 6 integers separated with space, meaning: DPS temperature, filtered temperature, light intensity, filtered light intensity, electric current consumed by fan, rpm of fan respectively.

## Contents:

- `uDAQ28_example_MATLAB.m`
- `uDAQ28_functions_examples_MATLAB.m`

### `uDAQ28_example_MATLAB.m`

This script contains basic example on how to communicate with the uDAQ28/LT Thermal Plant.
Script opens new serial port with path: `/dev/ttyUSB0`, sets minimal required parameters and sets custom baud rate trough external tool.

Then sets values for bulb, fan and LED to 100% for 5 seconds. Then the values are lowered by 50% for 5 seconds. Finally script send zeros to
device to turn off bulb, fan and LED. Script after every change on device also reads the raw values from device and prins them to MATLAB command 
window.

Finally the script closes and deletes the serial port, then clear workspace variable of serial port device.

### `uDAQ_functions_examples_MATLAB.m`

This script contains 3 reusable functions to manipulate with the uDAQ28/LT Thermal Plant:

- `set_udaq(baudrate)`: opens serial port, sets parameters and given baud rate parameter. Returns opened serial device.
- `write_udaq(device,lamp,led,fan)`: writes values for lamp, led and fan to the device. Returns values from device.
- `delete_udaq(device)`: closes serial port and deletes device with workspace object.



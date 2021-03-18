% Basic way of sending/receiving data in MATLAB for uDAQ28/LT Thermal Plant
% Copyright (c) 2020 Jan Sefcik

udaq_device = serial('/dev/ttyUSB0');  % Set serial port to /dev/ttyUSB0.
udaq_device.Terminator = 'LF';  % Set terminator to LF.

fopen(udaq_device);  % Open serial port for communication.

% Execute external script to set serialport baud rate.
system('./baudrate/set_baudrate /dev/ttyUSB0 256000');

% Write data to serial device and read values from device.
fprintf(udaq_device,'S255,255,255');
out = fscanf(udaq_device)

pause(5);

% Write 'turn-off' data to serial device.
fprintf(udaq_device,'S128,128,128');
out = fscanf(udaq_device)

pause(5);

fprintf(udaq_device,'S0,0,0');
out = fscanf(udaq_device) 

% Exit with closing and deleting serial port vars.
fclose(udaq_device);
delete(udaq_device);
clear udaq_device;

% Basic way of sending/receiving data in MATLAB for uDAQ28/LT Thermal Plant
% using older 'serial' interface.
% Copyright (c) 2020 Jan Sefcik

udaq_device = serial('/dev/ttyUSB0');  % Set serial port to /dev/ttyUSB0.
udaq_device.Terminator = 'LF';  % Set terminator to LF.

fopen(udaq_device);  % Open serial port for communication.

% Execute external script to set serialport baud rate.
system(sprintf('./utils/baudrate/set_baudrate %s %d',com,baud));

% Write data to serial device and read values from device.
fprintf(udaq_device,"S255,255,255\n");
out = fscanf(udaq_device)

pause(5);

% Write 'turn-off' data to serial device.
fprintf(udaq_device,"S0,0,0\n");
out = fscanf(udaq_device)

% Exit with closing and deleting serial port vars.
fclose(udaq_device);
delete(udaq_device);
clear udaq_device;

% Basic way of sending/receiving data in MATLAB for uDAQ28/LT Thermal Plant
% Copyright (c) 2021 Jan Sefcik
 
com = "/dev/ttyUSB0";  % Serial port name.
baud = 256000;  % Custom baud rate value, specially for uDAQ28/LT.

% Check if desired serial port is available.
if ~strcmp(com, seriallist)    
    error("Device %s is not connected, check the name.\nPossible ports: %s",com,seriallist);
end

udaq_device = serialport(com,9600);  % Connects to the serial port specified by 'com' with a baud rate of 9600.
udaq_device.Parity = "none";  % Set parity to check whether data has been lost or written.
udaq_device.DataBits = 8;  % Number of bits to represent one character of data.
udaq_device.StopBits = 1;  % Pattern of bits that indicates the end of a character or of the whole transmission.
udaq_device.Timeout = 5;  % Allowed time in seconds to complete read and write operations.

configureTerminator(udaq_device, "LF");  % Terminator character for reading and writing ASCII-terminated data.

% Execute external script to set serialport baud rate.
system(sprintf('./utils/baudrate/set_baudrate %s %d',com,baud));

% Write data to serial device and read values from device.
writeline(udaq_device, "S255,255,255\n");
readline(udaq_device)

pause(5);

% Write 'turn-off' data to serial device.
writeline(udaq_device, "S0,0,0\n");
readline(udaq_device)

% Exit with closing and deleting serial port vars.
clearvars udaq_device;
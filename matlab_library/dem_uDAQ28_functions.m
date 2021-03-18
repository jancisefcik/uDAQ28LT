% Help functions with examples to work with uDAQ28/LT Thermal Plant.
% Copyright (c) 2020 Jan Sefcik

dev1 = set_udaq('/dev/ttyUSB0', 256000);
a = write_udaq(dev1,255,255,255)
pause(5);
a1 = write_udaq(dev1,255,255,255)
pause(5);
b = write_udaq(dev1,100,100,100)
pause(5);
c = write_udaq(dev1,0,0,0)
delete_udaq(dev1)

% Function to open serial port and set baud rate. 
function udaq_device = set_udaq(port, baudrate)
    udaq_device = serial(port);  % Set serial port to e.g. /dev/ttyUSB0.
    udaq_device.Terminator = 'LF';  % Set terminator to LF.

    fopen(udaq_device);  % Open serial port for communication.

    % Execute external script to set serialport baud rate.
    command = strcat('./baudrate/set_baudrate ', sprintf(' %s %d',port, baudrate)); 
    system(command);
end

% Function for write and read values to and from thermal plant.
function value = write_udaq(device,lamp,led,fan)
    command = strcat('S',sprintf('%d',lamp),',',sprintf('%d',led),',',sprintf('%d',fan));
    fprintf(device, command);
    value = fscanf(device);
end

% Function to close and delete the serial port.
function delete_udaq(device)
    fclose(device);
    delete(device);
    clear device;
end


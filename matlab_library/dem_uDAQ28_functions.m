% Help functions with examples to work with uDAQ28/LT Thermal Plant.
% Copyright (c) 2020 Jan Sefcik

dev1 = set_udaq(256000);
a = write_udaq(dev1,250,250,250)
pause(5);
b = write_udaq(dev1,100,100,100)
pause(5);
c = write_udaq(dev1,0,0,0)
delete_udaq(dev1)

% Function to open serial port and set baud rate. 
function udaq_device = set_udaq(baudrate)
    udaq_device = serial('/dev/ttyUSB0');  % Set serial port to /dev/ttyUSB0.
    udaq_device.Terminator = 'LF';  % Set terminator to LF.

    fopen(udaq_device);  % Open serial port for communication.

    % Execute external script to set serialport baud rate.
    command = strcat('~/uDAQ28LT/baudrate/set_baudrate /dev/ttyUSB0 ', sprintf(' %d',baudrate)); 
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


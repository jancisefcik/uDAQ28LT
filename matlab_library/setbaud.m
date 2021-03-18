% Function to explicitly change baudrate for the serial port.
% Copyright (c) 2021 Jan Sefcik

function setbaud(serialport, baudrate)
    % Execute external script to set serialport baud rate.
    command = strcat('./baudrate/set_baudrate ', sprintf(' %s %d',serialport, baudrate)); 
    system(command);
end
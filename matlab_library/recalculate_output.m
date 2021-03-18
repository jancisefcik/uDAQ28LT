% Local function to recalculate output values from uDAQ28/LT Thermal Plant.
% Copyright (c) 2020 Jan Sefcik.

function res = recalculate_output(plant_output)
    % Constants to recalculate output values from device.
    % 'C_temp' and 'C_intens' are from previous implementations.
    % 'C_amp' and 'C_rpm' are values computed for purposes of this work personally.
    C_temp = 28.67; 
    C_intens = 40.95;
    C_amp = 49.47;
    C_rpm = 1.27;
    
    % Read values from string into matrix.
    values = sscanf(plant_output, '%g %g %g %g %g %g');
    % Recalculate output values with constants for actual real-life values.
    r_temp = values(1) / C_temp;
    r_ftemp = values(2) / C_temp;
    r_intens = values(3) / C_intens;
    r_fintens = values(4) / C_intens;
    r_amp = values(5) / C_amp;
    r_rpm = values(6) / C_rpm;

    % Create and return vector of correct output values. 
    res = [r_temp,r_ftemp,r_intens,r_fintens,r_amp,r_rpm];
end
% Local function to recalculate output values from uDAQ28/LT Thermal Plant.
% Copyright (c) 2021 Jan Sefcik.

function res = recalculate_output(plant_output)
    % Constants to recalculate output values from device.
    C_ti = 40.96; 
    C_amp = 81.91;
    C_rpm = 1.67;
    
    % Parse values from device output string.
    values = sscanf(plant_output, '%g %g %g %g %g %g');
    % Recalculate output values with constants for actual real-life values.
    r_temp = values(1) / C_ti;
    r_ftemp = values(2) / C_ti;
    r_intens = values(3) / C_ti;
    r_fintens = values(4) / C_ti;
    r_amp = values(5) / C_amp;
    r_rpm = values(6) / C_rpm;

    % Create and return vector of correct output values. 
    res = [r_temp,r_ftemp,r_intens,r_fintens,r_amp,r_rpm];
end

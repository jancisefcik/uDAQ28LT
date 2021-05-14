% This script creates structures with default attribute values for the
% uDAQ28/LT thermal plant. This script is called within the setup.m file on
% MATLAB startup.
 
baud = 256000;
com = '/dev/ttyUSB0,uDAQ_output.txt';

% Input ports values for uDAQ28/LT.
inputs = struct;
inputs.bulb = 0;
inputs.fan = 0;
inputs.led = 0;

% Output ports values for uDAQ28/LT.
outputs = struct;
outputs.fan_amp = 0;
outputs.fan_rpm = 0;
outputs.f_intens = 0;
outputs.f_temp = 0;
outputs.intens = 0;
outputs.temp = 0;

% Regulation parameters for uDAQ28/LT schema.
regparams = struct;
regparams.Kc = 20;
regparams.Ti = 10;
regparams.U_min = 20;
regparams.U_max = 80;
regparams.reg_output = 3;
regparams.reg_signal = 3;
regparams.reg_target = 45;

% Simulation parameters for uDAQ28/LT schema.
simparams = struct;
simparams.Ts = 0.1;
simparams.duration = 0;
simparams.t_sim = 10;

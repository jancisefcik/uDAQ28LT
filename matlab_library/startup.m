% Startup file for MATLAB to set up workspace on MATLAB startup.
% This file shoul be placed inside MATLAB default working directory, i.e. /home/$USER/Documents/MATLAB by default.
% Copyright (c) 2020 Jan Sefcik.

cd ~/Documents/uDAQ28LT/matlab_library;  % Change current MATLAB working directory.
addpath ~/Documents/uDAQ28LT/matlab_library;  % Add directory to MATLAB search path.
load('uDAQ28LT_variables.mat');  % Load Thermal Plant default inputs/outputs, names etc.
load_system("uDAQ28LT_system");  % Load Thermal Plant Simulink system.
matlab.engine.shareEngine("uDAQ_engine"); % Convert current MATLAB instance into shared with desired name.


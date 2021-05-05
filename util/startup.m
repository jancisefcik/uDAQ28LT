% Startup file for MATLAB to set up base workspace on MATLAB startup.
% This file should be placed inside MATLAB default working directory, i.e. /home/$USER/Documents/MATLAB by default.
% It is supposed, that repository is inside user's home, under Documents directory.
% Copyright (c) 2020 Jan Sefcik.

cd ~/Documents/uDAQ28LT/matlab_library;  % Change current MATLAB working directory.

% Add directory with uDAQ28/LT Level-2 S-Fucntion to MATLAB search path.
% If used with MATLAB r2019a or earlier, uncomment line '.../v1_2019'.
% Use only one option, even if both are working for your MATLAB version.
% Do not add both directories into search path, it can cause problems 
% During loading, compiling or running experiment in Simulink.
addpath ~/Documents/uDAQ28LT/matlab_library/v2_2021;
% addpath ~/Documents/uDAQ28LT/matlab_library/v1_2019;

addpath ~/Documents/uDAQ28LT/matlab_library/utils;  % Add directory with utilities to MATLAB search path.
load('uDAQ28LT_variables.mat');  % Load Thermal Plant default inputs/outputs, variable names etc.
load_system("uDAQ28LT_system");  % Load Thermal Plant Simulink system. 
matlab.engine.shareEngine("uDAQ_engine"); % Convert current MATLAB instance into shared with desired name.


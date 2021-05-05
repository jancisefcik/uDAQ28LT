function uDAQ28LT_fun(block)
% uDAQ28LT_fun A Level-2 MATLAB S-Function for the uDAQ28/LT thermal plant device.
% Created from template located in [matlabroot,'/toolbox/simulink/blocks/msfuntmpl_basic.m'].
% Compatibile with MATLAB r2019b and higher as it uses 'serialport'
% interface for connecting to the serial port.

%   Copyright 2003-2018 The MathWorks, Inc.
%   Copyright 2021 Jan Sefcik

% Define the instance variables: COM port, baud rate and output path
%%------------------------------------------------------------------
com_port = '';
baud_rate = '';
output_path = '';

%%
%% The setup method is used to set up the basic attributes of the
%% S-function such as ports, parameters, etc. Do not add any other
%% calls to the main body of the function.
%%
setup(block);

%endfunction

%% Function: setup ===================================================
%% Abstract:
%%   Set up the basic characteristics of the S-function block such as:
%%   - Input ports
%%   - Output ports
%%   - Dialog parameters
%%   - Options
%%
%%   Required         : Yes
%%   C MEX counterpart: mdlInitializeSizes
%%
function setup(block)

% Register number of ports.
% Inputs - bulb, fan, led
block.NumInputPorts  = 3;
% Outputs - temperature, filtered temperature, intensity, filtered intensity, fan current, fan rpm
block.NumOutputPorts = 6;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;

% Register the parameters.
% Parameters - COM port, baud rate, Ts sampling period
block.NumDialogPrms     = 3;
block.DialogPrmsTunable = {'Nontunable', 'Nontunable', 'Nontunable'};

% Register sample times
%  [0 offset]            : Continuous sample time
%  [positive_num offset] : Discrete sample time
%
%  [-1, 0]               : Inherited sample time
%  [-2, 0]               : Variable sample time
block.SampleTimes = [block.DialogPrm(3).Data 0];  % 3rd parameter is Ts

% Specify the block simStateCompliance. The allowed values are:
%    'UnknownSimState', < The default setting; warn and assume DefaultSimState
%    'DefaultSimState', < Same sim state as a built-in block
%    'HasNoSimState',   < No sim state
%    'CustomSimState',  < Has GetSimState and SetSimState methods
%    'DisallowSimState' < Error out when saving or restoring the model sim state
block.SimStateCompliance = 'DefaultSimState';

%% -----------------------------------------------------------------
%% The MATLAB S-function uses an internal registry for all
%% block methods. You should register all relevant methods
%% (optional and required) as illustrated below. You may choose
%% any suitable name for the methods and implement these methods
%% as local functions within the same file. See comments
%% provided for each function for more information.
%% -----------------------------------------------------------------

block.RegBlockMethod('CheckParameters', @CheckPrms);
block.RegBlockMethod('SetInputPortSamplingMode',@SetInputPortSamplingMode);
% block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
block.RegBlockMethod('InitializeConditions', @InitializeConditions);
block.RegBlockMethod('Start', @Start);
block.RegBlockMethod('Outputs', @Outputs); % Required
% block.RegBlockMethod('Update', @Update);
% block.RegBlockMethod('Derivatives', @Derivatives);
block.RegBlockMethod('Terminate', @Terminate);

%end setup

function CheckPrms(block)
    com = block.DialogPrm(1).Data;
    baud = block.DialogPrm(2).Data;
    Ts = block.DialogPrm(3).Data;
    
    % The first parameter should be character array e.g.:
    % '/dev/ttyUSB0,output.txt'
    if ~ischar(com)
        error('COM/OutputPath parameter should be character array!')
    end
    
    % The second parameter should be 256000, i.e. 256 kbit/s for uDAQ28LT.
    if ~isnumeric(baud) || ~isequal(baud,256000)
        error('BaudRate parameter for the uDAQ28LT should be 256 kbit/s!')
    end
    
    % The third parameter should be scalar, numeric, real, nonzero.
    if ~isscalar(Ts) || ~isnumeric(Ts) || ~isreal(Ts) || Ts == 0
        error('Ts parameter should be scalar, numeric, real, nonzero!')
    end
%end

%%
%% PostPropagationSetup:
%%   Functionality    : Setup work areas and state variables. Can
%%                      also register run-time methods here
%%   Required         : No
%%   C MEX counterpart: mdlSetWorkWidths
%%
function DoPostPropSetup(block)
    if block.SampleTimes(1) == 0
        throw(MSLException(block.BlockHandle, ...
              'The uDAQ28 library blocks can only handle discrete sample times'));
    end


%%
%% InitializeConditions:
%%   Functionality    : Called at the start of simulation and if it is 
%%                      present in an enabled subsystem configured to reset 
%%                      states, it will be called when the enabled subsystem
%%                      restarts execution to reset the states.
%%   Required         : No
%%   C MEX counterpart: mdlInitializeConditions
%%
function InitializeConditions(block)
    block.OutputPort(1).Data = 0;
    block.OutputPort(2).Data = 0;
    block.OutputPort(3).Data = 0;
    block.OutputPort(4).Data = 0;
    block.OutputPort(5).Data = 0;
    block.OutputPort(6).Data = 0;

%end InitializeConditions


%%
%% Start:
%%   Functionality    : Called once at start of model execution. If you
%%                      have states that should be initialized once, this 
%%                      is the place to do it.
%%   Required         : No
%%   C MEX counterpart: mdlStart
%%
function Start(block)
    global s_port_udaq;    

    port_param = block.DialogPrm(1).Data;
    [port, output_path] = strtok(port_param,',');
    output_path = strrep(output_path,',','');
    disp(['Output path is ->' output_path]);

    com_port = port;
    baud_rate = block.DialogPrm(2).Data;

    % Check the port parameter format.
    if ~ischar(com_port)
        error('Error: The input argument for COM port must be a string, e.g. ''COM3'' or ''/dev/ttyUSB0'' ');
    end
    
    % Check, if device is connected via USB and port is recognized.
    allports = serialportlist("all");
    if ~any(strcmp(allports,com_port))
        error(['Error: device is not connected, ''' com_port ''' not found!']);
    else
        disp(['Device is connected to ->' com_port]);
    end
    
    % Check, if serial port is available, i.e. device is not yet connected.
    freeports = serialportlist("available");
    if ~any(strcmp(freeports,com_port))
        disp(['It seems that uDAQ28 is already connected to port ' com_port ]);
        error(['Error: port ''' com_port ''' is not available!']);
    end
    
    % Check, if serial port is currently used by MATLAB.
    if isa(s_port_udaq, 'internal.Serialport') && ~any(strcmp(freeports,com_port))
        disp(['The port ' com_port ' is already used by MATLAB']);
        disp('To force disconnect the serial port, plug-out the');
        disp('cable from the device, then plug it back in.');
        error(['Error: Port ' com_port ' already used by MATLAB!']);
    end
    
    % Setup uDAQ28 device for serial communication.
    try
        s_port_udaq = serialport(com_port,9600);  % Connects to the serial port specified by 'com' with a baud rate of 9600.
        
        % Following parameters are not required to be explicitly set, because are set by default.
        % But for further purposes or other reasons, here you are...
        s_port_udaq.Parity = "none";  % Set parity to check whether data has been lost or written.
        s_port_udaq.DataBits = 8;  % Number of bits to represent one character of data.
        s_port_udaq.StopBits = 1;  % Pattern of bits that indicates the end of a character or of the whole transmission.
        s_port_udaq.Timeout = 5;  % Allowed time in seconds to complete read and write operations.

        configureTerminator(s_port_udaq, "LF");  % Terminator character for reading and writing ASCII-terminated data.

    catch err
        delete(s_port_udaq);
        disp(err);
        error('Could not set up serial port!\nCheck, if the settings of the COM port and baud rate are correct.');
    end

    % Execute external script to set custom baud rate for COM port.
    % It has to be done this way, because the uDAQ28 device requires unusual transmission speed.
    % The default serialport method cannot assign 256000 kbit/s baud rate on serial device.
    setbaud(com_port, baud_rate);

%end Start

function SetInputPortSamplingMode(block, idx, fd)
    block.InputPort(idx).SamplingMode = fd;
  
    block.OutputPort(1).SamplingMode = fd;
    block.OutputPort(2).SamplingMode = fd;
    block.OutputPort(3).SamplingMode = fd;
    block.OutputPort(4).SamplingMode = fd;
    block.OutputPort(5).SamplingMode = fd;
    block.OutputPort(6).SamplingMode = fd;
    
%%
%% Outputs:
%%   Functionality    : Called to generate block outputs in
%%                      simulation step
%%   Required         : Yes
%%   C MEX counterpart: mdlOutputs
%%
function Outputs(block)
    global s_port_udaq;

    port_param = block.DialogPrm(1).Data;
    [~,output_path] = strtok(port_param,',');
    output_path = strrep(output_path,',','');

    % SEND CMD ------------------------------------------------------------
    % Send values for light bulb, fan and LED diode.
    % Device accepts values from interval <0,255> for each variable - bulb, fan, led.
    % These values are calculated from user's input. According to documentation, user
    % can input variable values in these intervals:
    % bulb = <0,20>
    % fan = <0,6000>
    % led = <0,100>
    % If number is outside interval, the upper limit is set as input.
    bulb = fix_input(block.InputPort(1).Data, "bulb");
    fan = fix_input(block.InputPort(2).Data, "fan");
    led = fix_input(block.InputPort(3).Data, "led");

    msg = sprintf('S%d,%d,%d\n', bulb, fan, led);

    % Try to send data into serial port and device.
    try
        writeline(s_port_udaq, msg);
    catch err
        disp(err);
        delete(s_port_udaq);
        error('Error: Unable to send data.');     
    end
    % SEND CMD ------------------------------------------------------------

    % READ VAL ------------------------------------------------------------
    values = '';
    try
        values = readline(s_port_udaq);        
    catch err
        disp(err);
        delete(s_port_udaq);
        error('Error: Unable to read data.');
    end
    % READ VAL ------------------------------------------------------------
    
    % Recalculate values retireved from the device.
    r_vals = recalculate_output(values);
    
    block.OutputPort(1).Data = r_vals(1);
    block.OutputPort(2).Data = r_vals(2);
    block.OutputPort(3).Data = r_vals(3);
    block.OutputPort(4).Data = r_vals(4);
    block.OutputPort(5).Data = r_vals(5);
    block.OutputPort(6).Data = r_vals(6);

    % Append input values to the end.
    out_vals = [r_vals [block.InputPort(1).Data,block.InputPort(2).Data,block.InputPort(3).Data]];

    % Write correctly formatted data into output text file.
    % Numbers in format_spec respectively -> 'o_temp,o_ftemp,o_intens,o_fintens,o_fanamp,o_fanrpm,in_bullb,in_fan,in_led'  
    format_spec = '%2.3f,%2.3f,%2.3f,%2.3f,%2.3f,%2.3f,%2.3f,%2.3f,%2.3f\n';  % Specify format of written data.
    file_id = fopen(output_path, 'a+');  % Open output path file.
    fprintf(file_id, format_spec, out_vals);  % Write experiment data to file.
    fclose(file_id);  % Close file.
%end Outputs

%%
%% Update:
%%   Functionality    : Called to update discrete states
%%                      during simulation step
%%   Required         : No
%%   C MEX counterpart: mdlUpdate
%%
function Update(block)

% block.Dwork(1).Data = block.InputPort(1).Data;

%end Update

%%
%% Derivatives:
%%   Functionality    : Called to update derivatives of
%%                      continuous states during simulation step
%%   Required         : No
%%   C MEX counterpart: mdlDerivatives
%%
function Derivatives(block)

%end Derivatives

%%
%% Terminate:
%%   Functionality    : Called at the end of simulation for cleanup
%%   Required         : Yes
%%   C MEX counterpart: mdlTerminate
%%
function Terminate(block)
    global s_port_udaq;

    % SEND CMD ------------------------------------------------------------
    % Command to turn off the bulb, fan and LED diode.
    writeline(s_port_udaq, "S0,0,0\n");
    % SEND CMD ------------------------------------------------------------
    % Force close and delete serial port.
    delete(s_port_udaq);
%end Terminate


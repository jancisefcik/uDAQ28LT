function udaq28LTfn(block)
% udaq28LTfn A Level-2 MATLAB S-Function for the uDAQ28/LT thermal plant device.
% Created from template located in [matlabroot,'/toolbox/simulink/blocks/msfuntmpl_basic.m'].

%   Copyright 2003-2018 The MathWorks, Inc.
%   Copyright 2020 Jan Sefcik


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
block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
block.RegBlockMethod('InitializeConditions', @InitializeConditions);
block.RegBlockMethod('Start', @Start);
block.RegBlockMethod('Outputs', @Outputs);     % Required
block.RegBlockMethod('Update', @Update);
block.RegBlockMethod('Derivatives', @Derivatives);
block.RegBlockMethod('Terminate', @Terminate); % Required

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
    if ~isequal(baud,256000)
        error('BaudRate parameter for the uDAQ28LT should be 256 kbit/s!')
    end
    
    % The third parameter should be scalar, numeric, real, nonzero.
    if ~isscalar(Ts) && ~isnumeric(Ts) && ~isreal(Ts) && Ts == 0
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
    global s;    

    port_param = block.DialogPrm(1).Data;
    [port, output_path] = strtok(port_param,',');
    output_path = strrep(output_path,',','');
    disp(['Output path is ->' output_path]);

    com_port = port;
    baud_rate = block.DialogPrm(2).Data;

    % Check the port parameter format.
    if ~ischar(com_port)
        error('Error: The input argument for COM port must be a string, e.g. ''COM8'' or ''/dev/ttyUSB0'' ');
    end
    
    % Check if port is accessible.
    if exist('instrhwinfo') == 2
      serialInfo = instrhwinfo('serial');
      if isempty(find(strcmp(com_port, serialInfo.AvailableSerialPorts)))
        error(['Error: port ''' com_port ''' is not available!']);
      end
    end

    % Check, if device is already connected.
    if isa(s, 'serial') && isvalid(s) && strcmpi(get(s,'Status'),'open')
        disp(['It looks like TOS is already connected to port ' com_port ]);
        disp('Delete the object to force disconnection');
        disp('before attempting a connection to a different port.');
    end

    % Check, if serial port is currently used by MATLAB.
    if ~isempty(instrfind({'Port'},{com_port}))
        disp(['The port ' com_port ' is already used by MATLAB']);
        disp(['If you are sure that TOS is connected to ' com_port]);
        disp('then delete the object, execute:');
        disp(['  delete(instrfind({''Port''},{''' com_port '''}))']);
        disp('to delete the port, disconnect the cable, reconnect it,');
        error(['Error: Port ' com_port ' already used by MATLAB']);
    end
    
    % Setup uDAQ28 device for serial communication
    s = serial(com_port);  % Assign serial device on com_port to global variable.
    set(s, 'Terminator', 'LF');  % Set Terminator to 'LF'.
    % Following parameters are not required to be explicitly set, because are set by default.
    % But for further purposes or other reasons, here you are...
    set(s, 'Parity', 'none');  % Set Parity to 'none'.
    set(s, 'DataBits', 8);  % Set DataBits to '8'.
    set(s, 'StopBit', 1);  % Set StopBit to '1'.
    set(s, 'Timeout',10);  % Set Timeout to '10' seconds.

    % Try to open serial port.
    try
        fopen(s);
    catch
        throw(MSLException(block.BlockHandle, ...
            'Simulink:Parameters:BlkParamUndefined', ...
            'Could not open port!\nCheck, if the settings of the COM port and baud rate are correct.'));

        error(['Error: Could not open port: ' com_port]);
        delete(s);
    end

    % Execute external script to set custom baud rate for COM port.
    % This has to be done this way, because the uDAQ28 device requires unusual transmission speed.
    % The set(s, 'BaudRate', %d) function cannot assign 256000 kbit/s baud rate to serial device.
    % Path must be absolute or MATLAB path must be set to folder that contains /baudrate directory.
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
    global s;

    port_param = block.DialogPrm(1).Data;
    [~,output_path] = strtok(port_param,',');
    output_path = strrep(output_path,',','');

    % SEND CMD ------------------------------------------------------------
    % Send values for light bulb, fan and LED diode.

    % Values should be in right interval for each variable:
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
        fprintf(s, '%s', msg);
    catch err
        error(['Error: Unable to send data']);
        error(['err: ' err]);
        fclose(s);
        delete(s);
    end
    % SEND CMD ------------------------------------------------------------

    % READ VAL ------------------------------------------------------------
    values = '';
    try
        values = fscanf(s);        
    catch err
        error(['Error: Unable to read data']);
        error(['err: ' err]);
        fclose(s);
        delete(s);
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

    % Write correctly formatted data into output text file.
    
    % TODO: na ziaciatok informaciu o case a na koniec append tri vstupy.
    
    format_spec = '%2.3f,%2.3f,%2.3f,%2.3f,%2.3f,%2.3f\n';  % Specify format of written data.
    file_id = fopen(output_path, 'a+');  % Open output path file.
    fprintf(file_id, format_spec, r_vals);  % Write experiment data to file.
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
    global s;

    % SEND CMD ------------------------------------------------------------
    % Command to turn off the bulb, fan and LED diode.
    fprintf(s, 'S0,0,0\n');
    % SEND CMD ------------------------------------------------------------

    fclose(s);
    delete(s);
%end Terminate


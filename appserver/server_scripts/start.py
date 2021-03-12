#!/usr/bin/python3

import matlab.engine
from udaq_utils import create_logger, udaq_argparser


def app(args):
    leonardo = create_logger()
    leonardo.info('Leonardo initialized... inside app()...')

    leonardo.info('trying to connect MATLAB shared engine = \'uDAQ_engine\'')
    matlab_instance = matlab.engine.connect_matlab('uDAQ_engine')  # Try directly connect MATLAB

    i = 0
    if matlab_instance is None:
        leonardo.info('\'uDAQ_engine\' shared engine not found...')
        leonardo.info('trying to find any running MATLAB shared engine')
        try:
            while (len(matlab.engine.find_matlab()) == 0):
                time.sleep(5)
                i += 1
                if ((i*5) > 35):
                    leonardo.info('no shared engine found...')
                    leonardo.info('will try  to run MATLAB directly, hang on...')
                    matlab_instance = matlab.engine.start_matlab()
                    matlab_instance.desktop(nargout=0)
                    time.sleep(5)
                    break
        except Exception as ex:
            leonardo.exception('ERROR: exception while finding/runnung MATLAB.')
    
    if matlab_instance is None:
        leonardo.info('trying to connect running MATLAB shared engine')        
        matlab_instance = matlab.engine.connect_matlab(matlab.engine.find_matlab()[0])
    
    # Clear output variables in workspace from previous experiment runs.
    leonardo.info('clearing MATLAB workspace output variables...')        
    matlab_instance.workspace['o_temp'] = float(0)
    matlab_instance.workspace['o_ftemp'] = float(0)
    matlab_instance.workspace['o_intens'] = float(0)
    matlab_instance.workspace['o_fintens'] = float(0)
    matlab_instance.workspace['o_fanamp'] = float(0)
    matlab_instance.workspace['o_fanrpm'] = float(0)
    matlab_instance.workspace['duration'] = float(0)

    # Setup workspace variables for next simulation run.
    leonardo.info('setting MATLAB workspace input variables:')
    leonardo.info(args)        

    port = args["port"] + "," +  args["output_path"]
    # Simulation parameters as port, simulation time, sampling rate.
    matlab_instance.workspace['com'] = port  # COM port and output file
    matlab_instance.workspace['t_sim'] = float(args["t_sim"])  # Simulation time
    matlab_instance.workspace['Ts'] = float(args["s_rate"])/1000  # Sampling rate

    # Input values for system variables - percentual voltage for light bulb, fan and LED.
    matlab_instance.workspace['in_fan'] = float(args["in_fan"])  # Input value for fan
    matlab_instance.workspace['in_bulb'] = float(args["in_bulb"])  # Input value for light bulb
    matlab_instance.workspace['in_led'] = float(args["in_led"])  # Input value for LED diode

    # Regulator specific values.
    matlab_instance.workspace['reg_output'] = float(args["reg_output"])  # Control signal value
    matlab_instance.workspace['reg_target'] = float(args["reg_target"])  # Target value for regulator
    matlab_instance.workspace['Kc'] = float(args["Kc"])  # Kc parameter of regulator
    matlab_instance.workspace['Ti'] = float(args["Ti"])  # Ti parameter of regulator
    matlab_instance.workspace['U_min'] = float(args["U_min"])  # U_min filter parameter
    matlab_instance.workspace['U_max'] = float(args["U_max"])  # U_max filter parameter

    # Control signal for regulation, i.e. action variable.
    if args["reg_signal"] == "bulb":
        matlab_instance.workspace['reg_signal'] = float(1)
    elif args["reg_signal"] == "fan":
        matlab_instance.workspace['reg_signal'] = float(2)
    elif args["reg_signal"] == "led":
        matlab_instance.workspace['reg_signal'] = float(3)

    leonardo.info('MATLAB workspace variables set...')
    leonardo.info('trying to run Simuling simulation on uDAQ28LT_system...')

    try:
        matlab_instance.set_param('uDAQ28LT_system','SimulationCommand','start',nargout=0)
    except Exception as ex:
        leonardo.info('ERROR: exception while trying to start simulation.')
        
    # leonardo.info('simulation is running, hold on...')
    while matlab_instance.get_param('uDAQ28LT_system','SimulationStatus') != 'stopped':
        pass
    
    leonardo.info('simulation stopped, closing MATLAB instance...')
    matlab_instance.quit()

    leonardo.info('done... bye!')


if __name__ == "__main__":
    arguments = udaq_argparser()
    app(arguments)


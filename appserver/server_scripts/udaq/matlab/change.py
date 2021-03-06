#!/usr/bin/python3
import matlab.engine

from udaq_utils import create_logger, udaq_argparser


def change(args):
    leonardo = create_logger()
    leonardo.info('Leonardo initialized... inside app()...')

    leonardo.info('trying to connect MATLAB shared engine = \'uDAQ_engine\'')
    matlab_instance = matlab.engine.connect_matlab('uDAQ_engine')  # Try directly connect MATLAB

    if matlab_instance.get_param('uDAQ28LT_system','SimulationStatus') == 'stopped':
        # Simulation has stopped, nothing to change.
        leonardo.info('Simulation is stopped, nothing to change. Exit...')
        matlab_instance.quit()

        return 0

    # Update workspace variables for current simulation run.
    leonardo.info('updating MATLAB simulation parameters:')
    leonardo.info(args)        

    # Input values for system variables - light bulb, fan and LED.
    matlab_instance.workspace['inputs'] = {
        'fan':float(args['fan']),  # Input value for fan
        'bulb':float(args['bulb']),  # Input value for light bulb
        'led':float(args['led'])  # Input value for LED diode
    }

    # Output variable for regulation i.e. wanted value.
    reg_output = dict()
    if args['reg_output'] == 'temperature':
        reg_output = {'reg_output':float(1)}
    elif args['reg_output'] == 'light intensity':
        reg_output = {'reg_output':float(2)}
    elif args['reg_output'] == 'fan rpm':
        reg_output = {'reg_output':float(3)}

    # Control signal for regulation, i.e. action variable.
    reg_signal = dict()
    if args['reg_signal'] == 'bulb':
        reg_signal = {'reg_signal':float(1)}
    elif args['reg_signal'] == 'fan':
        reg_signal = {'reg_signal':float(2)}
    elif args['reg_signal'] == 'led':
        reg_signal = {'reg_signal':float(3)}

    # Regulator specific values.    
    matlab_instance.workspace['regparams'] = {
        **reg_signal, **reg_output,  # Merge values for acion variable and desired value
        'reg_target':float(args['reg_target']),  # Target value for regulator
        'Kc':float(args['Kc']),  # Kc parameter of regulator
        'Ti':float(args['Ti']),  # Ti parameter of regulator
        'U_min':float(args['U_min']),  # U_min limiter parameter
        'U_max':float(args['U_max'])  # U_max limiter parameter
    }

    matlab_instance.set_param('uDAQ28LT_system', 'SimulationCommand', 'update', nargout=0)
    matlab_instance.quit()


if __name__ == '__main__':
   args = udaq_argparser()
   change(args)



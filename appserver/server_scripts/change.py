#!/usr/bin/python3
import matlab.engine

from udaq_utils import create_logger, udaq_argparser


def app(args):
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

    # Input values for system variables - percentual voltage for light bulb, fan and LED.
    matlab_instance.workspace['in_fan'] = float(args["in_fan"])  # Input value for fan
    matlab_instance.workspace['in_bulb'] = float(args["in_bulb"])  # Input value for light bulb
    matlab_instance.workspace['in_led'] = float(args["in_led"])  # Input value for LED diode

    # Regulator specific values.
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

	matlab_instance.set_param('uDAQ28LT_system', 'SimulationCommand', 'update', nargout=0)
	matlab_instance.quit()


if __name__ == '__main__':
   args = udaq_argparser()
   app(args)



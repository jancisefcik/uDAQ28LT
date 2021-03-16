#!/usr/bin/python3

import matlab.engine

def app():
    matlab_instance = matlab.engine.connect_matlab('uDAQ_engine')  # Try directly connect MATLAB

    # Check, if there is running Simulink experiment. If not, then exit.
    if matlab_instance.get_param('uDAQ28LT_system','SimulationStatus') == 'stopped':
        matlab_instance.quit()
    else:
        # Force stop running Simulink experiment.
        matlab_instance.set_param('uDAQ28LT_system', 'SimulationCommand', 'stop', nargout=0)
        matlab_instance.quit()


if __name__ == '__main__':
   app()
#!/usr/bin/python3

import argparse
import logging


def create_logger():
    """Function to create logger and file handler for logging python scripts.
    """
    
    logger = logging.getLogger('uDAQ_logger')  # Create logger witn name 'uDAQ_logger'.
    logger.setLevel(logging.DEBUG)  # Set up logging utility with level=DEBUG (lowest)
    # Create file handler for 'uDAQ_logger'.
    fhandler = logging.FileHandler("/var/www/olm_experiment/server_scripts/udaq/matlab/uDAQ_logs/python_logfile")
    fhandler.setLevel(logging.DEBUG)
    # Specify format of LOG messages and assign it to handler.
    fmter = logging.Formatter('[%(asctime)s] - %(name)s - [%(levelname)s] - %(message)s')
    fhandler.setFormatter(fmter)
    # Assign file handler to 'uDAQ_logger' logging facility.
    logger.addHandler(fhandler)
    logger.info('_:: uDAQ Logger was initialized. ::_')

    return logger


def udaq_argparser():
    """Function to get arguments from string and parse them into single python dictionary.
    """

    parser = argparse.ArgumentParser()
    # Define parser mandatory arguments.
    parser.add_argument('--port', type=str, help='path to serial device port e.g. /dev/ttyUSB0')
    parser.add_argument('--output', type=str, help='path to output file e.g. output.txt')
    parser.add_argument('--input', type=str, help='comma separated key:value pairs of input parameters. e.g.: in_bulb:100,in_fan:100 etc...')

    arguments = dict()
    args = parser.parse_args()

    arguments['port'] = args.port
    arguments['output_path'] = args.output

    args = args.input.split(',')
    
    for kvpair in args:
        argument = kvpair.split(':')
        arguments[argument[0]] = argument[1]

    return arguments
#!/bin/bash

# Bash script to check if a MATLAB instance is running.
# If there is not a running MATLAB instance, then script
# will try to start new MATLAB process.
#
# INFO: Add this script to crontab by this:
# 1) $ chmod +x udaq_cronjob.sh
# 2) $ crontab -e
# 3) Add the following line to the end of crontab and leave newline...
# @reboot DISPLAY=:0 /home/$USER/Documents/uDAQ28LT/util/udaq_cronjob.sh
# */30 */1 * * * DISPLAY=:0 /home/$USER/Documents/uDAQ28LT/util/udaq_cronjob.sh
# ...and replace $USER with current username.
#
# This supposes that 'udaq_cronjob.sh' is called from repository, which has been pulled inside
# user's home, under Documents directory. Log file will be created in ~/cronjobs/udaq_log directory.
#
# Created on 2021/01/28 by Jan Sefcik - STU Bratislava

# First create log directory and file path
logpath="/home/udaq/udaq_cronlog"
logfile="${logpath}/matlab_runlog"

mkdir -p $logpath

if !(pgrep matlab > /dev/null)
then
  dtnow=`date`
  echo "at:$dtnow -- MATLAB is not running. Trying to start..." >> $logfile
  # Try to run matlab using start_matlab.php script using curl
  /bin/curl localhost/start_matlab.php &
else
  dtnow=`date`
  echo "at:$dtnow -- MATLAB is running. Keep working :)" >> $logfile
fi


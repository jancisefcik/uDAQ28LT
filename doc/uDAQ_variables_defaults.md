## uDAQ28/LT USB Thermal Plant default values

These are default values of uDAQ28/LT device that are
loaded into MATLAB at startup in `uDAQ_variables.mat` file.
Variable names are sorted alphabetically as they are seen
after MATLAB workspace is set.

```
baud = 256000;
com = '/dev/ttyUSB0,uDAQ_output.txt'
inputs.
    bulb = 20;
    fan = 6000;
    led = 100;
regparams.
    Kc = 10;
    Ti = 10;
    U_max = 80;
    U_min = 20;
    reg_output = 3;
    reg_signal = 3;
    reg_target = 45;
outputs.
    fan_amp = 0;
    fan_rpm = 0;
    f_intens = 0;
    f_temp = 0;
    intens = 0;
    temp = 0;
simparams.
    t_sim = 10;
    duration = 0;
    Ts = 0.1;
```

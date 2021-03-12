% Local function to recalculate input values for bulb, fan and led.
% Copyright (c) 2020 Jan Sefcik.

function res = fix_input(in_value)
    if in_value > 100
        res = round((in_value - 100) * 2.55);
    else
        res = round(in_value * 2.55);
    end
end

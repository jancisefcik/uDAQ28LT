% Local function to recalculate input values for bulb, fan and led.
% Copyright (c) 2021 Jan Sefcik.

function res = fix_input(in_value)
    if (in_value >= 0) && (in_value <= 100)
        res = round(in_value * 2.55);
    elseif (in_value < 0)
        res = 0;
    elseif (in_value > 100)
        res = 255;
    end
end

% Local function to recalculate input values for bulb, fan and led.
% Copyright (c) 2021 Jan Sefcik.

function res = fix_input(in_value, type)
    switch type
        case "bulb"            
            if (in_value >= 0) && (in_value <= 20)
                res = round(in_value * 12.75);
            else
                res = 255;
            end
        case "fan"
            if (in_value >= 0) && (in_value <= 6000)
                res = round(in_value / 23.529);
            else
                res = 255;
            end
        case "led"
            if (in_value >= 0) && (in_value <= 100)
                res = round(in_value * 2.55);
            else
                res = 255;
            end
    end
end

<?php

return [
    "start"	=>	[
        [
            "name"	=>	"in_bulb",
            "rules"	=>	"required",
            "title"	=>	"Bulb voltage (0-100)%",
            "placeholder"	=>	50,
            "type"	=>	"text"
        ],
        [
            "name"	=>	"in_fan",
            "rules"	=>	"required",
            "title"	=>	"Fan voltage (0-100)%",
            "placeholder"	=>	70,
            "type"	=>	"text"
        ],
        [
            "name"	=>	"in_led",
            "rules"	=>	"required",
            "title"	=>	"LED voltage (0-100)%",
            "placeholder"	=>	60,
            "type"	=>	"text"
        ],
        [
            "name"	=>	"Kc",
            "rules"	=>	"required",
            "title"	=>	"Kc reg. parameter",
            "placeholder"	=>	0.8,
            "type"	=>	"text"
        ],
        [
            "name"	=>	"Ti",
            "rules"	=>	"required",
            "title"	=>	"Ti reg. parameter",
            "placeholder"	=>	0.8,
            "type"	=>	"text"
        ],
        [
            "name"	=>	"U_max",
            "rules"	=>	"required",
            "title"	=>	"U_max filter parameter",
            "placeholder"	=>	80,
            "type"	=>	"text"
        ],
        [
            "name"	=>	"U_min",
            "rules"	=>	"required",
            "title"	=>	"U_min filter parameter",
            "placeholder"	=>	10,
            "type"	=>	"text"
        ],
        [
            "name"	=>	"reg_target",
            "rules"	=>	"required",
            "title"	=>	"Reg. target value (C/lx/RPM)",
            "placeholder"	=>	30,
            "type"	=>	"text"
        ],
        [
            "name"	=>	"reg_output",
            "rules"	=>	"required",
            "title"	=>	"Regulation output variable",
            "placeholder"	=>	1,
            "type"	=>	"select",
            "values" => ["bulb", "fan", "led"]
        ],
        [
            "name"	=>	"reg_signal",
            "rules"	=>	"required",
            "title"	=>	"Regulation control signal",
            "placeholder"	=>	1,
            "type"	=>	"select",
            "values" => ["bulb", "fan", "led"]
        ],
        [
            "name"	=>	"t_sim",
            "rules"	=>	"required",
            "title"	=>	"Experimant duration",
            "placeholder"	=>	10,
            "type"	=>	"text",
            "meaning" => "experiment_duration"
        ],
        [
            "name"	=>	"s_rate",
            "rules"	=>	"required",
            "title"	=>	"Sampling rate",
            "placeholder"	=>	10,
            "type"	=>	"text",
            "meaning" => "sampling_rate"
        ]
    ]
];

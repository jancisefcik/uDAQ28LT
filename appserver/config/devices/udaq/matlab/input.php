<?php

return [
    "start"	=>	[
        [
            "name"	=>	"in_bulb",
            "rules"	=>	"required",
            "title"	=>	"Bulb pwr <0-20> W",
            "placeholder"	=>	20,
            "type"	=>	"text"
        ],
        [
            "name"	=>	"in_fan",
            "rules"	=>	"required",
            "title"	=>	"Fan rpm <0-6000> Rpm",
            "placeholder"	=>	2000,
            "type"	=>	"text"
        ],
        [
            "name"	=>	"in_led",
            "rules"	=>	"required",
            "title"	=>	"LED input <0-100>%",
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
            "title"	=>	"U max",
            "placeholder"	=>	80,
            "type"	=>	"text"
        ],
        [
            "name"	=>	"U_min",
            "rules"	=>	"required",
            "title"	=>	"U min",
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
            "title"	=>	"Output variable",
            "placeholder"	=>	1,
            "type"	=>	"select",
            "values" => ["temperature", "light intensity", "fan rpm"]
        ],
        [
            "name"	=>	"reg_signal",
            "rules"	=>	"required",
            "title"	=>	"Control signal",
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
    ],
    "change"	=>	[
        [
            "name"	=>	"in_bulb",
            "rules"	=>	"required",
            "title"	=>	"Bulb pwr <0-20> W",
            "placeholder"	=>	20,
            "type"	=>	"text"
        ],
        [
            "name"	=>	"in_fan",
            "rules"	=>	"required",
            "title"	=>	"Fan rpm <0-6000> Rpm",
            "placeholder"	=>	2000,
            "type"	=>	"text"
        ],
        [
            "name"	=>	"in_led",
            "rules"	=>	"required",
            "title"	=>	"LED input <0-100>%",
            "placeholder"	=>	60,
            "type"	=>	"text"
        ],
        [
            "name"	=>	"Kc",
            "rules"	=>	"required",
            "title"	=>	"Kc reg. parameter",
            "placeholder"	=>	0,
            "type"	=>	"text"
        ],
        [
            "name"	=>	"Ti",
            "rules"	=>	"required",
            "title"	=>	"Ti reg. parameter",
            "placeholder"	=>	0,
            "type"	=>	"text"
        ],
        [
            "name"	=>	"U_max",
            "rules"	=>	"required",
            "title"	=>	"U max",
            "placeholder"	=>	0,
            "type"	=>	"text"
        ],
        [
            "name"	=>	"U_min",
            "rules"	=>	"required",
            "title"	=>	"U min",
            "placeholder"	=>	0,
            "type"	=>	"text"
        ],
        [
            "name"	=>	"reg_target",
            "rules"	=>	"required",
            "title"	=>	"Reg. target value (C/lx/RPM)",
            "placeholder"	=>	0,
            "type"	=>	"text"
        ],
        [
            "name"	=>	"reg_output",
            "rules"	=>	"required",
            "title"	=>	"Output variable",
            "placeholder"	=>	1,
            "type"	=>	"select",
            "values" => ["temperature", "light intensity", "fan rpm"]
        ],
        [
            "name"	=>	"reg_signal",
            "rules"	=>	"required",
            "title"	=>	"Control signal",
            "placeholder"	=>	1,
            "type"	=>	"select",
            "values" => ["bulb", "fan", "led"]
        ]
    ]
];

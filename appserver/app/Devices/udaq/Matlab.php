<?php

namespace App\Devices\udaq;

use App\Device;
use App\Experiment;
use App\Devices\AbstractDevice;
use App\Devices\Traits\AsyncRunnable;
use App\Devices\Contracts\DeviceDriverContract;

use App\Devices\Scripts\StartScript;
use App\Devices\Scripts\StopScript;
use App\Devices\Scripts\ChangeScript;

class Matlab extends AbstractDevice implements DeviceDriverContract {


     /**
     * Paths to read/stop/run scripts relative to
     * $(app_root)/server_scripts folder
     * @var array
     */
     protected $scriptPaths = [
        "stop"  => "udaq/matlab/stop.py",
        "start"	=> "udaq/matlab/start.py",
        "change"	=> "udaq/matlab/change.py"
    ];


    /**
     * Construct base class (App\Devices\AbstractDevice)
     * @param Device     $device     Device model from DB
     * @param Experiment $experiment Experiment model from DB
     */
     public function __construct(Device $device, Experiment $experiment)
     {
          parent::__construct($device,$experiment);
     }

     protected function start($input) 
     {
          $script = new StartScript(
               $this->scriptPaths["start"],
               $input,
               $this->device,
               $this->experimentLog->output_path
          );

          $script->run();
     }

     protected function stop()
     {
          $script = new StopScript(
                    $this->scriptPaths["stop"],
                    $this->device
               );

          $script->run();
     }

     protected function change($input)
     {
          $script = new ChangeScript(
               $this->scriptPaths["change"],
               $input,
               $this->device
          );
     
          $script->run();
     }

}
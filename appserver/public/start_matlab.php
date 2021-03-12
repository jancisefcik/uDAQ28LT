<?php
$cmd = `export DISPLAY=:0; sudo -u udaq matlab -desktop`;
shell_exec($cmd);

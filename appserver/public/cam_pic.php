<?php
    header('Content-type: image/png');
    $cmd = `sh /var/www/olm_experiment/public/capture.sh`;
    shell_exec($cmd);
    readfile("/var/www/olm_experiment/public/camera.jpeg");
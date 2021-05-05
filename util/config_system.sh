#!/bin/bash

wget https://raw.githubusercontent.com/xr09/rainbow.sh/master/rainbow.sh
source rainbow.sh

ran_from=$(pwd)

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"

echoyellow "Updatujem databazu apt"
sudo apt update

echoyellow "Stahujem a instalujem doplnkove baliky (git, curl ...)"
sudo apt install -y git curl vim tcl unzip streamer openssl openssh-server build-essential xserver-xorg-video-dummy python3-pip  python3-serial  
echoyellow "Stahujem a instalujem potrebne baliky pre experimentalny server"
sudo apt install -y apache2 mysql-server php php-cli php-curl php-mbstring php-mysql php-xml libapache2-mod-php npm nodejs python3-distutils software-properties-common

echoyellow "Stahujem Redis"
wget https://download.redis.io/redis-stable.tar.gz

echoyellow "Instalujem a konfigurujem Redis"
tar xzf redis-stable.tar.gz
cd redis-stable
make
sudo make install
sudo mkdir /etc/redis
sudo mkdir -p /var/redis/6379
sudo cp utils/redis_init_script /etc/init.d/redis_6379
sudo cp redis.conf /etc/redis/6379.conf
sudo sed -i "s/daemonize .*/daemonize yes/" /etc/redis/6379.conf
sudo sed -i "s/pidfile .*/pidfile \/var\/run\/redis_6379.pid/" /etc/redis/6379.conf
sudo sed -i "s/logfile .*/logfile \/var\/log\/redis_6379.log/" /etc/redis/6379.conf
sudo sed -i "s/dir .*/dir \/var\/redis\/6379/" /etc/redis/6379.conf
sudo update-rc.d redis_6379 defaults
sudo /etc/init.d/redis_6379 start

rm redis-stable.tar.gz
rm -rf redis-stable/

echoyellow "Nastavujem rewrite mod pre apache2"
sudo a2enmod rewrite

echoyellow "Vytvaram novu databazu a pouzivatela v mysql"
mysql -u root -proot<<MYSQL_SCRIPT
CREATE DATABASE olm_experiment;
CREATE USER 'udaq_user'@'localhost' IDENTIFIED BY 'udaq_pasvort';
GRANT ALL PRIVILEGES ON olm_experiment.* TO 'udaq_user'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

mkdir -p /var/www/
sudo chmod -R 775 /var/www
sudo chown -R www-data:www-data /var/www

echoyellow "Nastavujem konfiguracny subor stranky pre apache2"
sudo sh -c 'cat > /etc/apache2/sites-available/appserver.conf << EOL
<VirtualHost *:80>
  ServerName appserver.dev
  DocumentRoot "/var/www/olm-experiment/public"
  <Directory "/var/www/olm-experiment/public">
    AllowOverride all
  </Directory>
</VirtualHost>
EOL'

echoyellow "Deaktivujem default apache2 stranku, aktivujem stranku appserver.dev"
sudo a2ensite appserver.conf
sudo a2dissite 000-default.conf
sudo service apache2 restart

echoyellow "Pridavam appserver.dev do /etc/hosts"
sudo sh -c 'cat >> /etc/hosts << EOL
# OLM APP SERVER
127.0.0.1 appserver.dev
EOL'

echoyellow "Restartujem apahe2 a mysql"
sudo systemctl restart apache2
sudo systemctl restart mysql

echoyellow "Nastavujem prava pre pouzivatela www-data"
sudo sed -i "s/www-data:\/var\/www.*/www-data:\/var\/www:\/bin\/bash/" /etc/passwd

echoyellow "Pridavam pouzivatelov do skupiny dialout (usb/serial)"
sudo usermod -aG dialout www-data
sudo usermod -aG dialout $USER
sudo usermod -aG www-data $USER

echoyellow "Stahujem repozitar s aplikacnym serverom"
cd /var/www && sudo git clone https://bitbucket.org/rakbi/olm-experiment.git
cd /var/www/olm-experiment

echoyellow "Vytvaram dotenv subor pre webovu aplikaciu"
sudo sh -c 'cat > .env << EOL
APP_ENV=local
APP_DEBUG=true
APP_KEY=SomeRandomString
APP_URL=http://localhost

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=olm_experiment
DB_USERNAME=udaq_user
DB_PASSWORD=udaq_pasvort

CACHE_DRIVER=file
SESSION_DRIVER=file
QUEUE_DRIVER=sync

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_DRIVER=smtp
MAIL_HOST=mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
EOL'

echoyellow "Nastavujem prava adresara serveru"
sudo chown -R $USER:$USER /var/www/olm-experiment
sudo chmod -R 777 /var/www/olm-experiment

echoyellow "Stahujem a instalujem composer"
php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php
php composer-setup.php
php -r "unlink('composer-setup.php');"

echoyellow "Instalujem Laravel a baliky webovej aplikacie"
php composer.phar update
php composer.phar install
echoyellow "Inicializujem databazu webovej aplikacie"
php artisan key:generate
php artisan migrate
php artisan db:seed
php artisan config:cache

echoyellow "Instalujem node.js zavislosti"
sudo npm install

cd $ran_from
rm rainbow.sh

echoyellow "INSTALACIA A KONFIGURACIA UKONCENA"
echoyellow "Pre aplikovanie zmien je potrebne sa odhlasit a opatovne prihlasit"
Update package list and upgrade packages

```bash
$ sudo apt -y update
$ sudo apt -y upgrade
```

Install some necessary software

```bash
$ sudo apt install git python3-pip python3-distutils python3-serial vim curl software-properties-common tcl
$ sudo apt install apache2 mysql-server php php-mysql php-xml libapache2-mod-php npm nodejs
```

Add user to the 'dialout' (USB devices access) and 'www-data' groups. THen reboot to apply changes.
```bash
$ sudo usermod -a -G dialout,www-data $USER
$ sudo reboot
```

Redis installation
```
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
make test
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
```

Install MATLAB into `/usr/local/MATLAB/R2XXXy`. Activate MATLAB for user 'www-data', then change ownership and group of license file in `licenses/` directory for 'www-data' instead of 'root'.

Then retireve license for offline activation from MATLAB website, now to activate MATLAB for system user and place the license file in `~/.matlab/RXXXy_licenses/` directory. Otherwise it won't be possible to run MATLAB.

***Warning!*** MATLAB R2020a (and lower) does not support Python 3.8 yet to install and use MATLAB Engine API for Python. Therefore Python 3.7 must be installed, for example:

```bash
$ sudo add-apt-repository ppa:deadsnakes/ppa
$ sudo apt update
$ sudo apt install python3.7
```
Then install MATLAB Engine API for Python:

```bash
$ cd MATLAB_ROOT/extern/engines/python
$ sudo python3.7 setup.py install
```

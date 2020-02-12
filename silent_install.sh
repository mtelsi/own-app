
sudo apt-get -y update
dbpass=$1
export DEBIAN_FRONTEND=noninteractive
echo mysql-server-5.7.29 mysql-server/root_password password $dbpass | debconf-set-selections
echo mysql-server-5.7.29 mysql-server/root_password_again password $dbpass | debconf-set-selections

#sudo apt install software-properties-common
#sudo add-apt-repository ppa:ondrej/php
#sudo apt-get -y install php libapache2-mod-php


sudo apt-get -y install apache2 php mysql-server

echo \<center\>\<h1\>My Demo App\</h1\>\<br/\>\</center\> > /var/www/html/phpinfo.php
echo \<\?php phpinfo\(\)\; \?\> >> /var/www/html/phpinfo.php

apachectl restart


sudo apt-get -y install php-mysql php-gd php-zip php-mbstring php-xml php-curl php-simplexml php-xmlrpc php-intl

#sudo apt-get -y install php-bcmath

#sudo apt-get -y install php-json

#sudo apt-get -y install php-tokenizer


ex /etc/apache2/apache2.conf <<EOEX
  :172 s/AllowOverride None/AllowOverride All
  :x
EOEX

sudo a2enmod rewrite

#sudo systemctl restart apache2

apachectl restart


#cd /var/www/html
#sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
#sudo php -r "if (hash_file('sha384', 'composer-setup.php') === 'c5b9b6d368201a9db6f74e2611495f369991b72d9c8cbd3ffbc63edff210eb73d46ffbfce88669ad33695ef77dc76976') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
#sudo php composer-setup.php
#sudo php -r "unlink('composer-setup.php');"

cd /var/www/html

#sudo mv composer.phar /./bin/composer

free -m
sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024

sudo mkdir /home/ubuntu/demo_download

curl -O https://devsvr18.mtel.ws/demo.sql

sudo mysql --host=localhost --user=root --password=1Passw0rd357 <"/var/www/html/demo.sql"

#//use mysql

sudo mysql --user=root --password=1Passw0rd357

CREATE USER 'roche_db'@'localhost' IDENTIFIED BY '123456';

GRANT ALL PRIVILEGES ON *.* TO 'roche_db'@'localhost';

flush privileges;

quit;


cd /var/www/html

#sudo composer create-project --prefer-dist laravel/laravel demo

curl -O https://devsvr18.mtel.ws/demo.zip

sudo apt install unzip

sudo unzip demo.zip -d /var/www/html

#sudo cp demo.zip /var/www/html

cd /var/www/html

sudo apt-get -y install composer

sudo composer install 

#sudo chmod -r 777 /var/www/html/demo

cd /var/www

sudo chmod -R 755 html

sudo chmod -R o+w html/storage









#update user set authentication_string=PASSWORD("") where User='root';
#update user set plugin="mysql_native_password" where User='root';  # THIS LINE
#flush privileges;
#quit;

#// choice 2
#UPDATE user SET Password = PASSWORD('P@ssword')
#WHERE Host = '%' AND User = 'root';`enter code here

#//sudo /etc/init.d/mysql stop
#usr/sbin/mysqld --defaults-file=/etc/mysql/my.cnf --basedir=/usr --datadir=/var/lib/mysql --pid-file=/var/run/mysqld/mysqld.pid --socket=/var/run/mysqld/mysqld.sock
#//sudo /etc/init.d/mysql start




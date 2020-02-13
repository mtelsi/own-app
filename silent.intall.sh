
sudo apt-get -y update

dbpass=$1

export DEBIAN_FRONTEND=noninteractive

echo mysql-server-5.7.29 mysql-server/root_password password $dbpass | debconf-set-selections

echo mysql-server-5.7.29 mysql-server/root_password_again password $dbpass | debconf-set-selections

sudo apt-get -y install apache2 php mysql-server

echo \<center\>\<h1\>My Demo App\</h1\>\<br/\>\</center\> > /var/www/html/phpinfo.php
echo \<\?php phpinfo\(\)\; \?\> >> /var/www/html/phpinfo.php

apachectl restart


sudo apt-get -y install php-mysql php-gd php-zip php-mbstring php-xml php-curl php-simplexml php-xmlrpc php-intl

ex /etc/apache2/apache2.conf <<EOEX
  :172 s/AllowOverride None/AllowOverride All
  :x
EOEX


sudo a2enmod rewrite

apachectl restart

cd /var/www/html

curl -O https://devsvr18.mtel.ws/demo.sql

sudo mysql --host=localhost --user=root --password=1Passw0rd357 <"/var/www/html/demo.sql"


sudo mysql --user=root --password=1Passw0rd357 -e "CREATE USER 'roche_db'@'localhost' IDENTIFIED BY '123456';"

sudo mysql --user=root --password=1Passw0rd357 -e "GRANT ALL PRIVILEGES ON *.* TO 'roche_db'@'localhost';"

sudo mysql --user=root --password=1Passw0rd357 -e "FLUSH PRIVILEGES;"

sudo mysql --user=root --password=1Passw0rd357 -e "quit;"

curl -O https://devsvr18.mtel.ws/demo.zip

sudo apt install unzip

sudo unzip demo.zip -d /var/www/html

sudo apt-get -y update
sudo apt-get -y install composer
sudo composer install 

cd /var/www
sudo chmod -R 777 html
sudo chmod -R o+w html/storage

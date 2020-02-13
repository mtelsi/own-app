
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

#cd ~

#php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
#php -r "if (hash_file('sha384', 'composer-setup.php') === 'c5b9b6d368201a9db6f74e2611495f369991b72d9c8cbd3ffbc63edff210eb73d46ffbfce88669ad33695ef77dc76976') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
#php composer-setup.php
#php -r "unlink('composer-setup.php');"

#sudo mv composer.phar /./bin/composer

#free -m
#sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024

cd /var/www/html

curl -O https://devsvr18.mtel.ws/demo.sql

sudo mysql --host=localhost --user=root --password=1Passw0rd357 <"/var/www/html/demo.sql"


sudo mysql --user=root --password=1Passw0rd357 -e "CREATE USER 'roche_db'@'localhost' IDENTIFIED BY '123456';"

sudo mysql --user=root --password=1Passw0rd357 -e "GRANT ALL PRIVILEGES ON *.* TO 'roche_db'@'localhost';"

sudo mysql --user=root --password=1Passw0rd357 -e "FLUSH PRIVILEGES;"

sudo mysql --user=root --password=1Passw0rd357 -e "quit;"

#cd /var/www/html

curl -O https://devsvr18.mtel.ws/demo.zip

sudo apt install unzip

sudo unzip demo.zip -d /var/www/html

sudo apt-get -y update
sudo apt-get -y install composer
sudo composer install 

cd /var/www
sudo chmod -R 777 html
sudo chmod -R o+w html/storage

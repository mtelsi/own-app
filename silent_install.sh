sudo apt-get -y update
dbpass=$1
export DEBIAN_FRONTEND=noninteractive
echo mysql-server-5.7.29 mysql-server/root_password password $dbpass | debconf-set-selections
echo mysql-server-5.7.29 mysql-server/root_password_again password $dbpass | debconf-set-selections
sudo apt-get -y install apache2 php mysql-server
sudo apt-get -y install php-mysql php-gd php-zip php-mbstring php-simplexml php-curl php-xml php-xmlrpc php-intl
echo \<center\>\<h1\>My Demo App\</h1\>\<br/\>\</center\> > /var/www/html/phpinfo.php
echo \<\?php phpinfo\(\)\; \?\> >> /var/www/html/phpinfo.php

sudo apachectl restart

sudo ex /etc/apache2/apache2.conf <<EOEX \
  :172 s/AllowOverride None/AllowOverride All \
  :x \
EOEX

sudo apachectl restart

sudo apt-get -y install composer

EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)" \
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")" \

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ] \
then \
    >&2 echo 'ERROR: Invalid installer signature' \
    sudo rm composer-setup.php \
    exit 1 \
fi \

sudo php composer-setup.php --quiet \
RESULT=$? \
sudo rm composer-setup.php \
exit $RESULT

cd /var/www/html

sudo composer global require laravel/installer
sudo laravel new blog
sudo composer create-project --prefer-dist laravel/laravel blog
sudo php artisan serve


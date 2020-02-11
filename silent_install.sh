sudo -i
sudo apt-get -y update
dbpass=$1
export DEBIAN_FRONTEND=noninteractive
echo mysql-server-5.7.29 mysql-server/root_password password $dbpass | debconf-set-selections
echo mysql-server-5.7.29 mysql-server/root_password_again password $dbpass | debconf-set-selections
sudo apt-get -y install apache2 php mysql-server
sudo apt-get -y install php-mysql php-gd php-zip php-mbstring php-simplexml php-curl php-xml php-xmlrpc php-intl
echo \<center\>\<h1\>My Demo App\</h1\>\<br/\>\</center\> > /var/www/html/phpinfo.php
echo \<\?php phpinfo\(\)\; \?\> >> /var/www/html/phpinfo.php

ex /etc/apache2/apache2.conf <<EOEX \
  :172 s/AllowOverride None/AllowOverride All \
  :x \
EOEX

apachectl restart

EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)" \
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")" \

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ] \
then \
    >&2 echo 'ERROR: Invalid installer signature' \
    rm composer-setup.php \
    exit 1 \
fi \

php composer-setup.php --quiet \
RESULT=$? \
rm composer-setup.php \
exit $RESULT

sudo apt-get -y install composer
composer global require laravel/installer
laravel new blog
composer create-project --prefer-dist laravel/laravel blog
php artisan serve

exit

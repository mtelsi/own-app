
sudo apt-get -y update
dbpass=$1
export DEBIAN_FRONTEND=noninteractive
echo mysql-server-5.7.29 mysql-server/root_password password $dbpass | debconf-set-selections
echo mysql-server-5.7.29 mysql-server/root_password_again password $dbpass | debconf-set-selections

sudo apt-get -y install apache2 php mysql-server
sudo apt-get -y install php-mysql php-gd php-zip php-mbstring php-simplexml php-curl php-xml php-xmlrpc php-intl
apachectl restart

ex /etc/apache2/apache2.conf <<EOEX
  :172 s/AllowOverride None/AllowOverride All
  :x
EOEX

#sudo echo 'EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
#php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
#ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

#if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
#then
#    >&2 echo 'ERROR: Invalid installer checksum'
#    rm composer-setup.php
#    exit 1
#fi

#php composer-setup.php --quiet
#RESULT=$?
#rm composer-setup.php
#exit $RESULT' > /home/ubuntu/installcomposer.sh

#sudo chmod +x /home/ubuntu/installcomposer.sh
#sudo /home/ubuntu/installcomposer.sh
cd /var/www/html
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'c5b9b6d368201a9db6f74e2611495f369991b72d9c8cbd3ffbc63edff210eb73d46ffbfce88669ad33695ef77dc76976') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

free -m

sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
sudo /sbin/mkswap /var/swap.1
sudo /sbin/swapon /var/swap.1

cd /tmp
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /./bin/composer
cd /var/www/html
sudo composer create-project laravel/laravel your-project --prefer-dist
sudo chgrp -R www-data /var/www/html/your-project
sudo chmod -R 775 /var/www/html/your-project/storage
cd /etc/apache2/sites-available

sudo echo "<VirtualHost *:80>
    ServerName yourdomain.tld

    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html/your-project/public

    <Directory /var/www/html/your-project>
        AllowOverride All
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" > /etc/apache2/sites-available/laravel.conf

#sudo a2dissite 000-default.conf
#sudo a2ensite laravel.conf
#sudo a2enmod rewrite
sudo service apache2 restart



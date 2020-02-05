
#!/bin/bash
sudo apt-get -y update

#CA cert
#sudo apt-get -y install ca-certificates curl apt-transport-https lsb-release gnupg

#MS signing key
#curl -sL https://packages.microsoft.com/keys/microsoft.asc | 
#    gpg --dearmor | 
#    sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null

#azure cli
#AZ_REPO=$(lsb_release -cs)
#echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | 
#    sudo tee /etc/apt/sources.list.d/azure-cli.list

#update repository
#sudo apt-get update
#sudo apt-get install azure-cli

# set up a silent install of MySQL
dbpass=$1

export DEBIAN_FRONTEND=noninteractive
echo mysql-server-5.7.29 mysql-server/root_password password $dbpass | debconf-set-selections
echo mysql-server-5.7.29 mysql-server/root_password_again password $dbpass | debconf-set-selections

# install app
apt-get -y install apache2 php mysql-server php-mysql php-gd php-zip php-mbstring php-simplexml

# write some PHP
echo \<center\>\<h1\>My Demo App\</h1\>\<br/\>\</center\> > /var/www/html/phpinfo.php
echo \<\?php phpinfo\(\)\; \?\> >> /var/www/html/phpinfo.php

# restart Apache
apachectl restart

#! /bin/bash

##### INFO #####

# provision-phpmyadmin.sh
#
# This script will provision a clean Vagrant box.
# After provisioning a box, it can be repackaged.
# So that project setup time can be reduced.
#

##### VARIABLES #####

# Throughout this script, some variables are used, these are defined first.
# These variables can be altered to fit your specific needs or preferences.

# MySQL ROOT password
MYSQL_ROOT_PASSWORD="MYSQL_ROOT_PASSWORD"

# MySQL phpmyadmin user password
MYSQL_PMA_PASSWORD="MYSQL_PMA_PASSWORD"

# Apache VHOST
APACHE_VHOST="/etc/apache2/sites-enabled/000-default"

# Apache Alias
PHPMYADMIN_APACHE_ALIAS='\n\tAlias \/phpmyadmin "\/var\/www\/phpmyadmin"\n\t<Directory "\/var\/www\/phpmyadmin">\n\t\tOptions FollowSymlinks\n\t\tAllowOverride None\n\t\tOrder allow,deny\n\t\tAllow from all\n\t<\/Directory>\n\n'

#----- end of configurable variables -----#


##### PROVISION CHECK ######

# The provision check is intented to not run the full provision script when a box has already been provisioned.
# At the end of this script, a file is created on the vagrant box, we'll check if it exists now.
echo "[vagrant provisioning] Checking if the box was already provisioned for Phpmyadmin..."

if [ -e "/home/vagrant/.provision_check_phpmyadmin" ]
then
  # Skipping provisioning if the box is already provisioned
  echo "[vagrant provisioning] The box is already provisioned for Web..."
  exit
fi


##### PROVISION PHPMYADMIN #####

echo "[vagrant provisioning] Installing PHPMYADMIN ..."

# install phpmyadmin
mkdir /vagrant/phpmyadmin/ 2> /dev/null
wget -O /vagrant/phpmyadmin/index.html http://www.phpmyadmin.net/
awk 'BEGIN{ RS="<a *href *= *\""} NR>2 {sub(/".*/,"");print; }' /vagrant/phpmyadmin/index.html >> /vagrant/phpmyadmin/url-list.txt
grep "http://sourceforge.net/projects/phpmyadmin/files/phpMyAdmin/" /vagrant/phpmyadmin/url-list.txt > /vagrant/phpmyadmin/phpmyadmin.url
sed -i 's/.zip/.tar.bz2/' /vagrant/phpmyadmin/phpmyadmin.url
wget -O /vagrant/phpmyadmin/phpMyAdmin.tar.bz2 `cat /vagrant/phpmyadmin/phpmyadmin.url`
sudo mkdir /var/www/phpmyadmin
sudo tar jxvf /vagrant/phpmyadmin/phpMyAdmin.tar.bz2 -C /var/www/phpmyadmin --strip 1
rm -rf /vagrant/phpmyadmin 2> /dev/null

echo "[vagrant provisioning] Configuring PHPMYADMIN ..."
# configure phpmyadmin
sudo mv /var/www/phpmyadmin/config.sample.inc.php /var/www/phpmyadmin/config.inc.php
sudo sed -i 's/a8b7c6d/NEWBLOWFISHSECRET/' /var/www/phpmyadmin/config.inc.php
echo "CREATE DATABASE pma" | mysql -uroot -p${MYSQL_ROOT_PASSWORD}
echo "CREATE USER 'pma'@'localhost' IDENTIFIED BY '${MYSQL_PMA_PASSWORD}'" | mysql -uroot -p${MYSQL_ROOT_PASSWORD}
echo "GRANT ALL ON pma.* TO 'pma'@'localhost'" | mysql -uroot -p${MYSQL_ROOT_PASSWORD}
echo "GRANT ALL ON phpmyadmin.* TO 'pma'@'localhost'" | mysql -uroot -p${MYSQL_ROOT_PASSWORD}
echo "flush privileges" | mysql -uroot -p${MYSQL_ROOT_PASSWORD}
mysql -D pma -u pma -p${MYSQL_PMA_PASSWORD} < /var/www/phpmyadmin/examples/create_tables.sql

sudo mv /var/www/phpmyadmin/config.inc.php /var/www/phpmyadmin/config.inc.php.default
sudo cp /vagrant/vagrant-scripts/resources/phpmyadmin.config.inc.php /var/www/phpmyadmin/config.inc.php
sudo chmod o-rw /var/www/phpmyadmin/config.inc.php

# add alias to Vhost
sudo sed -i "s/<\/VirtualHost>/${PHPMYADMIN_APACHE_ALIAS}<\/VirtualHost>/" ${APACHE_VHOST}

sudo service apache2 restart

##### PROVISION CHECK #####

# Create .provision_check_phpmyadmin for the script to check on during a next vargant up.
echo "[vagrant provisioning] Creating .provision_check_phpmyadmin file..."
touch .provision_check_phpmyadmin

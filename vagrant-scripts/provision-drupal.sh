#! /bin/bash

##### INFO #####

# provision-drupal.sh
#
# This script will provision a clean Vagrant box.
# After provisioning a box, it can be repackaged.
# So that project setup time can be reduced.
#

##### VARIABLES #####

# Throughout this script, some variables are used, these are defined first.
# These variables can be altered to fit your specific needs or preferences.

# Drush
DRUSH_VERSION="6.2.0" # prefered Drush release from https://github.com/drush-ops/drush/releases

#----- end of configurable variables -----#


##### PROVISION CHECK ######

# The provision check is intented to not run the full provision script when a box has already been provisioned.
# At the end of this script, a file is created on the vagrant box, we'll check if it exists now.
echo "[vagrant provisioning] Checking if the box was already provisioned for Drupal..."

if [ -e "/home/vagrant/.provision_check_drupal" ]
then
  # Skipping provisioning if the box is already provisioned
  echo "[vagrant provisioning] The box is already provisioned for Drupal..."
  exit
fi


##### PROVISION DRUPAL TOOLS #####

# Install Drush
echo "[vagrant provisioning] Installing drush..."
sudo wget -q https://github.com/drush-ops/drush/archive/$DRUSH_VERSION.tar.gz # download drush from github
sudo tar -C /opt/ -xzf $DRUSH_VERSION.tar.gz # untar drush in /opt
sudo chown -R vagrant:vagrant /opt/drush-$DRUSH_VERSION # ensure the vagrant user has sufficiënt rights
sudo ln -s /opt/drush-$DRUSH_VERSION/drush /usr/sbin/drush # add drush to /usr/sbin
sudo rm -rf /home/vagrant/$DRUSH_VERSION.tar.gz # remove the downloaded tarbal

##### CLEAN UP #####

sudo dpkg --configure -a # when upgrade or install doesnt run well (e.g. loss of connection) this may resolve quite a few issues
apt-get autoremove -y # remove obsolete packages


##### PROVISION CHECK #####

# Create .provision_check for the script to check on during a next vargant up.
echo "[vagrant provisioning] Creating .provision_check_drupal file..."
touch .provision_check_drupal
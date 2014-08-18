#!/bin/bash

##### INFO #####

# provision-node.sh
#
# This script will provision a clean Vagrant box.
# After provisioning a box, it can be repackaged.
# So that project setup time can be reduced.
#

##### PROVISION NODE #####

# Download and update package lists
echo "[vagrant provisioning] Package manager updates..."
sudo apt-get update
sudo apt-get install -y curl # curl
sudo apt-get install -y make # make is not installed by default believe it or not

# Install or update nfs-common to the latest release
echo "[vagrant provisioning] Installing nfs-common..."
sudo apt-get install -y nfs-common # commonly installed on Ubuntu but not on all Linux distros

# Install Node
echo "[vagrant provisioning] Installing node..."
curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get install nodejs -y

##### CLEAN UP #####
sudo dpkg --configure -a # when upgrade or install doesnt run well (e.g. loss of connection) this may resolve quite a few issues
sudo apt-get autoremove -y # remove obsolete packages

##### EXTRA #####
sudo apt-get install git -y
sudo npm install -g grunt-cli bower yo
sudo gem update --system
sudo gem install sass
sudo gem install compass

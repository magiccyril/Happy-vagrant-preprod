#!/bin/bash

##### INFO #####

# provision-jekyll.sh
#
# This script will provision a clean Vagrant box.
# After provisioning a box, it can be repackaged.
# So that project setup time can be reduced.
#

##### PROVISION JEKYLL #####

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

# Install Ruby
echo "[vagrant provisioning] Installing Ruby 1.9 ..."
sudo apt-get install ruby1.9.1 ruby1.9.1-dev \
  rubygems1.9.1 irb1.9.1 ri1.9.1 rdoc1.9.1 \
  build-essential libopenssl-ruby1.9.1 libssl-dev zlib1g-dev -y

sudo update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby1.9.1 400 \
         --slave   /usr/share/man/man1/ruby.1.gz ruby.1.gz \
                        /usr/share/man/man1/ruby1.9.1.1.gz \
        --slave   /usr/bin/ri ri /usr/bin/ri1.9.1 \
        --slave   /usr/bin/irb irb /usr/bin/irb1.9.1 \
        --slave   /usr/bin/rdoc rdoc /usr/bin/rdoc1.9.1

# Install Jekyll
echo "[vagrant provisioning] Installing jekyll..."
sudo gem install jekyll

##### CLEAN UP #####
sudo dpkg --configure -a # when upgrade or install doesnt run well (e.g. loss of connection) this may resolve quite a few issues
sudo apt-get autoremove -y # remove obsolete packages

##### EXTRA #####
sudo apt-get install git -y
sudo npm install -g grunt-cli bower yo
sudo gem install sass
sudo gem install compass

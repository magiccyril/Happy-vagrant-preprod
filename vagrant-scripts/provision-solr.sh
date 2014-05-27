#! /bin/bash

##### INFO #####

# provision-solr.sh
#
# This script will provision a clean Vagrant box.
# After provisioning a box, it can be repackaged.
# So that project setup time can be reduced.
#

##### VARIABLES #####

# Throughout this script, some variables are used, these are defined first.
# These variables can be altered to fit your specific needs or preferences.

# Apache Solr
SOLR_VERSION="4.6.1"
SOLR_MIRROR="http://xenia.sote.hu/ftp/mirrors/www.apache.org"

##### PROVISION CHECK ######

# The provision check is intented to not run the full provision script when a box has already been provisioned.
# At the end of this script, a file is created on the vagrant box, we'll check if it exists now.
echo "[vagrant provisioning] Checking if the box was already provisioned for Solr..."

if [ -e "/home/vagrant/.provision_check_solr" ]
then
  # Skipping provisioning if the box is already provisioned
  echo "[vagrant provisioning] The box is already provisioned for Solr..."
  exit
fi

# Install Apache Solr - based on article from Tomasz Muras - https://twitter.com/zabuch
# http://jmuras.com/blog/2012/setup-solr-4-tomcat-ubuntu-server-12-04-lts/
echo "[vagrant provisioning] Installing Apache Solr..."
sudo apt-get install -y tomcat7
cd /tmp/
sudo wget -q $SOLR_MIRROR/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz
tar xzf solr-$SOLR_VERSION.tgz
sudo cp -fr solr-$SOLR_VERSION/example/solr /opt/solr
sudo cp solr-$SOLR_VERSION/example/webapps/solr.war /opt/solr/
sudo cp solr-$SOLR_VERSION/example/lib/ext/* /var/lib/tomcat7/shared/
sudo sed -i 's/solr.data.dir:/solr.data.dir:\/opt\/solr\/data\//g' /opt/solr/collection1/conf/solrconfig.xml
sudo mkdir /opt/solr/data
sudo chown tomcat7 /opt/solr/data
sudo cp /vagrant/vagrant-scripts/resources/solr.xml /etc/tomcat7/Catalina/localhost/
sudo /etc/init.d/tomcat7 restart

##### CLEAN UP #####

sudo dpkg --configure -a # when upgrade or install doesnt run well (e.g. loss of connection) this may resolve quite a few issues
apt-get autoremove -y # remove obsolete packages


##### PROVISION CHECK #####

# Create .provision_check_solr for the script to check on during a next vargant up.
echo "[vagrant provisioning] Creating .provision_check_solr file..."
touch .provision_check_solr

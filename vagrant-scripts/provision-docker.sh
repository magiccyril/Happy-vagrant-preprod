#!/bin/bash

# Locale
LOCALE_LANGUAGE="fr_FR" # can be altered to your prefered locale, see http://docs.moodle.org/dev/Table_of_locales
LOCALE_CODESET="fr_FR.UTF-8"
sudo locale-gen $LOCALE_LANGUAGE $LOCALE_CODESET

# Timezone
TIMEZONE="Europe/Paris" # can be altered to your specific timezone, see http://manpages.ubuntu.com/manpages/jaunty/man3/DateTime::TimeZone::Catalog.3pm.html
echo $TIMEZONE | sudo tee /etc/timezone
sudo dpkg-reconfigure --frontend noninteractive tzdata

# Download and update package lists
sudo apt-get update

# Install docker.io
curl -sSL https://get.docker.com/ubuntu/ | sudo sh

# Install Fig
curl -L https://github.com/docker/fig/releases/download/1.0.1/fig-`uname -s`-`uname -m` > ~/fig; sudo mv ~/fig /usr/local/bin/fig; chmod +x /usr/local/bin/fig
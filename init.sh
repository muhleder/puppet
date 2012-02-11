#!/bin/bash
<<<<<<< HEAD
=======
####################################
# Run this script to install requirements
# and pull latest version of puppet code.
####################################

>>>>>>> 4f5594b2aa54b7342cec67fd1b19a8b8bb4bc97c

####################################
# Make sure only root can run our script
####################################
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

####################################
# Run without prompts whilst installing
####################################
sudo DEBIAN_FRONTEND=noninteractive



####################################
# Install required packages
####################################
sudo apt-get -y -q install puppet git-core


####################################
# Set puppet module folder
# TODO check if already set
####################################
sudo echo "modulepath=/var/puppet/modules" >> /etc/puppet/puppet.conf


####################################
# Create puppet files folder
####################################
if [ ! -d /etc/puppet/files ]
then
    echo "Creating puppet files folder"
    sudo mkdir /etc/puppet/files
fi


####################################
# Pull down the puppet configs
####################################
if [ ! -d /var/puppet ]
then
  git clone git://github.com/muhleder/puppet.git /var/puppet
  chmod 774 /var/puppet/install.sh
fi
#!/bin/bash
#Install MDSplus, configured for use at MIT PSFC
#
#T. Golfinopoulos, 26 Mar. 2018

echo -n "Enter your C-Mod username: "
read USERNM

#Install MDSplus source
sudo echo "deb http://www.mdsplus.org/dist/Ubuntu16/repo MDSplus stable" > /etc/apt/sources.list.d/mdsplus.list

# Install MDSplus signing key
sudo wget http://www.mdsplus.org/dist/mdsplus.gpg.key
sudo apt-key add mdsplus.gpg.key

# Update repository cache, install xinetd, and install MDSplus
sudo apt-get update
sudo apt-get install xinetd
sudo apt-get install libmotif-dev # Installs libraries necessary for rendering objects in MDSplus applications like traverser, dwscope, etc.
sudo apt-get install mdsplus # Installs all the MDSplus packages
sudo apt-get install xorg #Need to install XWindows
sudo apt-get install twm

# Copy C-Mod environment variable setup scripts
sudo rsync -avz $USERNM@cmodws100.psfc.mit.edu:/usr/local/mdsplus/local /usr/local/mdsplus

# Append C-Mod data servers to /etc/hosts so that hostnames are resolved to correct IP addresses
sudo echo "# Added $(date) from mdsplus_setup.sh" >> /etc/hosts
sudo echo "198.125.180.202 alcdata-test" >> /etc/hosts
sudo echo "198.125.180.202 alcdata-new" >> /etc/hosts
sudo echo "198.125.180.202 alcdata" >> /etc/hosts
sudo echo "198.125.180.202 alcdata-saved" >> /etc/hosts
sudo echo "198.125.180.202 alcdata-models" >> /etc/hosts
sudo echo "198.125.177.171 alcdata-archives" >> /etc/hosts

#Add mdsplus-local folder
sudo mkdir /usr/local/cmod
sudo rsync -avz golfit@cmodws107:/usr/local/cmod/mdsplus-local /usr/local/cmod
sudo rsync -avz golfit@cmodws107:/usr/local/cmod/sbin /usr/local/cmod

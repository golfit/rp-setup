#~/bin/sh
#This script is meant to package together commands useful for configuring the Red Pitaya OS, especially with regard to setting up MDSplus for operation within the C-Mod environment.
#
#T. Golfinopoulos, 28 Dec. 2017

echo -n "Enter the hostname of this Red Pitaya (e.g. rp#.psfc.mit.edu):"
read RP_HOST
echo ""
echo -n "Enter the IP address of this Red Pitaya (e.g. 198.123.456.789):"
read RP_IP
echo -n "Enter your C-Mod username:"
read USERNM

# Append host information to /etc/hosts file
echo "# Added $(date) from rp_setup.sh" >> /etc/hosts
echo "127.0.0.1 localhost" >> /etc/hosts
echo "$RP_IP $(uname -n)" >> /etc/hosts #Associate hostname with IP
echo "$RP_IP $RP_HOST" >> /etc/hosts #Associate hostname with IP

echo "deb http://www.mdsplus.org/dist/raspberrypi/repo MDSplus alpha" > /etc/apt/sources.list.d/mdsplus.list

# Install MDSplus signing key
wget http://www.mdsplus.org/dist/mdsplus.gpg.key
sudo apt-key add mdsplus.gpg.key

# Update repository cache, install xinetd, and install MDSplus
sudo apt-get update
sudo apt-get install xinetd
sudo apt-get install mdsplus # Installs all the MDSplus packages

# Copy C-Mod environment variable setup scripts
scp $USERNM@cmodws100.psfc.mit.edu:/usr/local/mdsplus/local/ /usr/local/mdsplus

# Append C-Mod data servers to /etc/hosts so that hostnames are resolved to correct IP addresses
echo "# Added $(date) from rp_setup.sh" >> /etc/hosts
echo "198.125.180.202 alcdata-test" >> /etc/hosts
echo "198.125.180.202 alcdata-new" >> /etc/hosts
echo "198.125.180.202 alcdata" >> /etc/hosts
echo "198.125.180.202 alcdata-saved" >> /etc/hosts
echo "198.125.180.202 alcdata-models" >> /etc/hosts
echo "198.125.177.171 alcdata-archives" >> /etc/hosts

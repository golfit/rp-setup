#~/bin/sh
#This script is meant to package together commands useful for configuring the Red Pitaya OS, especially with regard to setting up MDSplus for operation within the C-Mod environment.
#
#T. Golfinopoulos, 28 Dec. 2017

echo -n "Enter the hostname of this Red Pitaya (e.g. rp#.psfc.mit.edu):"
read RP_HOST
echo ""
echo -n "Enter the eth0 IP address of this Red Pitaya (e.g. 198.123.456.789):"
read RP_IP
echo -n "Enter the wlan0 IP address of this Red Pitaya (e.g. 198.123.456.789):"
read RP_WIP
echo -n "Enter your C-Mod username:"
read USERNM

# Make sure data is correct
echo "You entered:"
echo "Hostname: $RP_HOST"
echo "eth0 IP: $RP_IP"
echo "eth0 IP: $RP_WIP"
echo "Username: $USERNM"
echo "Check if this is correct, and keep in mind that you will permanently remove old configuration.  Proceed? (y/n)"
read USER_ANS

if [[ "$USER_ANS" != *[nN]* ]]; then #Note: white space matters between double brackets and arguments, as well as between operators (e.g. binary operators) and arguments
    # Set up wired network IP address
    echo "[Match]" > /etc/systemd/network/wired.network # Rewrite file - CAREFUL!  You are eliminating old configuration
    echo "Name=eth0" >> /etc/systemd/network/wired.network # Now Append
    echo "[Network]" >> /etc/systemd/network/wired.network
    echo "LinkLocalAddressing=yes" >> /etc/systemd/network/wired.network
    echo "Address=$RP_IP/21" >> /etc/systemd/network/wired.network
    echo "Gateway=198.125.176.10" >> /etc/systemd/network/wired.network #This will need to change on different networks
    echo "DNS=198.125.177.103" >> /etc/systemd/network/wired.network #This will need to change on different networks
    echo "IPForward=yes" >> /etc/systemd/network/wired.network
    echo "IPMasquerade=yes" >> /etc/systemd/network/wired.network
    echo "[Address]" >> /etc/systemd/network/wired.network

    # Set up wireless network IP address
    echo "[Match]" > /etc/systemd/network/wireless.network # Rewrite file - CAREFUL!  You are eliminating old configuration
    echo "Name=wlan*" >> /etc/systemd/network/wireless.network
    echo "" >> /etc/systemd/network/wireless.network
    echo "[Network]" >> /etc/systemd/network/wireless.network
    echo "LinkLocalAddressing=yes" >> /etc/systemd/network/wireless.network
    echo "Address=$RP_WIP/21" >> /etc/systemd/network/wireless.network
    echo "Gateway=198.125.176.10" >> /etc/systemd/network/wireless.network #This will need to change on different networks
    echo "DNS=198.125.177.103" >> /etc/systemd/network/wireless.network #This will need to change on different networks
    echo "IPForward=yes" >> /etc/systemd/network/wireless.network
    echo "IPMasquerade=yes" >> /etc/systemd/network/wireless.network

    # Append host information to /etc/hosts file
    echo "# Added $(date) from rp_setup.sh" >> /etc/hosts
    echo "127.0.0.1 localhost" >> /etc/hosts
    echo "$RP_IP $(uname -n)" >> /etc/hosts #Associate hostname with IP
    echo "$RP_IP $RP_HOST" >> /etc/hosts #Associate hostname with IP

    echo "deb http://www.mdsplus.org/dist/raspberrypi/repo MDSplus alpha" > /etc/apt/sources.list.d/mdsplus.list

    # Install MDSplus signing key
    sudo wget http://www.mdsplus.org/dist/mdsplus.gpg.key
    sudo apt-key add mdsplus.gpg.key

    # Update repository cache, install xinetd, and install MDSplus
    sudo apt-get update
    sudo apt-get install xinetd
    sudo apt-get install mdsplus # Installs all the MDSplus packages
    sudo apt-get install libmotif-dev # Installs libraries necessary for rendering objects in MDSplus applications like traverser, dwscope, etc.
    sudo apt-get install xorg #Need to install XWindows
    sudo apt-get install twm

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
fi

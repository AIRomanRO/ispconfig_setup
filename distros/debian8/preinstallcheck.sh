#---------------------------------------------------------------------
# Function: PreInstallCheck
#    Do some pre-install checks
#---------------------------------------------------------------------
PreInstallCheck() {
    # Check if user is root
    if [ $(id -u) != "0" ]; then
        echo -n "Error: You must be root to run this script, please use the root user to install the software."
        exit 1
    fi
  
    # Check connectivity
    echo -n "Checking internet connection... "
    ping -q -c 3 www.ispconfig.org > /dev/null 2>&1

    if [ ! "$?" -eq 0 ]; then
        echo -e "[ ${red}ERROR ]: Couldn't reach www.ispconfig.org, please check your internet connection${NC}"
        exit 1;
	else
	    echo -e " [ ${green}OK${NC} ]"
    fi
  
    # Check for already installed ispconfig version
    if [ -f /usr/local/ispconfig/interface/lib/config.inc.php ]; then
        echo "ISPConfig is already installed, can't go on."
	    exit 1
    fi
  
	echo -n "Check for pre-required packages\n"
	
	#Check for whiptail
	if [ -f /bin/whiptail ] || [ -f /usr/bin/whiptail ]; then
     	echo -ne " - ${BBlack}Whiptail${NC}: ${green}FOUND${NC}"
    else
	    echo -ne " - ${BBlack}Whiptail${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
        apt-get -yqq install whiptail > /dev/null 2>&1
		echo -e " [ ${green}DONE${NC} ]"
	fi
	
	#Check for htop
	if [ -f /bin/htop ] || [ -f /usr/bin/htop ]; then
     	echo -ne " - ${BBlack}HTOP${NC}: ${green}FOUND${NC}"
    else
	    echo -ne " - ${BBlack}HTOP${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
        apt-get -yqq install htop > /dev/null 2>&1
		echo -e " [ ${green}DONE${NC} ]"
	fi
	
	#Check for nano
	if [ -f /bin/nano ] || [ -f /usr/bin/nano ]; then
     	echo -ne " - ${BBlack}NANO${NC}: ${green}FOUND${NC}"
    else
	    echo -ne " - ${BBlack}NANO${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
        apt-get -yqq install nano > /dev/null 2>&1
		echo -e " [ ${green}DONE${NC} ]"
	fi
	
	#Check for debconf-utils
	if [ -f /bin/debconf ] || [ -f /usr/bin/debconf ]; then
     	echo -ne " - ${BBlack}debconf-utils${NC}: ${green}FOUND${NC}"
    else
	    echo -ne " - ${BBlack}debconf-utils${NC}: ${red}NOT FOUNDED${NC} - start and install it ... "
        apt-get -yqq install debconf-utils > /dev/null 2>&1
		echo -e " [ ${green}DONE${NC} ]"
	fi
	
    touch /etc/inetd.conf
  
    echo -ne "Adding Debian backports - ${BBlack}Required for Letsencrypt${NC}"
  
    #Add Debian backports - Required for Letsencrypt
    echo "###############################################################
# Debian backports - Required for Letsencrypt
deb http://ftp.debian.org/debian jessie-backports main
###############################################################" >> /etc/apt/sources.list.d/jessie-backports.list
  
    echo -e " [ ${green}DONE${NC} ]"
  
    echo -ne "Adding PHP 7.0 - ${BBlack}DotDeb repo${NC}"
  
    #Add dotdeb repo for php
    echo "###############################################################
#php  7
deb http://packages.dotdeb.org jessie all
deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list.d/dotdeb-PHP7.0.list
    wget -q https://www.dotdeb.org/dotdeb.gpg && sudo apt-key add dotdeb.gpg
  
    echo -e " [ ${green}DONE${NC} ]"
  
    echo -ne "Adding ${BBlack}latest nginx version repo${NC}"
    #Add latest nginx version
    echo "###############################################################
#latest nginx version
deb http://nginx.org/packages/mainline/debian/ jessie nginx

deb-src http://nginx.org/packages/mainline/debian/ jessie nginx
###############################################################" >> /etc/apt/sources.list.d/nginx-latest-official.list
    wget -q https://nginx.org/keys/nginx_signing.key && sudo apt-key add nginx_signing.key
	
    echo -e " [ ${green}DONE${NC} ]"

	echo -ne "Adding ${BBlack}debian-stretch sources ${NC}"
    #Add the debian-stretch sources
    echo "###############################################################
deb http://httpredir.debian.org/debian/ stretch main contrib non-free
deb-src http://httpredir.debian.org/debian/ stretch main contrib non-free

deb http://security.debian.org/ stretch/updates main contrib non-free
deb-src http://security.debian.org/ stretch/updates main contrib non-free

# stretch-updates, previously known as 'volatile'
deb http://httpredir.debian.org/debian/ stretch-updates main contrib non-free
deb-src http://httpredir.debian.org/debian/ stretch-updates main contrib non-free
###############################################################" >> /etc/apt/sources.list.d/debian-stretch.list
    echo -e " [ ${green}DONE${NC} ]"
	
	echo -ne "Configure ${BBlack}sources priority via PIN${NC}"
    echo "##############################
Package: *
Pin: release n=jessie
Pin-Priority: 900

Package: * 
Pin: release a=jessie-backports
Pin-Priority: 500

Package: *
Pin: release n=stretch
Pin-Priority: 100
####################################" >> /etc/apt/preferences

    echo -e " [ ${green}DONE${NC} ]"
	
	echo -ne "Pre Install Check - [${green}Completed{$NC}]\n"
}


